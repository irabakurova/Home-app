# CHANGELOG

## [Unreleased] — Этап 15 (2026-06-08)

### Added
- `lib/core/theme/theme_provider.dart` — `themeModeProvider` (`StateProvider<ThemeMode>`): глобальное управление темой (светлая / тёмная / авто).
- `lib/core/theme/app_theme.dart` — полностью переписана: тёплая терракотовая палитра (`Color(0xFFBF6040)`), sage green secondary, Material 3. Обновлены: AppBar, Cards (borderRadius 20), InputDecoration (borderRadius 14, filled), Buttons, NavigationBar/Rail, Divider, ListTile, SnackBar, Dialog.

### Changed
- `lib/features/recipes/presentation/widgets/recipe_card.dart` — редизайн карточки: компактный заголовок (80px) с градиентом primaryContainer→secondaryContainer, иконка-текстура на фоне; `Wrap` вместо `Row` для мета-чипов; rounded иконки (favorite_rounded, schedule_rounded, label_rounded); улучшенный hitbox для кнопки избранного.
- `lib/core/widgets/app_shell.dart` — `_RailTrailingButton`: адаптивные кнопки в NavigationRail (icon-only в узком / TextButton.icon с лейблом в расширенном); thin divider между рейлом и контентом; тонкий border-top у BottomNavigationBar.
- `lib/features/recipes/presentation/screens/recipe_form_screen.dart` — исправлен баг: "Время (мин)" больше не наезжает на соседний виджет. Переделан на паттерн «label Text + TextFormField ниже» (аналогично правой колонке "Порций").
- `lib/features/settings/presentation/screens/settings_screen.dart` — заглушка «Тема — Этап 15» заменена на `_ThemeSection` с `SegmentedButton` (Светлая / Авто / Тёмная).
- `lib/app.dart` — `themeMode: ThemeMode.system` → `ref.watch(themeModeProvider)`.

---

## [Unreleased] — Этап 14 (2026-06-08)

### Added
- `lib/core/export/export_service.dart` — `ExportService`: сериализует все данные (рецепты, ингредиенты, кладовая, категории, меню, покупки, история) в JSON-файл. Путь: `Documents/СемейноеМеню/семейное_меню_YYYYMMDD_HHmmss.json`. Формат версии 1, UTF-8.
- `lib/core/export/import_service.dart` — `ImportService`: file picker (`.json`), чтение файла, проверка версии, upsert всех сущностей с заменой `familyId` на текущего пользователя. FK-порядок: категории → рецепты → ингредиенты → кладовая → меню → слоты → покупки → история.
- `lib/core/export/export_provider.dart` — `ExportImportState` (status: idle/loading/success/error), `ExportImportNotifier` (AutoDisposeNotifier), `exportImportProvider`.

### Changed
- `lib/features/settings/presentation/screens/settings_screen.dart` — добавлена `_ExportImportSection`: кнопки «Экспорт» и «Импорт», индикатор загрузки, snackbar с результатом, диалог подтверждения перед импортом.
- `lib/core/database/daos/shopping_dao.dart` — `getAllItemsForSync(List<String> listIds)` — все товары для заданных списков покупок.
- `lib/core/database/daos/history_dao.dart` — `getAllIngredientsForSync(List<String> historyIds)` — все ингредиенты для заданных записей истории.

---

## [Unreleased] — Этап 13 (2026-06-08)

### Added
- `lib/core/sync/firestore_sync_service.dart` — `FirestoreSyncService`: push/pull для 8 коллекций Firestore (`recipes`, `recipe_ingredients`, `pantry`, `categories`, `meal_plans`, `meal_plan_recipes`, `shopping_lists`/`items`, `history`/`history_ingredients`). Батчевая запись через `_batchWrite` (400 оп/батч, лимит Firestore 500). Путь: `/families/{uid}/...`
- `lib/core/sync/sync_provider.dart` — `SyncState`, `SyncNotifier` (`AsyncNotifier`): авто-sync при старте и при восстановлении соединения через `connectivity_plus`, `syncNow()`, `isSyncingProvider`, `lastSyncAtProvider`, `syncErrorProvider`
- `firestore.rules` — правила безопасности Firestore: только аутентифицированный пользователь читает/пишет свою семью (`uid == familyId`)

### Changed
- `pubspec.yaml` — раскомментирован `cloud_firestore: ^5.5.0`
- `lib/app.dart` — преобразован в `ConsumerStatefulWidget`; warm-up `syncNotifierProvider` после первого фрейма; `ref.listen(authStateProvider)` → `syncNow()` при входе в аккаунт
- `lib/features/settings/presentation/screens/settings_screen.dart` — заглушка «Синхронизация — Этап 13» заменена на `_SyncSection`: индикатор загрузки, статус (время последней синхронизации / ошибка), кнопка «Синхронизировать», описание поведения

### DAO additions (sync helpers, no breaking changes)
- `RecipesDao` — `getAllForSync`, `getAllIngredientsForSync`
- `CategoriesDao` — `getAll`
- `MealPlanDao` — `getAllForSync`, `getAllSlotsForSync`, `upsertSlot`
- `ShoppingDao` — `getAllListsForSync`
- `HistoryDao` — `getAllForSync`, `getIngredientsForEntry`, `upsertEntry`, `upsertHistoryIngredient`

---

## [Unreleased] — Этап 12 (2026-06-07)

### Added
- `lib/firebase_options.dart` — сгенерирован flutterfire CLI (Android + Windows)
- `lib/core/router/go_router_refresh_stream.dart` — `GoRouterRefreshStream extends ChangeNotifier` для реактивного редиректа
- `lib/features/auth/presentation/providers/auth_provider.dart` — `authStateProvider` (StreamProvider<User?>), `AuthNotifier` (signIn / signUp / signOut)
- `lib/features/auth/presentation/screens/auth_screen.dart` — полный UI: email + пароль, toggle Вход/Регистрация, FirebaseAuthException → дружественные сообщения, подсказка про общий аккаунт

### Changed
- `lib/main.dart` — `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` перед `runApp`
- `pubspec.yaml` — раскомментированы `firebase_core: ^3.8.0`, `firebase_auth: ^5.3.4`
- `lib/core/router/app_router.dart` — redirect guard (не авторизован → /auth, авторизован → /recipes) + `refreshListenable: GoRouterRefreshStream(authStateChanges)`
- `lib/features/recipes/presentation/providers/recipes_provider.dart` — `kDefaultFamilyId` из `const String` → getter использующий `FirebaseAuth.instance.currentUser?.uid ?? 'default_family'`
- `lib/features/settings/presentation/providers/categories_provider.dart` — `const Value(kDefaultFamilyId)` → `Value(kDefaultFamilyId)`

---

## [Unreleased] — Этап 11 (2026-06-07)

### Added
- `lib/features/recipe_generator/domain/entities/recipe_suggestion.dart` — `RecipeSuggestion`, `MissingIngredient`
- `lib/features/recipe_generator/domain/repositories/recipe_generator_repository.dart` — абстракция
- `lib/features/recipe_generator/data/repositories/recipe_generator_repository_impl.dart` — матчинг по кладовой: `pantryMap[name.toLowerCase()]`, сортировка по matchPercent
- `lib/features/recipe_generator/presentation/providers/recipe_generator_provider.dart` — `rawSuggestionsProvider`, `filteredSuggestionsProvider`, `SuggestionFilter` enum (all / nearly / full)
- `lib/features/recipe_generator/presentation/screens/recipe_generator_screen.dart` — FilterChip-фильтры, карточки с прогресс-баром, чипы недостающих ингредиентов, пустые состояния

### Changed
- `lib/core/router/route_names.dart` + `app_router.dart` — маршрут `/recipe-generator`
- `lib/core/widgets/app_shell.dart` — кнопка ✨ в десктопном рейле
- `lib/features/pantry/presentation/screens/pantry_screen.dart` — кнопка ✨ в AppBar кладовой

---

## [Unreleased] — Этап 10 (2026-06-07)

### Added
- `lib/features/history/presentation/screens/history_screen.dart` — полный экран истории:
  - Tab «Записи»: поиск по заголовку рецепта, группировка по датам (Сегодня / Вчера / дата), `_HistoryTile` с открытием детального `BottomSheet`
  - `_HistoryDetailSheet`: список использованных ингредиентов + иконка статуса (из кладовой / нет), кнопка «Открыть рецепт»
  - Tab «Статистика»: 3 карточки (всего готовок / рецептов / порций), топ-10 популярных блюд с датой последнего приготовления
  - Пустые состояния для пустой истории и нулевого поиска
- `pubspec.yaml` — добавлен `flutter_localizations` (SDK пакет)
- `lib/app.dart` — добавлены `localizationsDelegates` + `supportedLocales` (ru + en)
- `lib/main.dart` — добавлен `await initializeDateFormatting('ru', null)` перед `runApp`

---

## [Unreleased] — Этап 9 (2026-06-07)

### Added / Changed
- `lib/features/favorites/presentation/screens/favorites_screen.dart` — полноценный экран: список с `Dismissible` (свайп влево → убрать из избранного), undo-snackbar, кнопка ♥ в тайле, пустое состояние с CTA «Перейти к рецептам»

---

## [Unreleased] — Этап 8 (2026-06-07)

### Added
- `lib/features/history/domain/entities/cooking_history_entry.dart` — `CookingHistoryEntry`, `CookingHistoryIngredient`, `DeductionResult`
- `lib/features/history/domain/repositories/cooking_history_repository.dart` — абстрактный репозиторий с `markCooked` (возвращает entry + deductions)
- `lib/features/history/data/models/history_mapper.dart` — маппер DB ↔ domain
- `lib/features/history/data/repositories/cooking_history_repository_impl.dart` — `markCooked`: запись истории + дедукция из кладовой по name+unit
- `lib/features/history/presentation/providers/history_provider.dart` — `cookingHistoryProvider`, `CookingNotifier`
- `lib/features/recipes/presentation/screens/cooking_mode_screen.dart` — пошаговый режим готовки: `PopScope`, тёмный режим, ServingSelector, Step card, Ingredients card, «Блюдо приготовлено», предупреждения о недостаче

### Changed
- `lib/core/database/daos/pantry_dao.dart` — добавлен `getByNameAndUnit(familyId, name, unit)` для точной дедукции
- `lib/core/router/app_router.dart` — cookingMode route теперь ведёт на `CookingModeScreen` (заменена заглушка)
- `lib/features/shopping/presentation/screens/shopping_list_screen.dart` — заменены `value:` на `initialValue:` + `key: ValueKey(...)` в двух `DropdownButtonFormField` (BUG-002 fix)

---

## [Unreleased] — Этап 7 (2026-06-07)

### Added
- `lib/features/shopping/domain/entities/shopping_list.dart` — `ShoppingList`, `ShoppingItem` с `toBuyItems`, `coveredItems`, `itemsByCategory`
- `lib/features/shopping/domain/repositories/shopping_list_repository.dart` — абстракция репозитория
- `lib/features/shopping/data/repositories/shopping_list_repository_impl.dart` — полный алгоритм генерации: суммирование ингредиентов, масштабирование по порциям, вычитание склада
- `lib/features/shopping/presentation/providers/shopping_provider.dart` — `latestShoppingListProvider` (item-reactive через `watchList`), `ShoppingNotifier`
- `lib/features/shopping/presentation/screens/shopping_list_screen.dart` — прогресс, группировка по категориям, Dismissible удаление, секция «покрыто складом», ручное добавление

### Changed
- `lib/core/database/daos/shopping_dao.dart` — добавлен `getItems(String listId)` (one-shot Future)
- `lib/features/meal_planner/presentation/screens/meal_planner_screen.dart` — убран EmptyStateWidget, DayCards всегда отображаются, FAB постоянный

---

## [0.6.0] — Этап 6 (2026-06-07)

### Added
- `lib/features/meal_planner/domain/entities/meal_plan_entry.dart` — `MealPlanEntry`, `MealPlanDay`
- `lib/features/meal_planner/domain/repositories/meal_plan_repository.dart` — абстракция
- `lib/features/meal_planner/data/repositories/meal_plan_repository_impl.dart` — watchRange asyncMap, addRecipeToSlot (upsert), removeSlot
- `lib/core/database/daos/meal_plan_dao.dart` — `getPlanByDateAndType()`, `deleteRecipesForPlan()`
- `lib/features/meal_planner/presentation/providers/meal_plan_provider.dart` — 6 providers + `MealPlanNotifier`
- `lib/features/meal_planner/presentation/widgets/day_card.dart` — DayCard, _MealSlot, _RecipeChip
- `lib/features/meal_planner/presentation/screens/meal_planner_screen.dart` — полная реализация экрана

### Changed
- `MealPlannerScreen` всегда рендерит DayCards (не скрывает за EmptyStateWidget при пустом плане)
- FAB всегда видим, открывает picker на сегодняшний ужин

---

## [0.5.1] — Этап 5 (2026-06-07)

### Added
- `test/core/utils/quantity_calculator_test.dart` — 20 unit-тестов для `QuantityCalculator`:
  - `scale()`: 11 тестов (базовые, граничные, защита от /0, дроби, округление)
  - `format()`: 7 тестов (целые, дробные, trailing zeros, ноль, большие числа)
  - `formatWithUnit()`: 6 тестов (все основные единицы измерения)
  - Полный pipeline из спецификации: 600г на 4 → 2/8/10 человек
- `test/features/recipes/domain/ingredient_test.dart` — 13 unit-тестов для `Ingredient`:
  - `scale()`: 10 тестов (пересчёт, сохранение полей, неизменяемость, граничные случаи)
  - `copyWith()`: 3 теста
  - equality: 2 теста

---

## [0.5.0] — Этап 4 Pantry (2026-06-07)

### Added
- `lib/features/pantry/domain/entities/pantry_item.dart` — сущность PantryItem с `isLowStock`, `isEmpty`
- `lib/features/pantry/domain/repositories/pantry_repository.dart` — абстракция репозитория
- `lib/features/pantry/data/models/pantry_mapper.dart` — маппер DB↔domain
- `lib/features/pantry/data/repositories/pantry_repository_impl.dart` — реализация + `deduct()`
- `lib/features/pantry/presentation/providers/pantry_provider.dart` — потоки, поиск, фильтр, `filteredPantryProvider`
- `lib/features/pantry/presentation/widgets/pantry_item_tile.dart` — inline qty edit (ADR-008), Dismissible
- `lib/features/pantry/presentation/screens/pantry_item_form_screen.dart` — форма CRUD
- `lib/features/pantry/presentation/screens/pantry_screen.dart` — главный экран, поиск, фильтры

### Changed
- `lib/core/router/app_router.dart` — pantry маршруты подключены к реальным экранам

---

## [0.4.0] — Этап 3.5 Кастомные категории (предыдущая сессия)

### Added
- `CategoriesTable` / `CategoriesDao` — кастомные + системные категории
- `AppDatabase.schemaVersion` → 2, миграция `onUpgrade`
- `AppCategory` entity, `categories_provider.dart`, `CategoriesScreen`
- Интеграция в `RecipeFormScreen`, `RecipesScreen`, `RecipeDetailScreen`, `RecipeCard`

### Changed
- `Recipe.category` / `Recipe.cuisine` — с enum на `String` slug
- `RecipeDetailScreen` — отображение имён категорий из БД

---

## [0.3.0] — Этап 3 Recipes (предыдущая сессия)

### Added
- Полный CRUD рецептов: `RecipesScreen`, `RecipeFormScreen`, `RecipeDetailScreen`
- `RecipeCard`, `ServingSelector`, фильтры по категориям
- GoRouter маршруты для рецептов

---

## [0.2.0] — Этап 2 Database

### Added
- 7 Drift таблиц: recipes, ingredients, pantry, shopping, meal_plan, history, settings
- 7 DAOs с полным CRUD
- build_runner генерация `.g.dart`

---

## [0.1.0] — Этап 1 Init

### Added
- Flutter проект, pubspec.yaml, Clean Architecture структура
- Riverpod 2.6, GoRouter 14.6, Material 3 тема
- AppShell с BottomNavigationBar / NavigationRail
