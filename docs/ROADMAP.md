# Development Roadmap
# Family Meal Planner App

**Version:** 1.0.0  
**Date:** 2026-06-07  
**Total Stages:** 15

---

## Stage Overview

| # | Stage | Focus | Status |
|---|-------|-------|--------|
| 1 | Project Foundation | Flutter project, architecture, navigation, theme | ✅ Complete |
| 2 | Database Layer | Drift schema, all tables, migrations, providers | ✅ Complete |
| 3 | Recipes Feature | CRUD, categories, cuisines, search, filters | ✅ Complete |
| 4 | Pantry Feature | CRUD, categories, search, stock display | ✅ Complete |
| 5 | Serving Recalculation | Quantity scaling with unit preservation | ✅ Complete |
| 6 | Meal Planner | Weekly/bi-weekly/monthly planning | ✅ Complete |
| 7 | Shopping List | Auto-generation, pantry deduction, manual items | ✅ Complete |
| 8 | Cooking Mode & Deduction | Cook flow, pantry deduction, history logging | ✅ Complete |
| 9 | Favorites | Favorite toggle, dedicated screen | ✅ Complete |
| 10 | Cooking History & Stats | Log, search, statistics, popular dishes | ✅ Complete |
| 11 | Recipe Generator | Local matching + AI abstraction layer | ✅ Complete |
| 12 | Firebase Auth | Login, register, user session | ✅ Complete |
| 13 | Firestore Sync | Offline-first sync, conflict resolution | ✅ Complete |
| 14 | Export / Import | JSON export/import, backup/restore | ✅ Complete |
| 15 | Polish & Finalization | Responsive UI, Windows adaptation, full test pass | 🔄 In Progress |

---

## Stage Details

---

### Stage 1 — Project Foundation

**Goal:** Runnable app skeleton with correct architecture.

**Deliverables:**
- Flutter project created (`flutter create`)
- `pubspec.yaml` with all dependencies declared
- `analysis_options.yaml` configured (strict lints)
- `app.dart` — `ProviderScope` + `MaterialApp.router`
- GoRouter with all route stubs (return `Placeholder`)
- `AppTheme` — Material 3 light + dark
- `AdaptiveLayout` widget — `NavigationBar` (mobile) / `NavigationRail` (desktop)
- Core layer scaffold (constants, error, utils, widgets)
- `docs/` folder with all 7 management documents
- Firebase project initialized (`firebase init`)

**Build check:**
```
flutter build apk --debug
flutter build windows --debug
```

**Acceptance Criteria:**
- [ ] App runs on Android emulator and Windows without errors
- [ ] Bottom nav on mobile, side rail on desktop
- [ ] Theme switches light ↔ dark
- [ ] All routes navigate without crash
- [ ] Zero linting errors

---

### Stage 2 — Database Layer

**Goal:** Complete local SQLite schema with Drift ORM.

**Deliverables:**
- All 11 Drift table definitions
- `AppDatabase` class with all tables registered
- `build_runner` generating `.g.dart` files
- Migration strategy (`schemaVersion = 1`)
- Provider for `AppDatabase` singleton
- DAO classes per feature (RecipesDao, PantryDao, etc.)
- Integration test: CRUD round-trip for every table

**Acceptance Criteria:**
- [ ] `build_runner build` completes without errors
- [ ] Integration tests: create / read / update / delete for each table
- [ ] Migrations run cleanly from v0 to v1
- [ ] Database file is created on device on first launch

---

### Stage 3 — Recipes Feature

**Goal:** Full recipe management with UI.

**Deliverables:**
- `Recipe` and `Ingredient` entities (freezed)
- `RecipeRepository` + implementation
- Use cases: get all, get by id, save, delete, search, toggle favorite
- `RecipesScreen` — grid/list of recipe cards with search bar
- `RecipeDetailScreen` — full recipe view with ingredients and steps
- `RecipeFormScreen` — add/edit recipe (title, photo, category, cuisine, cook time, servings, ingredients, instructions)
- Filter bar: category, cuisine, cook time range
- Image picker (camera/gallery on Android, file picker on Windows)
- `RecipesProvider` — `StreamProvider<List<Recipe>>`

**Acceptance Criteria:**
- [ ] Add a recipe → appears in list
- [ ] Edit a recipe → changes persist
- [ ] Delete a recipe → removed from list
- [ ] Search by title works
- [ ] Filter by category works
- [ ] Photo is saved and displayed
- [ ] No data lost on app restart

---

### Stage 4 — Pantry Feature

**Goal:** Home pantry inventory management.

**Deliverables:**
- `PantryItem` entity (freezed)
- `PantryRepository` + implementation
- Use cases: get all, save, delete, search, deduct (stub for Stage 8)
- `PantryScreen` — grouped by category, low-stock indicator
- `PantryItemFormScreen` — add/edit with quantity + unit + category + min_quantity
- Search by name

**Acceptance Criteria:**
- [ ] Add/edit/delete pantry items
- [ ] Items grouped by category in UI
- [ ] Items below `min_quantity` show visual warning
- [ ] Search by name works
- [ ] Data persists across restarts

---

### Stage 5 — Serving Recalculation

**Goal:** Accurate scaling of ingredient quantities.

**Deliverables:**
- `QuantityCalculator.scale(quantity, defaultServings, targetServings)` util
- `ServingSelector` widget (2–10 people, step 1)
- Recipe detail screen shows scaled quantities when serving count changes
- Unit stays unchanged (g stays g, ml stays ml)

**Test coverage:**
```dart
// Examples to cover:
scale(600, 4, 2) == 300
scale(600, 4, 8) == 1200
scale(600, 4, 10) == 1500
scale(1, 4, 2) == 0.5
scale(500, 2, 3) == 750
```

**Acceptance Criteria:**
- [ ] Unit tests cover all example cases above
- [ ] Selector renders correctly on mobile and desktop
- [ ] Changing servings updates all ingredient amounts in real time
- [ ] Fractional values display cleanly (e.g., "0.5 kg" not "0.500000000001 kg")

---

### Stage 6 — Meal Planner

**Goal:** Calendar-based meal planning.

**Deliverables:**
- `MealPlan` and `MealPlanDay` entities
- `MealPlanRepository` + implementation
- Use cases: get plan for range, add recipe to day, remove recipe from day
- `MealPlannerScreen` — week view by default
- Range selector: Week / 2 Weeks / Month
- Day card: shows meal type slots (breakfast/lunch/dinner/snack) with assigned recipes
- "Add recipe to slot" dialog — recipe picker with search

**Acceptance Criteria:**
- [ ] Plan week, 2 weeks, month — all date ranges display correctly
- [ ] Add recipe to Monday lunch → persists
- [ ] Remove recipe from plan → slot cleared
- [ ] Same recipe can appear on multiple days
- [ ] Multiple recipes per day slot work

---

### Stage 7 — Shopping List

**Goal:** Auto-generated shopping list from meal plan.

**Deliverables:**
- `GenerateShoppingListUseCase` — full calculation logic:
  1. Collect all ingredients from planned recipes
  2. Sum duplicates (same name + unit)
  3. Snapshot current pantry quantities
  4. Compute `to_buy = max(0, needed - in_pantry)`
  5. Save to `shopping_lists` + `shopping_items`
- `ShoppingListScreen` — items grouped by category
- Check off items (is_checked toggle)
- Manually add item
- Multiple lists supported (history)

**Acceptance Criteria:**
- [ ] Generate list for a week plan → correct totals
- [ ] Pantry items correctly deducted from needed quantities
- [ ] If pantry has enough → item not in list (quantity = 0)
- [ ] Manual items can be added
- [ ] Checking off items persists

---

### Stage 8 — Cooking Mode & Pantry Deduction

**Goal:** Step-by-step cooking UI + post-cook pantry update.

**Deliverables:**
- `CookingModeScreen` — full screen, large text, step-by-step navigation
  - Prev / Next step buttons
  - Step counter ("Step 2 of 7")
  - Dark mode forced
  - WillPopScope / PopScope to prevent accidental exit
- "Dish is ready" button → triggers `LogCookingUseCase`
- `LogCookingUseCase`:
  1. Calculate actual ingredient quantities for selected servings
  2. Deduct from pantry items (matched by name)
  3. Show warning if pantry has insufficient stock
  4. Write `cooking_history` + `cooking_history_ingredients` records

**Acceptance Criteria:**
- [ ] Step navigation works forward and backward
- [ ] Back gesture shows confirmation dialog
- [ ] "Dish ready" → pantry quantities deducted correctly
- [ ] Warning shown if pantry insufficient
- [ ] Entry appears in cooking history
- [ ] Works correctly with fractional quantities

---

### Stage 9 — Favorites

**Goal:** Favorite recipe management.

**Deliverables:**
- `ToggleFavoriteUseCase` — sets `is_favorite` flag
- Star/heart icon on `RecipeCard` and `RecipeDetailScreen`
- `FavoritesScreen` — filtered list of `is_favorite = true` recipes
- `FavoritesProvider` — `StreamProvider<List<Recipe>>`

**Acceptance Criteria:**
- [ ] Toggle favorite on recipe card → icon updates immediately
- [ ] Favorites screen shows only favorited recipes
- [ ] Unfavoriting removes from favorites screen instantly
- [ ] Favorite state persists across restarts

---

### Stage 10 — Cooking History & Statistics

**Goal:** Complete history log with search and statistics.

**Deliverables:**
- `HistoryScreen` — list of cooking entries, newest first
- Search by date range, search by recipe name
- `RecipeStatsCard` — for each recipe shows:
  - Times cooked (total)
  - Last cooked date
- "Popular dishes" section on `HistoryScreen` — top 5 by cook count
- `GetRecipeStatisticsUseCase`

**Acceptance Criteria:**
- [ ] History entries appear after cooking
- [ ] Search by recipe name works
- [ ] Search by date range works
- [ ] Cook count is accurate
- [ ] Last cooked date is correct
- [ ] Popular dishes sorted correctly

---

### Stage 11 — Recipe Generator (AI Module)

**Goal:** "What can I cook?" feature + AI API scaffolding.

**Deliverables:**
- `RecipeGeneratorService` abstract class
- `LocalRecipeGeneratorService` — matches pantry items against existing recipe ingredients
  - A recipe "matches" if ≥ 70% of its ingredients are in pantry with sufficient quantity
  - Results sorted by match percentage
- `WhatCanICookSheet` — bottom sheet with matched recipe list
- `RecipeGeneratorProvider`
- Placeholder stubs for `OpenAIRecipeGeneratorService`, `ClaudeRecipeGeneratorService`, `GeminiRecipeGeneratorService` (not implemented, just interface-satisfying shells)
- Provider config: `activeGeneratorProvider` returns the active implementation

**Acceptance Criteria:**
- [ ] "What can I cook?" button shows recipes with ≥ 70% ingredient match
- [ ] Match percentage shown per recipe
- [ ] Empty state when no matches
- [ ] Swapping active generator via provider works (unit test)

---

### Stage 12 — Firebase Authentication

**Goal:** User login, registration, session persistence.

**Deliverables:**
- `AuthScreen` — Login / Register tabs
- Email + password auth via Firebase Auth
- On first registration: create `users/{uid}` document, generate `familyId`
- On login: read `familyId` from Firestore, store in `AppSettings`
- Auth state listener → GoRouter redirect (unauthenticated → `/auth`)
- Sign out clears local session
- `flutter_secure_storage` for auth token caching (handled by Firebase SDK)

**Acceptance Criteria:**
- [ ] New user can register with email + password
- [ ] Existing user can log in
- [ ] Auth state persists across app restarts
- [ ] Unauthenticated users redirected to auth screen
- [ ] Sign out redirects to auth screen
- [ ] Wrong password shows error message

---

### Stage 13 — Firestore Sync

**Goal:** Real-time data sync between husband and wife devices.

**Deliverables:**
- `SyncQueueDatasource` — Drift DAO for `sync_queue` table
- `FirestoreSyncService`:
  - Writes: flush sync_queue to Firestore on connect
  - Reads: subscribe to Firestore collections, update SQLite on change
  - Conflict resolution: compare `updated_at`, keep newest
- `SyncProvider` — exposes `SyncStatus` (idle / syncing / error / last_synced_at)
- Sync status indicator in Settings screen
- Offline mode: app fully functional without network

**Acceptance Criteria:**
- [ ] Change on device A appears on device B within 5 seconds
- [ ] App works fully offline (create/edit/delete)
- [ ] Changes made offline sync when reconnected
- [ ] No data loss during sync
- [ ] Sync status visible in Settings

---

### Stage 14 — Export / Import

**Goal:** Data portability and backup.

**Deliverables:**
- `ExportDataUseCase` — serialize all local data to JSON
  ```json
  {
    "version": "1.0",
    "exported_at": "...",
    "recipes": [...],
    "pantry_items": [...],
    "meal_plans": [...],
    "shopping_lists": [...],
    "cooking_history": [...]
  }
  ```
- `ImportDataUseCase` — parse JSON, validate schema, merge into DB
  - Merge strategy: existing IDs → update; new IDs → insert
- Settings screen: Export button → saves file via `file_picker`
- Settings screen: Import button → picks file, shows preview, confirms

**Acceptance Criteria:**
- [ ] Export produces valid JSON file
- [ ] Import from exported file restores all data
- [ ] Import on a fresh install restores correctly
- [ ] Invalid JSON shows error, does not corrupt DB
- [ ] Recipes with photos export/import correctly (photo_url path handling)

---

### Stage 15 — Polish & Finalization

**Goal:** Production-ready, fully tested, cross-platform.

**Deliverables:**
- Responsive layout audit (phone portrait, tablet, Windows 800px+, 1200px+)
- Windows-specific: keyboard shortcuts (Ctrl+N new recipe, Ctrl+F search)
- Loading states on all async operations
- Error states with retry actions on all screens
- Empty states with helpful illustrations on all list screens
- Golden tests for key screens (RecipesScreen, RecipeDetail, PantryScreen)
- Full integration test suite covering primary user flows:
  - Add recipe → plan it → generate shopping list → mark as cooked → verify pantry
- Performance: recipe list of 100+ items scrolls at 60 fps
- App icon (Android + Windows)
- App name in correct language
- Final `flutter analyze` — zero warnings

**Acceptance Criteria:**
- [ ] All UI screens tested on Android (phone) and Windows
- [ ] `flutter analyze` passes with zero issues
- [ ] All integration tests pass
- [ ] Primary user flow works end-to-end
- [ ] No known bugs in BUGS.md marked as open

---

## Dependency Graph

```
Stage 1 (Foundation)
  └── Stage 2 (Database)
        ├── Stage 3 (Recipes)
        │     ├── Stage 5 (Serving Calc) → Stage 8 (Cooking Mode)
        │     ├── Stage 9 (Favorites)
        │     └── Stage 11 (Recipe Generator)
        ├── Stage 4 (Pantry)
        │     └── Stage 7 (Shopping List)
        ├── Stage 3 + Stage 4 + Stage 6 (Meal Planner)
        │                           └── Stage 7 (Shopping List)
        ├── Stage 8 (Cooking Mode) → Stage 10 (History)
        └── Stage 12 (Firebase Auth)
              └── Stage 13 (Firestore Sync)
                    └── Stage 14 (Export/Import)
                          └── Stage 15 (Polish)
```

---

## Risk Register

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Drift codegen issues | Medium | High | Lock dependency versions, verify each build |
| Firebase Firestore offline edge cases | Medium | High | Thorough offline/online switching tests |
| Unit conversion ambiguity (g vs kg) | Low | Medium | Strict unit enum, no free-text units |
| Windows file picker API differences | Low | Medium | Abstract behind `FilePickerService` interface |
| Photo URL breaks after export/import | Medium | Medium | Store relative paths, handle migration |
| AI API rate limits (Stage 11+) | Low | Low | Local logic first, AI optional |
