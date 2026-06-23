# Changelog
# Family Meal Planner App

All notable changes will be documented here.  
Format: `[Stage X] YYYY-MM-DD — Description`

---

## [Stage 15] 2026-06-23 — Polish & Finalization (in progress)

- Adaptive layout verified (mobile BottomNav / desktop NavigationRail)
- Added mockito to dev_dependencies, created mocks.dart with @GenerateMocks
- Added 15 unit tests for ShoppingList generation algorithm:
  - Single recipe, ingredient scaling, duplicate aggregation
  - Pantry deduction (partial, full, case-insensitive, multi-item)
  - Different units not aggregated, multi-day aggregation
  - Default/custom name generation, zero defaultServings
  - Complex multi-day/multi-recipe/partial-pantry scenario
- Total: 110 tests passing (29 QuantityCalculator + 16 Ingredient + 15 ShoppingList + 11 Pantry Deduction + 10 ServingSelector + 8 EmptyStateWidget + 9 ConfirmDialog + 10 RecipeCard + 1 placeholder)
- Created README.md with features, tech stack, structure, setup, and testing info
- Performance audit: all lists use lazy builders, const constructors on key widgets, 0 issues in lib/ code
- Fixed unused imports in test files
- App icon verified: red refrigerator, generated for Android (5 densities) + Windows (ICO)
- Remaining: golden tests, integration tests (require device/emulator)

## [Stage 14] 2026-06-23 — Export / Import

- ExportService: serializes all data (recipes, ingredients, pantry, categories, meal plans, shopping, history) to JSON
- ImportService: file picker + JSON import with upsert for all entity types, progress stats
- Platform-conditional: native file picker on Android/Windows, web stubs (data via Firestore)
- ExportImportState + Notifier (Riverpod)

## [Stage 13] 2026-06-23 — Firestore Sync

- FirestoreSyncService (588 lines): full bidirectional offline-first sync
- Pull: Firestore → SQLite for all 7 entity types
- Push: SQLite → Firestore with batch writes
- Conflict resolution: last-write-wins via updatedAt timestamps
- SyncNotifier: connectivity listener, auto-sync on reconnect, pullAll/pushAll orchestration
- SyncState with error handling and lastSyncAt

## [Stage 12] 2026-06-23 — Firebase Authentication

- AuthScreen: login/register form with email/password, form validation, toggle between modes
- AuthNotifier: signIn/signUp/signOut wrapping FirebaseAuth
- Auth state stream provider for GoRouter redirect (unauthenticated → /auth)
- Friendly error messages for wrong password, email already in use, etc.

## [Stage 11] 2026-06-23 — Recipe Generator (Local)

- RecipeSuggestion entity: matchPercent, available/missing ingredients, computed isFullyAvailable/isNearlyAvailable
- RecipeGeneratorRepositoryImpl: builds pantry lookup map, matches ingredients by name (case-insensitive), computes match percentage
- RecipeGeneratorScreen: filter chips (All / >=75% / 100%), suggestion cards with match bar, ingredient availability list
- Purely local matching — no external API dependency

## [Stage 10] 2026-06-23 — Cooking History & Statistics

- CookingHistoryEntry + CookingHistoryIngredient entities
- HistoryRepositoryImpl: markCooked with pantry deduction loop, popular recipes aggregation
- HistoryScreen (618 lines): tabbed view (History | Popular Recipes), search by name/date, history list with recipe navigation, popular recipes with cook count
- HistoryProvider: stream, search/filter, popular recipes, markCooked notifier

## [Stage 9] 2026-06-23 — Favorites

- FavoritesScreen (249 lines): list of favorite recipes with RecipeCards, count badge, empty state with "browse recipes" link
- Toggle favorite from list, tap to navigate to detail
- Reuses RecipeRepository.watchFavorites stream

## [Stage 8] 2026-06-23 — Cooking Mode & Pantry Deduction

- CookingModeScreen (655 lines): step-by-step stepper UI, scaled ingredients display, timer per step, dark mode override, PopScope to prevent accidental exit
- "Mark Cooked" button → triggers markCooked with history recording
- Pantry deduction: matches ingredients by name, deducts quantity, warns on insufficient stock
- Records CookingHistoryEntry + CookingHistoryIngredient snapshots

## [Stage 7] 2026-06-23 — Shopping List

- GenerateShoppingListUseCase algorithm (245 lines): collect ingredients → scale → aggregate → snapshot pantry → compute to_buy
- ShoppingListScreen (570 lines): empty state, category-grouped items, check/uncheck, delete list, generate FAB, add manual item dialog
- ShoppingProvider: all lists stream, latest list with item-level reactivity, generate/toggle/delete/addManualItem notifiers
- Supports multiple lists (history)

## [Stage 6] 2026-06-23 — Meal Planner

- MealPlanEntry entity: date, mealType, servings, recipes list
- MealPlanRepositoryImpl (137 lines): watchRange with join resolution, addRecipeToSlot with slot creation, remove operations
- MealPlannerScreen (347 lines): week/2-week toggle, week navigation arrows, day card grid, add recipe dialog with recipe selection
- DayCard widget (243 lines): day header (highlighted if today), meal slots (breakfast/lunch/dinner/snack) with recipe chips
- MealPlanProvider: navigation state, derived dates, entry stream, day aggregation

## [Stage 5] 2026-06-23 — Serving Recalculation

- QuantityCalculator: scale(), format(), formatWithUnit() utilities
- ServingSelector widget: +/- stepper with min/max bounds and person label
- Integrated into RecipeDetailScreen and CookingModeScreen
- Fractional values display cleanly (e.g., "0.5 кг")

## [Stage 4] 2026-06-23 — Pantry Feature

- PantryItem entity: name, quantity, unit, category, minQuantity, computed isLowStock/isEmpty
- PantryRepositoryImpl (72 lines): full CRUD with DAO delegation, deduct logic
- PantryScreen (268 lines): search bar, category filter, low-stock banner, grouped item list, empty state, FAB
- PantryItemFormScreen (242 lines): create/edit with quantity + unit + category + min_quantity
- PantryItemTile (235 lines): inline quantity editing, low-stock badge, swipe actions
- PantryProvider: streams, search/filter state, quantity update notifier

## [Stage 0] 2026-06-07 — Planning & Documentation

- Created ARCHITECTURE.md (ADD)
- Created DATABASE.md (schema + formulas)
- Created ERD.md (entity relationship diagram)
- Created PROJECT_STRUCTURE.md (full directory layout)
- Created ROADMAP.md (15-stage plan with acceptance criteria)
- Created PROJECT_STATUS.md
- Created DECISIONS.md (7 initial ADRs)
- Created BUGS.md
- Created CHANGELOG.md

## [Stage 3.5] 2026-06-07 — Custom Category Management

- New `categories` DB table (CategoriesTable) with type='recipe'|'cuisine'|'pantry', isSystem flag, sortOrder
- CategoriesDao: watchByType, getByType, upsert, deleteCustom (system-protected), rename, valueExists
- schemaVersion bumped to 2: onCreate seeds all system categories; onUpgrade(from<2) creates table+seeds
- System seeds: 10 recipe categories, 8 cuisines, 13 pantry categories
- AppCategory domain entity (lib/features/settings/domain/entities/)
- categories_provider.dart: recipeCategoriesProvider, cuisineCategoriesProvider, pantryCategoriesProvider (all StreamProviders), CategoriesNotifier (add/rename/delete)
- CategoriesScreen: 3-tab UI (Блюда / Кухни / Продукты), add bar + rename/delete dialogs for custom entries, system entries locked
- **Architecture change**: Recipe.category and Recipe.cuisine changed from enum → String (value slug). Enables custom categories with zero schema impact on recipes table.
- RecipeMapper simplified: no more enum↔string conversion
- recipe_form_screen.dart: category/cuisine dropdowns now read from DB (live, reactive)
- recipes_screen.dart: filter chips now read from DB (include custom categories)
- recipe_card.dart: resolves category display name from DB via recipeCategoriesProvider
- recipe_detail_screen.dart: resolves category/cuisine names from DB
- Settings screen: navigable entry point to CategoriesScreen
- Router: added /settings/categories route
- flutter analyze: No issues found ✅

## [Stage 3] 2026-06-07 — Recipes Feature

- Domain entities: Recipe, Ingredient (with scale() method for serving calculator)
- RecipeRepository interface + RecipeRepositoryImpl (Drift-backed)
- RecipeMapper: DB ↔ domain conversion, JSON encode/decode for instructions
- Riverpod providers: recipesStreamProvider, filteredRecipesProvider, recipeByIdProvider, recipeIngredientsProvider, search & category filter state
- RecipesScreen: search bar, category filter chips, adaptive grid (2/3/4 columns)
- RecipeDetailScreen: SliverAppBar, serving selector, scaled ingredient list, step-by-step instructions, edit/delete actions
- RecipeFormScreen: full add/edit form with dynamic ingredients and instruction steps
- RecipeCard widget, ServingSelector widget
- Fixed app_shell.dart import (RoutePaths moved to route_names.dart)
- flutter analyze: No issues found ✅

## [Stage 2] 2026-06-07 — Database Layer

- 11 Drift tables: recipes, ingredients, pantry_items, meal_plans, meal_plan_recipes, shopping_lists, shopping_items, cooking_history, cooking_history_ingredients, sync_queue, app_settings
- 6 DAOs with full CRUD: RecipesDao, PantryDao, MealPlanDao, ShoppingDao, HistoryDao, SettingsDao
- PantryDao: inline updateQuantity + zeroOut methods (ADR-008)
- HistoryDao: getPopularRecipes SQL query for statistics
- build_runner: 86 files generated, flutter analyze — No issues found ✅
- AppDatabase provider (Riverpod)

## [Stage 1] 2026-06-07 — Project Foundation

- Flutter 3.44.1 project created (Android + Windows)
- pubspec.yaml with all dependencies (Riverpod, GoRouter, Drift, UUID, etc.)
- Core layer: constants, enums, error/failures, theme (Material 3), GoRouter, utils
- Adaptive shell: NavigationBar (mobile) / NavigationRail (desktop)
- Placeholder screens for all 8 feature modules
- flutter analyze: No issues found ✅
