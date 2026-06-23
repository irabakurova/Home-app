# PROJECT STATUS

**Последнее обновление:** 2026-06-08  
**Текущий этап:** Этап 15 ✅ ЗАВЕРШЁН  
**Статус:** ВСЕ ЭТАПЫ ЗАВЕРШЕНЫ — приложение готово к наполнению данными

---

## Завершённые этапы

| Этап | Описание | Статус |
|------|----------|--------|
| 1 | Инициализация проекта, архитектура, Riverpod, GoRouter, тема | ✅ |
| 2 | SQLite / Drift: таблицы, DAOs, миграции, build_runner | ✅ |
| 3 | Модуль рецептов: CRUD, категории, кухни, поиск, фильтрация | ✅ |
| 3.5 | Кастомные категории: DB + DAO + Settings UI + интеграция | ✅ |
| 4 | Склад продуктов: CRUD, поиск, inline-редактирование количества | ✅ |
| 5 | Пересчёт ингредиентов по порциям: логика + unit-тесты | ✅ |
| 6 | Планировщик меню: domain, репозиторий, Riverpod, DayCard, экран | ✅ |
| 7 | Список покупок: генерация из планировщика, проверка склада, UI | ✅ |
| 8 | Режим готовки + автосписание продуктов со склада + история | ✅ |
| 9 | Избранные рецепты: экран, Dismissible, undo-snackbar | ✅ |
| 10 | История готовки + статистика: HistoryScreen, поиск, группировка по датам, статкарточки, топ блюд | ✅ |
| 11 | AI-генератор рецептов: локальный матчинг по кладовой, фильтры, карточки с прогресс-баром | ✅ |
| 12 | Firebase Auth: инициализация, AuthScreen (login/register), router redirect guard, kDefaultFamilyId → Firebase UID | ✅ |
| 13 | Синхронизация Firestore: FirestoreSyncService (push/pull), SyncNotifier, connectivity auto-sync, SettingsScreen sync UI | ✅ |
| 14 | Экспорт/импорт данных: ExportService, ImportService, ExportProvider, UI в настройках | ✅ |
| 15 | Полировка UI: тёплая терракотовая тема, исправление выравнивания, RecipeCard редизайн, AppShell адаптивный рейл, переключатель темы | ✅ |

---

## Текущее состояние кодовой базы

### Ядро (core/)
- `AppDatabase` — schemaVersion: 2, 7 таблиц, 7 DAOs
- `CategoriesTable` — system + custom категории для рецептов, кухонь, продуктов
- `QuantityCalculator` — масштабирование, форматирование
- `AppConstants` — minServings=1, maxServings=10
- `MeasurementUnit` enum — г, кг, мл, л, шт, ст.л., ч.л., стакан, щепотка

### Модуль Recipes (features/recipes/)
- Полный CRUD через `RecipeRepository` / `RecipeRepositoryImpl`
- `RecipeDetailScreen` — `ServingSelector` (1–10), пересчёт ингредиентов в реальном времени
- Поиск и фильтрация по категории, кухне, избранному
- Строковые слаги для категорий (без enum-конверсии)

### Модуль Pantry (features/pantry/)
- Полный CRUD через `PantryRepository`
- `PantryScreen` — поиск, фильтры категорий, баннер низкого остатка
- `PantryItemTile` — inline-редактирование количества (ADR-008), Dismissible
- `PantryItemFormScreen` — форма добавления/редактирования

### Модуль Settings (features/settings/)
- `CategoriesScreen` — управление категориями рецептов, кухонь, продуктов
- Добавление/переименование/удаление кастомных категорий
- Системные категории защищены от удаления

### Модуль MealPlanner (features/meal_planner/)
- `MealPlanEntry` / `MealPlanDay` — domain entities
- `MealPlanRepository` — абстракция
- `MealPlanRepositoryImpl` — `watchRange().asyncMap()` паттерн, upsert слотов
- `MealPlanDao` — watchRange, upsertPlan, addRecipeToPlan, getPlanByDateAndType, deleteRecipesForPlan
- `meal_plan_provider.dart` — `plannerRangeLengthProvider`, `plannerWeekOffsetProvider`, `mealPlanDaysProvider`, `MealPlanNotifier`
- `DayCard` — карточка дня, `_MealSlot`, `_RecipeChip` (удаление слота)
- `MealPlannerScreen` — SegmentedButton (7/14 дней), навигация по неделям, ListView DayCards, FAB

### Модуль History (features/history/)
- `CookingHistoryEntry` / `CookingHistoryIngredient` / `DeductionResult` — domain entities
- `CookingHistoryRepository` — абстракция
- `CookingHistoryRepositoryImpl` — запись в историю + дедукция из кладовой (match by name+unit)
- `HistoryMapper` — DB ↔ domain маппер
- `history_provider.dart` — `cookingHistoryProvider`, `filteredHistoryProvider`, `historySearchQueryProvider`, `popularRecipesProvider`, `CookingNotifier`
- `history_screen.dart` — полный экран: TabBar (Записи / Статистика), поиск по заголовку, группировка по датам, детальный BottomSheet с ингредиентами, 3 статкарточки, топ блюд

### Режим готовки (features/recipes/presentation/screens/)
- `CookingModeScreen` — пошаговый режим с `PopScope` (подтверждение выхода)
  - Тёмный режим (кнопка в AppBar)
  - ServingSelector (пересчёт порций)
  - `_StepCard` — текущий шаг, большой текст, кнопки Назад/Далее
  - `_IngredientsCard` — сворачиваемый список ингредиентов (с пересчётом)
  - `_MarkCookedBar` — кнопка «Блюдо приготовлено» (tertiary color)
  - `_ConfirmCookDialog` — список списываемых продуктов
  - `_DeductionWarningDialog` — предупреждение о недостающих позициях

### Модуль Shopping (features/shopping/)
- `ShoppingList` / `ShoppingItem` — domain entities
- `ShoppingListRepository` — абстракция
- `ShoppingListRepositoryImpl` — агрегация ингредиентов, проверка склада, алгоритм toBuy
- `ShoppingDao` — CRUD + `getItems()` (синхронный fetch)
- `shopping_provider.dart` — `latestShoppingListProvider` (item-reactive), `ShoppingNotifier`
- `ShoppingListScreen` — прогресс-бар, группировка по категориям, Dismissible, `_CoveredSection`, ручное добавление

### Тесты
- `test/core/utils/quantity_calculator_test.dart` — 20 тестов
- `test/features/recipes/domain/ingredient_test.dart` — 13 тестов

---

## Pending

Все 15 этапов завершены. Приложение готово к использованию.

**Возможные улучшения в будущем:**
- Загрузка фото рецептов (Firebase Storage)
- Изменение раскладки карточек рецептов (список / сетка)
- Подключение AI API для генерации рецептов (OpenAI / Claude / Gemini)
- Сохранение настройки темы в SharedPreferences
- Уведомления о низком остатке продуктов
