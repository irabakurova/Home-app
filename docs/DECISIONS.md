# Architecture Decision Records (ADR)
# Family Meal Planner App

---

## ADR-001: Feature First + Clean Architecture

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** Organize code by feature module (recipes, pantry, etc.) with Clean Architecture layers inside each feature (data / domain / presentation).

**Rationale:** Feature-first makes it easy to find all code related to one business capability. Clean Architecture enforces testability by separating domain logic from Flutter/Firebase specifics.

**Consequences:** More folders than a simple layered approach. Justified by project complexity and team growth potential.

---

## ADR-002: Riverpod over BLoC

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** Use Riverpod 2.x for all state management and dependency injection.

**Rationale:** Riverpod requires less boilerplate than BLoC for this project size, supports code generation via `riverpod_generator`, and allows providers to be overridden in tests without a DI container.

---

## ADR-003: Drift ORM for local database

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** Use Drift (formerly Moor) for type-safe SQLite access.

**Rationale:** Compile-time checked queries, Dart-native DSL, built-in migration support, excellent Riverpod integration via `StreamProvider`.

---

## ADR-004: Offline First via sync queue

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** All writes go to SQLite first. A `sync_queue` table records pending changes that `SyncService` flushes to Firestore when online.

**Rationale:** The app must work fully without internet (core family use case). Optimistic local writes give instant UI feedback.

**Conflict resolution:** Last-write-wins per field, using `updated_at` Unix timestamp.

---

## ADR-005: UUID as primary keys (TEXT)

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** All tables use UUID v4 as TEXT primary keys, not INTEGER AUTOINCREMENT.

**Rationale:** UUIDs can be generated client-side without a DB round-trip, which is essential for offline-first inserts that need to sync to Firestore later with a stable ID.

---

## ADR-006: Ingredient matching by name (not FK) for pantry deduction

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** When deducting pantry items after cooking, match by ingredient name (case-insensitive) rather than a strict FK relationship.

**Rationale:** Users enter ingredients as free text. Requiring a pantry FK for every recipe ingredient would create too much friction. Name matching with a fuzzy threshold is more practical for a family app.

**Consequence:** Name spelling must be consistent. Future improvement: autocomplete from pantry when entering recipe ingredients.

---

## ADR-008: Inline pantry quantity editing

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** In the PantryScreen, quantity can be edited inline (tap the number → input field) without opening a full form. A "zero out" button quickly sets quantity to 0 for spoiled items.

**Rationale:** After shopping, users buy approximate amounts. Food can spoil before use. Friction-free editing encourages keeping pantry data accurate, which makes shopping list generation reliable.

**Consequence:** PantryItemTile needs an inline edit mode. Full form still available for changing category/unit/name.

---

## ADR-007: GoRouter for navigation

**Date:** 2026-06-07  
**Status:** Accepted

**Decision:** Use GoRouter 14.x with shell routes for nested navigation.

**Rationale:** GoRouter is the Flutter team-recommended solution for declarative routing with deep-link support. Shell routes allow a persistent nav bar/rail while switching screens.
