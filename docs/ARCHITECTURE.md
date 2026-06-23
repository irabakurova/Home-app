# Architecture Design Document (ADD)
# Family Meal Planner App

**Version:** 1.0.0  
**Date:** 2026-06-07  
**Status:** Draft — Pre-implementation

---

## 1. Overview

Cross-platform Flutter application for family meal planning, recipe management, pantry tracking, and shopping list generation. Targets Android and Windows from a single codebase.

**Primary Users:** Husband + Wife (shared account, synchronized data)

---

## 2. Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| UI Framework | Flutter | 3.x (latest stable) |
| Language | Dart | 3.x |
| State Management | Riverpod | 2.x |
| Navigation | Go Router | 14.x |
| Local DB | SQLite via Drift ORM | 2.x |
| Auth | Firebase Authentication | latest |
| Remote DB | Firebase Firestore | latest |
| File Storage | Firebase Cloud Storage | latest |
| Secure Storage | Flutter Secure Storage | 9.x |
| Design System | Material 3 | built-in |
| Architecture | Clean Architecture + Feature First | — |

---

## 3. Architectural Principles

### 3.1 Clean Architecture Layers (per feature)

```
┌─────────────────────────────────────────────┐
│               Presentation Layer             │
│     (Widgets, Screens, Riverpod Providers)  │
├─────────────────────────────────────────────┤
│               Domain Layer                  │
│       (Entities, Use Cases, Repo Interfaces)│
├─────────────────────────────────────────────┤
│               Data Layer                    │
│  (Repositories, Data Sources, DTOs, Mappers)│
├─────────────────────────────────────────────┤
│               Infrastructure               │
│    (Drift DB, Firebase, Secure Storage)     │
└─────────────────────────────────────────────┘
```

### 3.2 Data Flow

```
UI Event
  → Riverpod Notifier / AsyncNotifier
    → Use Case
      → Repository Interface (domain)
        → Repository Implementation (data)
          → Local DataSource (Drift) ←→ Remote DataSource (Firestore)
            → Entity / DTO
              → State update → UI rebuild
```

### 3.3 Offline First Strategy

1. All writes go to SQLite first.
2. A sync queue records pending changes with timestamps.
3. `SyncService` monitors connectivity and flushes the queue to Firestore.
4. Firestore changes are streamed back and merged into SQLite.
5. Conflict resolution: **last-write-wins** per field, using `updatedAt` timestamp.

---

## 4. Feature Modules

| Module | Responsibility |
|--------|---------------|
| `recipes` | CRUD for recipes, ingredients, categories, cuisines |
| `pantry` | Pantry inventory CRUD, stock tracking |
| `meal_planner` | Weekly/bi-weekly/monthly menu planning |
| `shopping` | Auto-generated shopping lists, manual edits |
| `favorites` | Favorite recipe management |
| `history` | Cooking history log and statistics |
| `recipe_generator` | "What can I cook?" logic; AI API abstraction layer |
| `sync` | Firebase sync service, connectivity monitoring |
| `settings` | Theme, export/import, backup, sync status |
| `auth` | Firebase Authentication, user session |

---

## 5. Core Shared Components

### 5.1 Core Layer (`lib/core/`)

```
core/
├── constants/          # App-wide constants (categories, cuisines, units)
├── error/              # Failure classes, AppException hierarchy
├── extensions/         # Dart extensions (String, DateTime, List)
├── theme/              # MaterialTheme, ColorScheme, Typography tokens
├── router/             # GoRouter configuration, route names/paths
├── providers/          # Top-level shared providers (DB, Firebase)
├── utils/              # Unit converters, date helpers, quantity math
└── widgets/            # Shared UI widgets (LoadingOverlay, EmptyState, etc.)
```

### 5.2 Dependency Injection

Riverpod `Provider`/`AsyncNotifier` tree. No service locator. All dependencies flow through provider graph. `ProviderScope` at app root; `overrideWith` used for testing.

---

## 6. Navigation Architecture

GoRouter with nested shell routes:

```
/                       → SplashScreen (auth check)
/auth                   → AuthScreen (login/register)
/home                   → HomeShell (BottomNavBar / NavRail)
  /recipes              → RecipesScreen
    /recipes/:id        → RecipeDetailScreen
    /recipes/new        → RecipeFormScreen
    /recipes/:id/edit   → RecipeFormScreen (edit mode)
    /recipes/:id/cook   → CookingModeScreen
  /pantry               → PantryScreen
    /pantry/new         → PantryItemFormScreen
  /planner              → MealPlannerScreen
  /shopping             → ShoppingListScreen
  /favorites            → FavoritesScreen
/history                → HistoryScreen
/settings               → SettingsScreen
```

**Adaptive Navigation:**
- Android (mobile): `NavigationBar` (bottom)
- Windows (desktop): `NavigationRail` (left sidebar, expandable)

---

## 7. State Management Patterns

| Scenario | Riverpod Type |
|----------|--------------|
| Stream of DB records | `StreamProvider` |
| Async data fetch | `AsyncNotifierProvider` |
| UI form state | `NotifierProvider` |
| Global app state | `Provider` (singleton) |
| User session | `StreamProvider` (Firebase auth stream) |

**State classes** use `freezed` for immutability and `copyWith`.

---

## 8. Sync Architecture

```
Local Action
  → Write to SQLite
  → Add record to sync_queue table (entity_type, entity_id, operation, payload, created_at)
  → Emit state update (UI responds immediately)

SyncService (background isolate)
  → Listen to connectivity stream
  → On connected: flush sync_queue to Firestore in batches
  → Listen to Firestore snapshots
  → On remote change: update SQLite, remove from sync_queue
  → On conflict: last-write-wins via updatedAt field
```

**Sync triggers:**
- App foreground event
- Network reconnect event
- Explicit user pull-to-refresh

---

## 9. AI Recipe Generator Architecture

Abstraction layer for future AI integration:

```dart
abstract class RecipeGeneratorService {
  Future<List<Recipe>> generateFromPantry(List<PantryItem> items);
}

// Phase 1 — local matching logic
class LocalRecipeGeneratorService implements RecipeGeneratorService { ... }

// Future phases
class OpenAIRecipeGeneratorService implements RecipeGeneratorService { ... }
class ClaudeRecipeGeneratorService implements RecipeGeneratorService { ... }
class GeminiRecipeGeneratorService implements RecipeGeneratorService { ... }
```

The active implementation is injected via Riverpod provider; switching AI provider requires changing one line.

---

## 10. Platform Adaptations

| Feature | Android | Windows |
|---------|---------|---------|
| Navigation | BottomNavigationBar | NavigationRail |
| Image picker | camera + gallery | file picker |
| Window size | fixed portrait | resizable, min 800×600 |
| Text scale | system | user-controlled |
| Keyboard | soft keyboard | physical keyboard |
| Shortcuts | — | Ctrl+N, Ctrl+F, etc. |

---

## 11. Security

- Firebase Auth tokens stored via `flutter_secure_storage`
- No sensitive data in SharedPreferences
- Firestore rules: users can only read/write their own `familyId` documents
- Local DB: not encrypted (no PII beyond user display name)
- Export files: plain JSON (user controls storage location)

---

## 12. Error Handling Strategy

```
DataSource exception
  → mapped to Failure subclass (NetworkFailure, CacheFailure, etc.)
    → returned as Either<Failure, T> from Repository
      → caught in UseCase
        → exposed as AsyncValue.error in Riverpod state
          → UI shows SnackBar or error widget
```

---

## 13. Testing Strategy

| Layer | Approach |
|-------|---------|
| Domain / Use Cases | Pure Dart unit tests (no Flutter) |
| Repositories | Unit tests with mocked data sources |
| Drift DB | Integration tests with in-memory SQLite |
| Riverpod Providers | `ProviderContainer` + `overrideWith` |
| Widgets | `WidgetTester` + golden tests |
| E2E | `integration_test` package |
