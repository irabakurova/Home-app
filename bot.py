"""
Easily Kitchen — Receipt Bot
Читает фото чека через Qwen-VL, добавляет продукты в Кладовую (Firestore).
"""

import os
import json
import logging
import base64
import uuid
import time
from io import BytesIO

from dotenv import load_dotenv
from telegram import Update
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    filters,
    ContextTypes,
)
from openai import OpenAI
import firebase_admin
from firebase_admin import credentials, firestore

load_dotenv()
logging.basicConfig(
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    level=logging.INFO,
)
log = logging.getLogger(__name__)

# ── Config ────────────────────────────────────────────────────────────────────

TELEGRAM_TOKEN   = os.environ["TELEGRAM_TOKEN"]
DASHSCOPE_KEY    = os.environ["DASHSCOPE_API_KEY"]
FIREBASE_CRED    = os.environ.get("FIREBASE_CREDENTIALS_JSON")  # JSON-строка
FAMILY_ID        = "default_family"

# Только эти пользователи могут писать боту (Telegram user_id)
# Оставь пустым [] чтобы разрешить всем
ALLOWED_USERS: list[int] = []  # пример: [123456789, 987654321]

# ── Firebase init ─────────────────────────────────────────────────────────────

def _init_firebase():
    if FIREBASE_CRED:
        cred_dict = json.loads(FIREBASE_CRED)
        cred = credentials.Certificate(cred_dict)
    else:
        # Локально: файл serviceAccountKey.json рядом с bot.py
        cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)
    return firestore.client()

db = _init_firebase()

# ── Qwen client ───────────────────────────────────────────────────────────────

qwen = OpenAI(
    api_key=DASHSCOPE_KEY,
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
)

# ── Prompt ────────────────────────────────────────────────────────────────────

SYSTEM_PROMPT = """Ты анализируешь фото кассового чека из магазина.
Твоя задача — извлечь все купленные ПРОДУКТЫ ПИТАНИЯ.
Игнорируй: бытовую химию, косметику, товары не для еды.

Верни ТОЛЬКО валидный JSON-массив (без объяснений, без markdown):
[
  {"name": "Молоко", "quantity": 1.0, "unit": "л", "category": "dairy"},
  {"name": "Яйца С1", "quantity": 10.0, "unit": "шт", "category": "other"}
]

Правила:
- name: название на русском, как в чеке
- quantity: число (не строка). Если количество не указано — 1.0
- unit: кг / г / л / мл / шт / уп / пач / бут / пак
- category: одна из: vegetables, fruits, meat, fish, dairy, grains,
  pasta, spices, bakery, frozen, drinks, canned, other

Если на фото нет чека или не видно продуктов — верни пустой массив [].
"""

# ── Handlers ──────────────────────────────────────────────────────────────────

async def cmd_start(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "👋 Привет! Я помогаю пополнять Кладовую в Easily Kitchen.\n\n"
        "📸 Просто отправь фото кассового чека — я прочитаю продукты\n"
        "и добавлю их на склад автоматически.\n\n"
        "Можно отправлять несколько чеков подряд."
    )


async def cmd_help(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "📋 Как пользоваться:\n"
        "1. Сфотографируй кассовый чек\n"
        "2. Отправь фото в этот чат\n"
        "3. Подожди 5–15 секунд\n"
        "4. Открой Easily Kitchen → Кладовая → нажми Синхронизировать\n\n"
        "⚠️ Чек должен быть чётким и хорошо освещённым."
    )


async def handle_photo(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user

    # Проверка доступа
    if ALLOWED_USERS and user.id not in ALLOWED_USERS:
        await update.message.reply_text("⛔ У тебя нет доступа к этому боту.")
        return

    await update.message.reply_text("📸 Получила чек, анализирую... ⏳")

    try:
        # Скачиваем фото в максимальном качестве
        photo = update.message.photo[-1]
        tg_file = await ctx.bot.get_file(photo.file_id)
        buf = BytesIO()
        await tg_file.download_to_memory(buf)
        image_b64 = base64.b64encode(buf.getvalue()).decode()

        # Отправляем в Qwen-VL
        items = await _analyse_receipt(image_b64)

        if not items:
            await update.message.reply_text(
                "🤔 Не смогла распознать продукты на этом фото.\n"
                "Попробуй сфотографировать чек ровнее и при хорошем освещении."
            )
            return

        # Пишем в Firestore
        added = _save_to_firestore(items)

        # Формируем ответ
        lines = [f"✅ Добавлено в Кладовую ({len(added)} позиции):\n"]
        for it in added:
            qty = int(it["quantity"]) if it["quantity"] == int(it["quantity"]) else it["quantity"]
            lines.append(f"• {it['name']} — {qty} {it['unit']}")
        lines.append("\n📲 Открой Easily Kitchen и нажми «Синхронизировать»")

        await update.message.reply_text("\n".join(lines))

    except Exception as e:
        log.exception("Ошибка при обработке чека")
        await update.message.reply_text(
            f"❌ Произошла ошибка: {e}\n"
            "Попробуй ещё раз или напиши /help"
        )


async def handle_text(update: Update, ctx: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "📸 Отправь фото чека, и я добавлю продукты в Кладовую."
    )


# ── Qwen analysis ─────────────────────────────────────────────────────────────

async def _analyse_receipt(image_b64: str) -> list[dict]:
    """Отправляет изображение в Qwen-VL, возвращает список продуктов."""
    response = qwen.chat.completions.create(
        model="qwen-vl-plus",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{image_b64}"
                        },
                    },
                    {
                        "type": "text",
                        "text": SYSTEM_PROMPT,
                    },
                ],
            }
        ],
    )

    raw = response.choices[0].message.content.strip()
    log.info("Qwen ответ: %s", raw[:300])

    # Чистим markdown-блоки если Qwen добавил ```json ... ```
    if raw.startswith("```"):
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]
    raw = raw.strip()

    try:
        items = json.loads(raw)
        if not isinstance(items, list):
            return []
        # Валидируем поля
        result = []
        for it in items:
            if not isinstance(it, dict) or "name" not in it:
                continue
            result.append({
                "name": str(it.get("name", "")).strip(),
                "quantity": float(it.get("quantity", 1.0)),
                "unit": str(it.get("unit", "шт")).strip(),
                "category": str(it.get("category", "other")).strip(),
            })
        return result
    except json.JSONDecodeError as e:
        log.warning("Не удалось разобрать JSON от Qwen: %s | raw: %s", e, raw[:200])
        return []


# ── Firestore ─────────────────────────────────────────────────────────────────

# Маппинг category → системное значение из категорий приложения
_CATEGORY_MAP = {
    "vegetables": "vegetables",
    "fruits":     "fruits",
    "meat":       "meat",
    "fish":       "fish",
    "dairy":      "dairy",
    "grains":     "grains",
    "pasta":      "pasta",
    "spices":     "spices",
    "bakery":     "bakery",
    "frozen":     "frozen",
    "drinks":     "drinks",
    "canned":     "canned",
    "other":      "other",
}


def _save_to_firestore(items: list[dict]) -> list[dict]:
    """Записывает продукты в Firestore и возвращает сохранённые элементы."""
    now_ms = int(time.time() * 1000)
    col = db.collection("families").document(FAMILY_ID).collection("pantry")
    batch = db.batch()
    saved = []

    for it in items:
        item_id = str(uuid.uuid4())
        category = _CATEGORY_MAP.get(it["category"], "other")
        doc = {
            "id":          item_id,
            "familyId":    FAMILY_ID,
            "name":        it["name"],
            "quantity":    it["quantity"],
            "unit":        it["unit"],
            "category":    category,
            "minQuantity": 0.0,
            "createdAt":   now_ms,
            "updatedAt":   now_ms,
        }
        batch.set(col.document(item_id), doc)
        saved.append(it)

    batch.commit()
    log.info("Записано в Firestore: %d позиций", len(saved))
    return saved


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    app = Application.builder().token(TELEGRAM_TOKEN).build()

    app.add_handler(CommandHandler("start", cmd_start))
    app.add_handler(CommandHandler("help",  cmd_help))
    app.add_handler(MessageHandler(filters.PHOTO, handle_photo))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))

    log.info("Бот запущен (polling)...")
    app.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    main()
