# Telegram-бот для сканирования чеков — Инструкция по настройке

Бот получает фото чека в Telegram, анализирует его через Qwen-VL (Alibaba Cloud),
и добавляет продукты в Кладовую приложения Easily Kitchen через Firestore.

---

## Шаг 1 — Создать Telegram-бота

1. Открой Telegram, найди **@BotFather**
2. Напиши `/newbot`
3. Придумай имя (например: `Easily Kitchen`) и username (например: `EasilyKitchenBot`)
4. BotFather выдаст **токен** вида `1234567890:ABCdef...` — сохрани его

---

## Шаг 2 — Получить DashScope API Key (Qwen)

1. Зайди на https://dashscope.aliyun.com/ (или https://help.aliyun.com/zh/dashscope/)
2. Зарегистрируйся / войди (понадобится аккаунт Alibaba Cloud)
3. В личном кабинете → **API Keys** → создай новый ключ
4. Сохрани ключ — он начинается с `sk-`

> Бесплатная квота Qwen-VL-Plus: ~1000 запросов/месяц

---

## Шаг 3 — Firebase Service Account

1. Открой https://console.firebase.google.com/
2. Выбери проект **family-meal-planner-67475**
3. ⚙️ Настройки проекта → **Сервисные аккаунты**
4. Нажми **«Создать закрытый ключ»** → скачается файл `serviceAccountKey.json`
5. **Сохрани файл в папке `receipt_bot/`** (для локального запуска)

---

## Шаг 4 — Локальный запуск (для проверки)

```bash
cd receipt_bot/
pip install -r requirements.txt

# Создай файл .env (скопируй из .env.example):
cp .env.example .env
# Заполни TELEGRAM_TOKEN и DASHSCOPE_API_KEY

# serviceAccountKey.json должен лежать рядом

python bot.py
```

Отправь фото чека боту — должен ответить списком продуктов.

---

## Шаг 5 — Деплой на Railway.app

1. Зарегистрируйся на https://railway.app/ (можно через GitHub)
2. **New Project → Deploy from GitHub repo**
   - Или: **New Project → Empty Project → Add Service → GitHub Repo**
   - Выбери репозиторий где лежит `receipt_bot/` (или загрузи вручную)
3. В настройках сервиса → **Variables** → добавь три переменные:

   | Key | Value |
   |-----|-------|
   | `TELEGRAM_TOKEN` | токен от BotFather |
   | `DASHSCOPE_API_KEY` | ключ от DashScope |
   | `FIREBASE_CREDENTIALS_JSON` | содержимое `serviceAccountKey.json` **в одну строку** |

   Чтобы превратить JSON в одну строку, выполни в терминале:
   ```bash
   cat serviceAccountKey.json | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin)))"
   ```

4. Railway автоматически обнаружит `Procfile` и запустит `python bot.py`
5. Деплой занимает ~2 минуты. После этого бот работает 24/7.

---

## Использование

1. Открой своего бота в Telegram
2. Напиши `/start`
3. Сфотографируй кассовый чек и отправь фото
4. Бот ответит списком найденных продуктов
5. В приложении Easily Kitchen → нажми **Синхронизировать** → продукты появятся в Кладовой

### Ограничения по доступу
Чтобы только ты и муж могли использовать бота, добавьте свои Telegram user ID в `ALLOWED_USERS` в `bot.py`:
```python
ALLOWED_USERS: list[int] = [123456789, 987654321]
```
Узнать свой ID можно у бота **@userinfobot**.

---

## Структура проекта

```
receipt_bot/
├── bot.py               # Основная логика бота
├── requirements.txt     # Python зависимости
├── Procfile             # Команда запуска для Railway
├── .env.example         # Шаблон переменных окружения
├── serviceAccountKey.json  # Firebase ключ (локально, НЕ коммитить в git!)
└── README_SETUP.md      # Эта инструкция
```

> ⚠️ Никогда не загружай `serviceAccountKey.json` в публичный репозиторий!
> Добавь его в `.gitignore`.
