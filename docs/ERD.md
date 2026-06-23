# Entity Relationship Diagram
# Family Meal Planner App

**Version:** 1.0.0  
**Date:** 2026-06-07

---

## ERD (Text Notation)

```
┌─────────────────────────────┐
│           RECIPES            │
│─────────────────────────────│
│ PK  id            TEXT      │
│     family_id     TEXT      │
│     title         TEXT      │
│     description   TEXT      │
│     photo_url     TEXT      │
│     category      TEXT      │
│     cuisine       TEXT      │
│     cook_time_min INTEGER   │
│     default_serv  INTEGER   │
│     instructions  TEXT(JSON)│
│     is_favorite   INTEGER   │
│     created_by    TEXT      │
│     created_at    INTEGER   │
│     updated_at    INTEGER   │
└──────────────┬──────────────┘
               │ 1
               │
               │ N
┌──────────────▼──────────────┐      ┌────────────────────────────┐
│         INGREDIENTS          │      │       COOKING_HISTORY       │
│─────────────────────────────│      │────────────────────────────│
│ PK  id            TEXT      │      │ PK  id            TEXT     │
│ FK  recipe_id     TEXT ─────┘      │     family_id     TEXT     │
│     name          TEXT      │      │ FK  recipe_id     TEXT ────┘
│     quantity      REAL      │      │     recipe_title  TEXT     │
│     unit          TEXT      │      │     servings_cooked INTEGER│
│     category      TEXT      │      │     cooked_by     TEXT     │
│     sort_order    INTEGER   │      │     cooked_at     INTEGER  │
└─────────────────────────────┘      │     notes         TEXT     │
                                     └──────────────┬─────────────┘
                                                    │ 1
                                                    │
                                                    │ N
                                     ┌──────────────▼─────────────┐
                                     │ COOKING_HISTORY_INGREDIENTS │
                                     │────────────────────────────│
                                     │ PK  id            TEXT     │
                                     │ FK  history_id    TEXT     │
                                     │     ingredient_name TEXT   │
                                     │     quantity_used REAL     │
                                     │     unit          TEXT     │
                                     │ FK? pantry_item_id TEXT    │
                                     └────────────────────────────┘


┌─────────────────────────────┐
│         PANTRY_ITEMS         │
│─────────────────────────────│
│ PK  id            TEXT      │
│     family_id     TEXT      │
│     name          TEXT      │
│     quantity      REAL      │
│     unit          TEXT      │
│     category      TEXT      │
│     min_quantity  REAL      │
│     created_at    INTEGER   │
│     updated_at    INTEGER   │
└─────────────────────────────┘
        ▲ FK (optional, by name)
        │
        └─ cooking_history_ingredients.pantry_item_id


┌─────────────────────────────┐
│          MEAL_PLANS          │
│─────────────────────────────│
│ PK  id            TEXT      │
│     family_id     TEXT      │
│     plan_date     INTEGER   │
│     meal_type     TEXT      │
│     servings      INTEGER   │
│     created_at    INTEGER   │
│     updated_at    INTEGER   │
└──────────────┬──────────────┘
               │ 1
               │
               │ N
┌──────────────▼──────────────┐
│      MEAL_PLAN_RECIPES       │
│─────────────────────────────│
│ PK  id            TEXT      │
│ FK  meal_plan_id  TEXT      │──→ MEAL_PLANS.id
│ FK  recipe_id     TEXT      │──→ RECIPES.id
│     sort_order    INTEGER   │
└─────────────────────────────┘


┌─────────────────────────────┐
│        SHOPPING_LISTS        │
│─────────────────────────────│
│ PK  id            TEXT      │
│     family_id     TEXT      │
│     name          TEXT      │
│     date_from     INTEGER   │
│     date_to       INTEGER   │
│     is_completed  INTEGER   │
│     created_at    INTEGER   │
│     updated_at    INTEGER   │
└──────────────┬──────────────┘
               │ 1
               │
               │ N
┌──────────────▼──────────────┐
│        SHOPPING_ITEMS        │
│─────────────────────────────│
│ PK  id               TEXT   │
│ FK  shopping_list_id TEXT   │
│     name             TEXT   │
│     quantity_needed  REAL   │
│     quantity_in_pantry REAL │
│     quantity_to_buy  REAL   │
│     unit             TEXT   │
│     category         TEXT   │
│     is_checked       INTEGER│
│     is_manual        INTEGER│
└─────────────────────────────┘


┌─────────────────────────────┐
│          SYNC_QUEUE          │
│─────────────────────────────│
│ PK  id            TEXT      │
│     entity_type   TEXT      │
│     entity_id     TEXT      │
│     operation     TEXT      │
│     payload       TEXT(JSON)│
│     retry_count   INTEGER   │
│     created_at    INTEGER   │
└─────────────────────────────┘


┌─────────────────────────────┐
│         APP_SETTINGS         │
│─────────────────────────────│
│ PK  key           TEXT      │
│     value         TEXT(JSON)│
│     updated_at    INTEGER   │
└─────────────────────────────┘
```

---

## Relationship Summary

```
RECIPES ──< INGREDIENTS                  (1:N, cascade delete)
RECIPES ──< MEAL_PLAN_RECIPES            (1:N)
RECIPES ──< COOKING_HISTORY              (1:N, soft ref — title snapshot kept)
MEAL_PLANS ──< MEAL_PLAN_RECIPES         (1:N, cascade delete)
SHOPPING_LISTS ──< SHOPPING_ITEMS        (1:N, cascade delete)
COOKING_HISTORY ──< COOKING_HISTORY_INGREDIENTS (1:N, cascade delete)
PANTRY_ITEMS ──o< COOKING_HISTORY_INGREDIENTS  (0..1:N, optional FK)
```

---

## Firebase Firestore Document Structure

Mirrors SQLite structure, organized under `families/{familyId}/`:

```
families/
  {familyId}/
    recipes/
      {recipeId}         ← Recipe document (matches recipes table)
        ingredients/
          {ingredientId} ← Sub-collection
    pantry_items/
      {itemId}
    meal_plans/
      {planId}
        meal_plan_recipes/
          {junctionId}
    shopping_lists/
      {listId}
        shopping_items/
          {itemId}
    cooking_history/
      {historyId}
        cooking_history_ingredients/
          {ingredientId}

users/
  {uid}/               ← User profile: displayName, familyId, email
```

**Firestore Security Rules (concept):**
```
match /families/{familyId}/{document=**} {
  allow read, write: if request.auth != null
    && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.familyId == familyId;
}
```
