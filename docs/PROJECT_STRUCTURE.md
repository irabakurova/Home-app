# Project Directory Structure
# Family Meal Planner App

**Version:** 1.0.0  
**Date:** 2026-06-07  
**Architecture:** Feature First + Clean Architecture

---

## Root

```
family_meal_planner/
├── android/                        # Android platform project
├── windows/                        # Windows platform project
├── assets/
│   ├── images/                     # Static images, placeholder recipe photo
│   ├── icons/                      # App icons
│   └── translations/               # i18n (ru.json, en.json — future)
├── docs/                           # Project documentation
│   ├── ARCHITECTURE.md
│   ├── DATABASE.md
│   ├── ERD.md
│   ├── PROJECT_STRUCTURE.md
│   ├── ROADMAP.md
│   ├── PROJECT_STATUS.md
│   ├── DECISIONS.md
│   ├── CHANGELOG.md
│   └── BUGS.md
├── lib/
│   ├── main.dart                   # App entry point
│   ├── app.dart                    # MaterialApp + ProviderScope root
│   ├── core/                       # Shared infrastructure
│   └── features/                   # Feature modules
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── integration_test/               # Flutter integration tests
├── pubspec.yaml
├── analysis_options.yaml
├── firebase.json
├── .firebaserc
└── README.md
```

---

## `lib/core/`

```
lib/core/
├── constants/
│   ├── app_constants.dart          # App name, version, min/max servings
│   ├── categories.dart             # RecipeCategory, PantryCategory enums
│   ├── cuisines.dart               # Cuisine enum
│   ├── meal_types.dart             # MealType enum
│   └── units.dart                  # MeasurementUnit enum
│
├── database/
│   ├── app_database.dart           # Drift @DriftDatabase class
│   ├── app_database.g.dart         # Generated (drift_dev)
│   └── migrations/
│       └── migration_v1.dart       # Schema v1 definition
│
├── error/
│   ├── app_exception.dart          # Base exception class
│   └── failures.dart               # Failure subclasses (NetworkFailure, etc.)
│
├── extensions/
│   ├── string_extensions.dart
│   ├── datetime_extensions.dart
│   └── list_extensions.dart
│
├── providers/
│   ├── database_provider.dart      # Drift DB singleton provider
│   ├── firebase_providers.dart     # FirebaseAuth, Firestore providers
│   └── connectivity_provider.dart  # Connectivity stream provider
│
├── router/
│   ├── app_router.dart             # GoRouter configuration
│   └── route_names.dart            # Route path constants
│
├── theme/
│   ├── app_theme.dart              # MaterialTheme light + dark
│   ├── app_colors.dart             # ColorScheme seeds
│   └── app_text_styles.dart        # Typography tokens
│
├── utils/
│   ├── quantity_calculator.dart    # Scale ingredients by servings
│   ├── uuid_generator.dart         # UUID v4 helper
│   └── date_utils.dart             # Week/month boundary helpers
│
└── widgets/
    ├── adaptive_layout.dart        # Mobile/desktop nav switcher
    ├── app_scaffold.dart           # Shell with NavBar / NavRail
    ├── empty_state_widget.dart
    ├── error_widget.dart
    ├── loading_overlay.dart
    └── confirm_dialog.dart
```

---

## `lib/features/auth/`

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── firebase_auth_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── app_user.dart
│   ├── repositories/
│   │   └── auth_repository.dart    # Abstract
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       └── sign_out_usecase.dart
└── presentation/
    ├── providers/
    │   └── auth_provider.dart
    └── screens/
        └── auth_screen.dart
```

---

## `lib/features/recipes/`

```
lib/features/recipes/
├── data/
│   ├── datasources/
│   │   ├── recipe_local_datasource.dart    # Drift queries
│   │   └── recipe_remote_datasource.dart   # Firestore
│   ├── models/
│   │   ├── recipe_model.dart               # Drift TableInfo companion
│   │   └── ingredient_model.dart
│   └── repositories/
│       └── recipe_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── recipe.dart                     # Pure Dart entity (freezed)
│   │   └── ingredient.dart
│   ├── repositories/
│   │   └── recipe_repository.dart          # Abstract
│   └── usecases/
│       ├── get_recipes_usecase.dart
│       ├── get_recipe_by_id_usecase.dart
│       ├── save_recipe_usecase.dart
│       ├── delete_recipe_usecase.dart
│       ├── toggle_favorite_usecase.dart
│       └── search_recipes_usecase.dart
└── presentation/
    ├── providers/
    │   ├── recipes_provider.dart
    │   ├── recipe_detail_provider.dart
    │   └── recipe_form_provider.dart
    ├── screens/
    │   ├── recipes_screen.dart
    │   ├── recipe_detail_screen.dart
    │   ├── recipe_form_screen.dart
    │   └── cooking_mode_screen.dart
    └── widgets/
        ├── recipe_card.dart
        ├── recipe_list.dart
        ├── ingredient_list_tile.dart
        ├── recipe_filter_bar.dart
        ├── serving_selector.dart
        └── category_chip.dart
```

---

## `lib/features/pantry/`

```
lib/features/pantry/
├── data/
│   ├── datasources/
│   │   ├── pantry_local_datasource.dart
│   │   └── pantry_remote_datasource.dart
│   ├── models/
│   │   └── pantry_item_model.dart
│   └── repositories/
│       └── pantry_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── pantry_item.dart
│   ├── repositories/
│   │   └── pantry_repository.dart
│   └── usecases/
│       ├── get_pantry_items_usecase.dart
│       ├── save_pantry_item_usecase.dart
│       ├── delete_pantry_item_usecase.dart
│       ├── deduct_pantry_usecase.dart       # After cooking
│       └── search_pantry_usecase.dart
└── presentation/
    ├── providers/
    │   └── pantry_provider.dart
    ├── screens/
    │   ├── pantry_screen.dart
    │   └── pantry_item_form_screen.dart
    └── widgets/
        ├── pantry_item_card.dart
        ├── pantry_category_section.dart
        └── low_stock_banner.dart
```

---

## `lib/features/meal_planner/`

```
lib/features/meal_planner/
├── data/
│   ├── datasources/
│   │   ├── meal_plan_local_datasource.dart
│   │   └── meal_plan_remote_datasource.dart
│   ├── models/
│   │   ├── meal_plan_model.dart
│   │   └── meal_plan_recipe_model.dart
│   └── repositories/
│       └── meal_plan_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── meal_plan.dart
│   │   └── meal_plan_day.dart              # Aggregated: date + list of recipes
│   ├── repositories/
│   │   └── meal_plan_repository.dart
│   └── usecases/
│       ├── get_meal_plan_usecase.dart
│       ├── add_recipe_to_plan_usecase.dart
│       ├── remove_recipe_from_plan_usecase.dart
│       └── get_plan_date_range_usecase.dart
└── presentation/
    ├── providers/
    │   └── meal_plan_provider.dart
    ├── screens/
    │   └── meal_planner_screen.dart
    └── widgets/
        ├── plan_day_card.dart
        ├── plan_week_view.dart
        ├── plan_range_selector.dart        # Week / 2 weeks / Month
        └── add_recipe_to_day_dialog.dart
```

---

## `lib/features/shopping/`

```
lib/features/shopping/
├── data/
│   ├── datasources/
│   │   ├── shopping_local_datasource.dart
│   │   └── shopping_remote_datasource.dart
│   ├── models/
│   │   ├── shopping_list_model.dart
│   │   └── shopping_item_model.dart
│   └── repositories/
│       └── shopping_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── shopping_list.dart
│   │   └── shopping_item.dart
│   ├── repositories/
│   │   └── shopping_repository.dart
│   └── usecases/
│       ├── generate_shopping_list_usecase.dart  # Core calculation logic
│       ├── get_shopping_list_usecase.dart
│       ├── toggle_shopping_item_usecase.dart
│       └── add_manual_item_usecase.dart
└── presentation/
    ├── providers/
    │   └── shopping_provider.dart
    ├── screens/
    │   └── shopping_list_screen.dart
    └── widgets/
        ├── shopping_item_tile.dart
        ├── shopping_category_section.dart
        └── generate_list_button.dart
```

---

## `lib/features/favorites/`

```
lib/features/favorites/
├── domain/
│   └── usecases/
│       └── get_favorites_usecase.dart      # Reuses recipe repository
└── presentation/
    ├── providers/
    │   └── favorites_provider.dart
    └── screens/
        └── favorites_screen.dart
```

---

## `lib/features/history/`

```
lib/features/history/
├── data/
│   ├── datasources/
│   │   ├── history_local_datasource.dart
│   │   └── history_remote_datasource.dart
│   ├── models/
│   │   ├── cooking_history_model.dart
│   │   └── cooking_history_ingredient_model.dart
│   └── repositories/
│       └── history_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── cooking_history_entry.dart
│   │   └── recipe_statistics.dart          # Cook count, last cooked, etc.
│   ├── repositories/
│   │   └── history_repository.dart
│   └── usecases/
│       ├── log_cooking_usecase.dart         # Logs + deducts pantry
│       ├── get_history_usecase.dart
│       └── get_recipe_statistics_usecase.dart
└── presentation/
    ├── providers/
    │   └── history_provider.dart
    ├── screens/
    │   └── history_screen.dart
    └── widgets/
        ├── history_entry_tile.dart
        └── recipe_stats_card.dart
```

---

## `lib/features/recipe_generator/`

```
lib/features/recipe_generator/
├── data/
│   └── services/
│       ├── recipe_generator_service.dart   # Abstract interface
│       └── local_recipe_generator_service.dart  # Phase 1 implementation
├── domain/
│   └── usecases/
│       └── suggest_recipes_usecase.dart
└── presentation/
    ├── providers/
    │   └── recipe_generator_provider.dart
    └── widgets/
        └── what_can_i_cook_sheet.dart      # BottomSheet with suggestions
```

---

## `lib/features/sync/`

```
lib/features/sync/
├── data/
│   ├── datasources/
│   │   └── sync_queue_datasource.dart      # Drift: sync_queue table ops
│   └── services/
│       └── firestore_sync_service.dart     # Upload/download logic
└── presentation/
    └── providers/
        └── sync_provider.dart              # Sync status stream
```

---

## `lib/features/settings/`

```
lib/features/settings/
├── data/
│   └── repositories/
│       └── settings_repository_impl.dart   # Reads/writes app_settings table
├── domain/
│   └── usecases/
│       ├── export_data_usecase.dart
│       └── import_data_usecase.dart
└── presentation/
    ├── providers/
    │   └── settings_provider.dart
    └── screens/
        └── settings_screen.dart
```

---

## `pubspec.yaml` (key dependencies)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State & DI
  flutter_riverpod: ^2.x.x
  riverpod_annotation: ^2.x.x

  # Navigation
  go_router: ^14.x.x

  # Database
  drift: ^2.x.x
  sqlite3_flutter_libs: ^0.x.x
  path_provider: ^2.x.x
  path: ^1.x.x

  # Firebase
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  firebase_storage: ^latest

  # Secure Storage
  flutter_secure_storage: ^9.x.x

  # Utils
  uuid: ^4.x.x
  freezed_annotation: ^2.x.x
  json_annotation: ^4.x.x
  connectivity_plus: ^6.x.x
  image_picker: ^1.x.x
  file_picker: ^8.x.x
  intl: ^0.19.x

dev_dependencies:
  build_runner: ^2.x.x
  drift_dev: ^2.x.x
  freezed: ^2.x.x
  json_serializable: ^6.x.x
  riverpod_generator: ^2.x.x
  flutter_lints: ^4.x.x
  mocktail: ^1.x.x
```
