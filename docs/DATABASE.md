# Database Schema
# Family Meal Planner App

**ORM:** Drift (SQLite)  
**Version:** 1.1.0  
**Date:** 2026-06-23  
**Schema Version:** 3 (3 migrations)

---

## Tables Overview

| # | Table | Description |
|---|-------|-------------|
| 1 | `recipes` | Recipe master data |
| 2 | `ingredients` | Ingredients belonging to a recipe |
| 3 | `pantry_items` | Home pantry inventory |
| 4 | `meal_plans` | Daily meal plan entries |
| 5 | `meal_plan_recipes` | Junction: plan day ↔ recipe |
| 6 | `shopping_lists` | Shopping list headers |
| 7 | `shopping_items` | Individual shopping list items |
| 8 | `cooking_history` | Log of cooked meals |
| 9 | `cooking_history_ingredients` | Ingredients used per cook entry |
| 10 | `sync_queue` | Pending sync operations |
| 11 | `app_settings` | Key-value settings store |
| 12 | `categories` | Custom system/user categories (added in schema v2) |

---

## 1. `recipes`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | Unique recipe ID |
| `family_id` | TEXT | NOT NULL | Firebase family group ID |
| `title` | TEXT | NOT NULL | Recipe name |
| `description` | TEXT | | Short description |
| `photo_url` | TEXT | | Local path or Firebase Storage URL |
| `category` | TEXT | NOT NULL | hot_dish / soup / salad / side / baking / dessert / breakfast / appetizer / drink / other |
| `cuisine` | TEXT | NOT NULL | russian / european / asian / italian / french / american / eastern / other |
| `cook_time_minutes` | INTEGER | NOT NULL, DEFAULT 30 | Total cook time |
| `default_servings` | INTEGER | NOT NULL, DEFAULT 4 | Base portion count |
| `instructions` | TEXT | NOT NULL | JSON array of step strings |
| `is_favorite` | INTEGER | NOT NULL, DEFAULT 0 | Boolean (0/1) |
| `created_by` | TEXT | NOT NULL | Firebase UID |
| `created_at` | INTEGER | NOT NULL | Unix timestamp ms |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp ms |

**Indexes:** `family_id`, `category`, `cuisine`, `is_favorite`, `updated_at`

---

## 2. `ingredients`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | Unique ingredient ID |
| `recipe_id` | TEXT | NOT NULL, FK → recipes.id | Parent recipe |
| `name` | TEXT | NOT NULL | Ingredient name |
| `quantity` | REAL | NOT NULL | Amount for default servings |
| `unit` | TEXT | NOT NULL | g / kg / ml / l / pcs / tbsp / tsp / cup / pinch |
| `category` | TEXT | | vegetables / fruits / meat / fish / dairy / grains / pasta / spices / baking / frozen / drinks / canned / other |
| `sort_order` | INTEGER | NOT NULL, DEFAULT 0 | Display order |

**Indexes:** `recipe_id`

**Cascade:** DELETE ON recipe delete

---

## 3. `pantry_items`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | Unique item ID |
| `family_id` | TEXT | NOT NULL | Firebase family group ID |
| `name` | TEXT | NOT NULL | Product name |
| `quantity` | REAL | NOT NULL, DEFAULT 0 | Current stock amount |
| `unit` | TEXT | NOT NULL | Same unit enum as ingredients |
| `category` | TEXT | NOT NULL | Same category enum as ingredients |
| `min_quantity` | REAL | DEFAULT 0 | Alert threshold |
| `created_at` | INTEGER | NOT NULL | Unix timestamp ms |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp ms |

**Indexes:** `family_id`, `category`, `name`

---

## 4. `meal_plans`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | Unique plan ID |
| `family_id` | TEXT | NOT NULL | Firebase family group ID |
| `plan_date` | INTEGER | NOT NULL | Unix timestamp ms (day boundary) |
| `meal_type` | TEXT | NOT NULL | breakfast / lunch / dinner / snack |
| `servings` | INTEGER | NOT NULL, DEFAULT 4 | Planned portion count |
| `created_at` | INTEGER | NOT NULL | Unix timestamp ms |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp ms |

**Unique constraint:** `(family_id, plan_date, meal_type)` — one entry per meal slot per day  
**Indexes:** `family_id`, `plan_date`

---

## 5. `meal_plan_recipes`

Junction table for many-to-many: one meal plan slot can have multiple recipes.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `meal_plan_id` | TEXT | NOT NULL, FK → meal_plans.id | Parent plan |
| `recipe_id` | TEXT | NOT NULL, FK → recipes.id | Recipe |
| `sort_order` | INTEGER | NOT NULL, DEFAULT 0 | Display order |

**Indexes:** `meal_plan_id`, `recipe_id`

---

## 6. `shopping_lists`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `family_id` | TEXT | NOT NULL | Firebase family group ID |
| `name` | TEXT | NOT NULL | e.g. "Week of 2026-06-07" |
| `date_from` | INTEGER | NOT NULL | Plan start date (Unix ms) |
| `date_to` | INTEGER | NOT NULL | Plan end date (Unix ms) |
| `is_completed` | INTEGER | NOT NULL, DEFAULT 0 | Boolean |
| `created_at` | INTEGER | NOT NULL | Unix timestamp ms |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp ms |

---

## 7. `shopping_items`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `shopping_list_id` | TEXT | NOT NULL, FK → shopping_lists.id | Parent list |
| `name` | TEXT | NOT NULL | Product name |
| `quantity_needed` | REAL | NOT NULL | Total from recipes |
| `quantity_in_pantry` | REAL | NOT NULL, DEFAULT 0 | Snapshot at generation time |
| `quantity_to_buy` | REAL | NOT NULL | = needed - in_pantry (≥ 0) |
| `unit` | TEXT | NOT NULL | |
| `category` | TEXT | | For grouping in UI |
| `is_checked` | INTEGER | NOT NULL, DEFAULT 0 | User ticked off |
| `is_manual` | INTEGER | NOT NULL, DEFAULT 0 | Manually added (not from recipe) |

**Indexes:** `shopping_list_id`

---

## 8. `cooking_history`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `family_id` | TEXT | NOT NULL | |
| `recipe_id` | TEXT | NOT NULL, FK → recipes.id | Which recipe was cooked |
| `recipe_title` | TEXT | NOT NULL | Snapshot of title at cook time |
| `servings_cooked` | INTEGER | NOT NULL | Actual portions made |
| `cooked_by` | TEXT | NOT NULL | Firebase UID |
| `cooked_at` | INTEGER | NOT NULL | Unix timestamp ms |
| `notes` | TEXT | | Optional cook notes |

**Indexes:** `family_id`, `recipe_id`, `cooked_at`

---

## 9. `cooking_history_ingredients`

Snapshot of ingredients actually consumed.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `history_id` | TEXT | NOT NULL, FK → cooking_history.id | Parent log |
| `ingredient_name` | TEXT | NOT NULL | Snapshot name |
| `quantity_used` | REAL | NOT NULL | Calculated for actual servings |
| `unit` | TEXT | NOT NULL | |
| `pantry_item_id` | TEXT | | FK → pantry_items.id (nullable — item may not exist) |

---

## 10. `sync_queue`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | |
| `entity_type` | TEXT | NOT NULL | recipe / ingredient / pantry_item / meal_plan / shopping_list / shopping_item / cooking_history |
| `entity_id` | TEXT | NOT NULL | The affected record's UUID |
| `operation` | TEXT | NOT NULL | create / update / delete |
| `payload` | TEXT | NOT NULL | JSON snapshot of the entity |
| `retry_count` | INTEGER | NOT NULL, DEFAULT 0 | Failed sync attempts |
| `created_at` | INTEGER | NOT NULL | Unix timestamp ms |

**Indexes:** `entity_type`, `created_at`

---

## 11. `app_settings`

Simple key-value store for non-sensitive settings.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `key` | TEXT | PK | Setting key |
| `value` | TEXT | NOT NULL | Setting value (JSON-encoded) |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp ms |

**Sample keys:** `theme_mode`, `default_servings`, `last_sync_at`, `family_id`

---

## 12. `categories`

Custom categories for recipes, cuisines, and pantry items. System categories are seeded on DB creation and cannot be deleted.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | TEXT (UUID) | PK | Unique category ID |
| `family_id` | TEXT | NOT NULL | Firebase family group ID |
| `type` | TEXT | NOT NULL | `recipe` / `cuisine` / `pantry` |
| `name` | TEXT | NOT NULL | Display name (Russian) |
| `value` | TEXT | NOT NULL | Slug value (used in recipe.category field) |
| `is_system` | INTEGER | NOT NULL, DEFAULT 0 | 1 = system-seeded, cannot delete |
| `sort_order` | INTEGER | NOT NULL, DEFAULT 0 | Display order |

**Unique constraint:** `(family_id, type, value)` — no duplicate slugs per type per family  
**Indexes:** `family_id`, `type`

**Seeded system categories (schema v2):**
- Recipe (10): Горячее блюдо, Суп, Салат, Гарнир, Выпечка, Десерт, Завтрак, Закуска, Напиток, Другое
- Cuisine (8): Русская, Европейская, Азиатская, Итальянская, Французская, Американская, Восточная, Другое
- Pantry (13): Овощи, Фрукты, Мясо, Рыба, Молочные, Крупы, Паста, Приправы, Выпечка, Заморозка, Напитки, Консервы, Другое

---

## Enumerations

### Categories (ingredients & pantry)
`vegetables`, `fruits`, `meat`, `fish`, `dairy`, `grains`, `pasta`, `spices`, `baking`, `frozen`, `drinks`, `canned`, `other`

### Recipe Categories
`hot_dish`, `soup`, `salad`, `side`, `baking`, `dessert`, `breakfast`, `appetizer`, `drink`, `other`

### Cuisines
`russian`, `european`, `asian`, `italian`, `french`, `american`, `eastern`, `other`

### Units
`g`, `kg`, `ml`, `l`, `pcs`, `tbsp`, `tsp`, `cup`, `pinch`

### Meal Types
`breakfast`, `lunch`, `dinner`, `snack`

---

## Migrations Strategy

- Drift `MigrationStrategy` with versioned `onUpgrade` callbacks.
- Every schema change increments `schemaVersion`.
- Migrations are additive only (no destructive changes in production).
- `onUpgrade` is tested with `SchemaVerifier` in integration tests.

---

## Quantity Recalculation Formula

```
scaled_quantity = (base_quantity / default_servings) × selected_servings

Example:
  base_quantity    = 600 g  (for 4 servings)
  selected_servings = 2
  scaled_quantity  = (600 / 4) × 2 = 300 g
```

## Shopping List Generation Formula

```
for each recipe in meal_plan:
  for each ingredient in recipe:
    needed[ingredient.name] += scale(ingredient.quantity, recipe.servings)

for each item in pantry:
  in_stock[item.name] = item.quantity

to_buy[name] = max(0, needed[name] - in_stock.get(name, 0))
```

## Pantry Deduction After Cooking

```
for each ingredient in cooked_recipe:
  pantry_item = find_pantry_item_by_name(ingredient.name)
  if pantry_item exists:
    new_quantity = pantry_item.quantity - scaled_ingredient_quantity
    if new_quantity < 0:
      show_warning("Insufficient: {ingredient.name}")
      new_quantity = 0
    update_pantry_item(new_quantity)
  log_to_cooking_history_ingredients(ingredient, quantity_used)
```
