import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show Value;

import '../database/app_database.dart';

/// Offline-First synchronisation between local SQLite (Drift) and Firestore.
///
/// **Pull** — Firestore → local SQLite.
///   Called on app start (after auth) and when connectivity is restored.
///   Uses "last write wins" based on the `updatedAt` / `createdAt` integer
///   timestamp already stored in every table.
///
/// **Push** — local SQLite → Firestore.
///   Called via [pushAll] (manual sync / startup) or per-item helpers after
///   individual mutations in notifiers.
///
/// Firestore path: /families/{familyId}/{collection}/{docId}
class FirestoreSyncService {
  FirestoreSyncService(this._firestore);

  final FirebaseFirestore _firestore;

  // ── Path helpers ─────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _col(
    String familyId,
    String collection,
  ) =>
      _firestore.collection('families/$familyId/$collection');

  // ══════════════════════════════════════════════════════════════════════════
  // PUSH — local → Firestore
  // ══════════════════════════════════════════════════════════════════════════

  /// Pushes every recipe + ingredient from local SQLite to Firestore.
  Future<void> pushRecipes(String familyId, AppDatabase db) async {
    final recipes = await db.recipesDao.getAllForSync(familyId);
    final allIngredients = await db.recipesDao.getAllIngredientsForSync(familyId);

    await _batchWrite(recipes, (batch, recipe) {
      batch.set(_col(familyId, 'recipes').doc(recipe.id), _recipeToMap(recipe));
    });

    await _batchWrite(allIngredients, (batch, ing) {
      batch.set(
        _col(familyId, 'recipe_ingredients').doc(ing.id),
        _ingredientToMap(ing),
      );
    });
  }

  /// Pushes a single recipe + its ingredients (called after save in notifier).
  Future<void> pushSingleRecipe(
    String familyId,
    RecipesTableData recipe,
    List<IngredientsTableData> ingredients,
  ) async {
    final batch = _firestore.batch();
    batch.set(_col(familyId, 'recipes').doc(recipe.id), _recipeToMap(recipe));
    for (final ing in ingredients) {
      batch.set(
        _col(familyId, 'recipe_ingredients').doc(ing.id),
        _ingredientToMap(ing),
      );
    }
    await batch.commit();
  }

  /// Removes a recipe + its ingredients from Firestore.
  Future<void> deleteRemoteRecipe(String familyId, String recipeId) async {
    final batch = _firestore.batch();
    batch.delete(_col(familyId, 'recipes').doc(recipeId));
    final ings = await _col(familyId, 'recipe_ingredients')
        .where('recipeId', isEqualTo: recipeId)
        .get();
    for (final doc in ings.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Pushes all pantry items.
  Future<void> pushPantry(String familyId, AppDatabase db) async {
    final items = await db.pantryDao.getAll(familyId);
    await _batchWrite(items, (batch, item) {
      batch.set(_col(familyId, 'pantry').doc(item.id), _pantryToMap(item));
    });
    // NOTE: we do NOT delete orphans from Firestore here.
    // Deletions are propagated via tombstones written in deleteRemotePantryItem.
  }

  /// Pushes a single pantry item.
  Future<void> pushSinglePantryItem(
      String familyId, PantryItemsTableData item) async {
    await _col(familyId, 'pantry').doc(item.id).set(_pantryToMap(item));
  }

  /// Deletes a pantry item from Firestore AND writes a tombstone so other
  /// devices don't re-add it on their next pull.
  Future<void> deleteRemotePantryItem(
      String familyId, String itemId) async {
    final batch = _firestore.batch();
    batch.delete(_col(familyId, 'pantry').doc(itemId));
    final tombRef =
        _firestore.collection('families/$familyId/tombstones').doc();
    batch.set(tombRef, {
      'type': 'pantry',
      'itemId': itemId,
      'deletedAt': DateTime.now().millisecondsSinceEpoch,
    });
    await batch.commit();
  }

  /// Pushes custom (user-created) categories to Firestore.
  ///
  /// System categories are seeded locally from code and are NOT synced —
  /// they are identical on every device and pushing them caused Bug #77
  /// (duplicates when random UUIDs were used). Only custom categories need
  /// to be shared between devices.
  Future<void> pushCategories(String familyId, AppDatabase db) async {
    final cats = await db.categoriesDao.getAll(familyId);
    final customCats = cats.where((c) => !c.isSystem).toList();
    await _batchWrite(customCats, (batch, cat) {
      batch.set(
          _col(familyId, 'categories').doc(cat.id), _categoryToMap(cat));
    });
  }

  Future<void> pushSingleCategory(
      String familyId, CategoriesTableData cat) async {
    await _col(familyId, 'categories').doc(cat.id).set(_categoryToMap(cat));
  }

  /// Deletes a category from Firestore AND writes a tombstone so other
  /// devices don't re-add it on their next pull.
  Future<void> deleteRemoteCategory(
      String familyId, String categoryId) async {
    final batch = _firestore.batch();
    batch.delete(_col(familyId, 'categories').doc(categoryId));
    final tombRef =
        _firestore.collection('families/$familyId/tombstones').doc();
    batch.set(tombRef, {
      'type': 'category',
      'itemId': categoryId,
      'deletedAt': DateTime.now().millisecondsSinceEpoch,
    });
    await batch.commit();
  }

  /// Pushes meal plans + their recipe slots.
  Future<void> pushMealPlans(String familyId, AppDatabase db) async {
    final plans = await db.mealPlanDao.getAllForSync(familyId);
    final slots = await db.mealPlanDao.getAllSlotsForSync(familyId);
    await _batchWrite(plans, (batch, plan) {
      batch.set(
          _col(familyId, 'meal_plans').doc(plan.id), _mealPlanToMap(plan));
    });
    await _batchWrite(slots, (batch, slot) {
      batch.set(
          _col(familyId, 'meal_plan_recipes').doc(slot.id),
          _mealPlanRecipeToMap(slot));
    });
  }

  /// Pushes shopping lists + items.
  Future<void> pushShopping(String familyId, AppDatabase db) async {
    final lists = await db.shoppingDao.getAllListsForSync(familyId);
    final allItems = <ShoppingItemsTableData>[];
    for (final list in lists) {
      allItems.addAll(await db.shoppingDao.getItems(list.id));
    }
    await _batchWrite(lists, (batch, list) {
      batch.set(
          _col(familyId, 'shopping_lists').doc(list.id),
          _shoppingListToMap(list));
    });
    await _batchWrite(allItems, (batch, item) {
      batch.set(
          _col(familyId, 'shopping_items').doc(item.id),
          _shoppingItemToMap(item));
    });
  }

  /// Pushes cooking history + used ingredients.
  Future<void> pushHistory(String familyId, AppDatabase db) async {
    final entries = await db.historyDao.getAllForSync(familyId);
    final allIngs = <CookingHistoryIngredientsTableData>[];
    for (final entry in entries) {
      allIngs.addAll(await db.historyDao.getIngredientsForEntry(entry.id));
    }
    await _batchWrite(entries, (batch, entry) {
      batch.set(_col(familyId, 'history').doc(entry.id),
          _historyEntryToMap(entry));
    });
    await _batchWrite(allIngs, (batch, ing) {
      batch.set(_col(familyId, 'history_ingredients').doc(ing.id),
          _historyIngToMap(ing));
    });
  }

  /// Full push — all local data → Firestore.
  Future<void> pushAll(String familyId, AppDatabase db) async {
    await Future.wait([
      pushRecipes(familyId, db),
      pushPantry(familyId, db),
      pushCategories(familyId, db),
    ]);
    await pushMealPlans(familyId, db);
    await pushShopping(familyId, db);
    await pushHistory(familyId, db);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PULL — Firestore → local SQLite
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns the set of itemIds marked as deleted for a given [type]
  /// ('pantry' | 'category') in the tombstones collection.
  Future<Set<String>> _fetchTombstoneIds(
      String familyId, String type) async {
    final snap = await _firestore
        .collection('families/$familyId/tombstones')
        .where('type', isEqualTo: type)
        .get();
    return snap.docs
        .map((d) => d.data()['itemId'] as String)
        .toSet();
  }

  Future<void> pullAll(String familyId, AppDatabase db) async {
    await Future.wait([
      _pullRecipes(familyId, db),
      _pullPantry(familyId, db),
      _pullCategories(familyId, db),
    ]);
    await _pullMealPlans(familyId, db);
    await _pullShopping(familyId, db);
    await _pullHistory(familyId, db);
  }

  // ── Recipes ───────────────────────────────────────────────────────────────

  Future<void> _pullRecipes(String familyId, AppDatabase db) async {
    final snap = await _col(familyId, 'recipes').get();
    final ingSnap = await _col(familyId, 'recipe_ingredients').get();

    for (final doc in snap.docs) {
      final data = doc.data();
      await db.recipesDao.upsert(RecipesTableCompanion(
        id: Value(data['id'] as String),
        familyId: Value(data['familyId'] as String),
        title: Value(data['title'] as String),
        description: Value(data['description'] as String?),
        photoUrl: Value(data['photoUrl'] as String?),
        category: Value(data['category'] as String),
        cuisine: Value(data['cuisine'] as String),
        cookTimeMinutes: Value(data['cookTimeMinutes'] as int),
        defaultServings: Value(data['defaultServings'] as int),
        instructions: Value(data['instructions'] as String),
        isFavorite: Value(data['isFavorite'] as bool),
        createdBy: Value(data['createdBy'] as String),
        createdAt: Value(data['createdAt'] as int),
        updatedAt: Value(data['updatedAt'] as int),
      ));
    }

    for (final doc in ingSnap.docs) {
      final data = doc.data();
      await db.recipesDao.upsertIngredient(IngredientsTableCompanion(
        id: Value(data['id'] as String),
        recipeId: Value(data['recipeId'] as String),
        name: Value(data['name'] as String),
        quantity: Value((data['quantity'] as num).toDouble()),
        unit: Value(data['unit'] as String),
        category: Value(data['category'] as String?),
        sortOrder: Value(data['sortOrder'] as int? ?? 0),
      ));
    }
  }

  // ── Pantry ────────────────────────────────────────────────────────────────

  Future<void> _pullPantry(String familyId, AppDatabase db) async {
    // 1. Get tombstoned IDs so we can skip (and clean up) deleted items
    final deletedIds = await _fetchTombstoneIds(familyId, 'pantry');

    // 2. Apply tombstone deletions to local DB (handles items other device
    //    may have added that we then tombstoned here)
    for (final id in deletedIds) {
      await db.pantryDao.deleteById(id);
    }

    // 3. Upsert everything else from Firestore
    final snap = await _col(familyId, 'pantry').get();
    for (final doc in snap.docs) {
      final data = doc.data();
      final id = data['id'] as String;
      if (deletedIds.contains(id)) continue; // tombstoned — skip
      await db.pantryDao.upsert(PantryItemsTableCompanion(
        id: Value(id),
        familyId: Value(data['familyId'] as String),
        name: Value(data['name'] as String),
        quantity: Value((data['quantity'] as num).toDouble()),
        unit: Value(data['unit'] as String),
        category: Value(data['category'] as String),
        minQuantity: Value((data['minQuantity'] as num).toDouble()),
        createdAt: Value(data['createdAt'] as int),
        updatedAt: Value(data['updatedAt'] as int),
      ));
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────
  //
  // Deletion propagation uses tombstones. When a custom category is deleted
  // on any device, a tombstone is written to Firestore. On pull, tombstoned
  // categories are deleted locally regardless of whether they exist in the
  // categories collection. System categories are never touched.

  Future<void> _pullCategories(String familyId, AppDatabase db) async {
    // 1. Get tombstoned category IDs
    final deletedIds = await _fetchTombstoneIds(familyId, 'category');

    // 2. Apply tombstone deletions locally
    for (final id in deletedIds) {
      await db.categoriesDao.deleteCustom(id);
    }

    // 3. Upsert custom categories from Firestore, skipping tombstoned/system ones.
    //    System categories (isSystem == true) are seeded locally from code and
    //    must NOT be pulled — they caused Bug #77 (duplicates via random UUIDs).
    final snap = await _col(familyId, 'categories').get();
    for (final doc in snap.docs) {
      final data = doc.data();
      final id = data['id'] as String;
      if (deletedIds.contains(id)) continue; // tombstoned — skip
      if (data['isSystem'] as bool? ?? false) continue; // system — skip
      await db.categoriesDao.upsert(CategoriesTableCompanion(
        id: Value(id),
        familyId: Value(data['familyId'] as String),
        type: Value(data['type'] as String),
        name: Value(data['name'] as String),
        value: Value(data['value'] as String),
        isSystem: Value(data['isSystem'] as bool),
        sortOrder: Value(data['sortOrder'] as int),
        createdAt: Value(data['createdAt'] as int),
      ));
    }
    // NOTE: we no longer delete local cats that are absent from Firestore —
    // that was the root cause of Bug 1 (phone-added categories wiped by PC push).
    // Tombstones now handle all deletion propagation.
  }

  // ── Meal plans ────────────────────────────────────────────────────────────

  Future<void> _pullMealPlans(String familyId, AppDatabase db) async {
    final plansSnap = await _col(familyId, 'meal_plans').get();
    final slotsSnap = await _col(familyId, 'meal_plan_recipes').get();

    for (final doc in plansSnap.docs) {
      final data = doc.data();
      await db.mealPlanDao.upsertPlan(MealPlansTableCompanion(
        id: Value(data['id'] as String),
        familyId: Value(data['familyId'] as String),
        planDate: Value(data['planDate'] as int),
        mealType: Value(data['mealType'] as String),
        servings: Value(data['servings'] as int? ?? 4),
        createdAt: Value(data['createdAt'] as int),
        updatedAt: Value(data['updatedAt'] as int),
      ));
    }

    for (final doc in slotsSnap.docs) {
      final data = doc.data();
      await db.mealPlanDao.upsertSlot(MealPlanRecipesTableCompanion(
        id: Value(data['id'] as String),
        mealPlanId: Value(data['mealPlanId'] as String),
        recipeId: Value(data['recipeId'] as String),
        sortOrder: Value(data['sortOrder'] as int? ?? 0),
      ));
    }
  }

  // ── Shopping ──────────────────────────────────────────────────────────────

  Future<void> _pullShopping(String familyId, AppDatabase db) async {
    final listsSnap = await _col(familyId, 'shopping_lists').get();
    final itemsSnap = await _col(familyId, 'shopping_items').get();

    for (final doc in listsSnap.docs) {
      final data = doc.data();
      await db.shoppingDao.upsertList(ShoppingListsTableCompanion(
        id: Value(data['id'] as String),
        familyId: Value(data['familyId'] as String),
        name: Value(data['name'] as String? ?? ''),
        dateFrom: Value(data['dateFrom'] as int),
        dateTo: Value(data['dateTo'] as int),
        isCompleted: Value(data['isCompleted'] as bool? ?? false),
        createdAt: Value(data['createdAt'] as int),
        updatedAt: Value(data['updatedAt'] as int),
      ));
    }

    for (final doc in itemsSnap.docs) {
      final data = doc.data();
      await db.shoppingDao.upsertItem(ShoppingItemsTableCompanion(
        id: Value(data['id'] as String),
        shoppingListId: Value(data['shoppingListId'] as String),
        name: Value(data['name'] as String),
        quantityNeeded: Value((data['quantityNeeded'] as num).toDouble()),
        quantityInPantry:
            Value((data['quantityInPantry'] as num?)?.toDouble() ?? 0.0),
        quantityToBuy: Value((data['quantityToBuy'] as num).toDouble()),
        unit: Value(data['unit'] as String),
        category: Value(data['category'] as String?),
        isChecked: Value(data['isChecked'] as bool? ?? false),
        isManual: Value(data['isManual'] as bool? ?? false),
      ));
    }
  }

  // ── History ───────────────────────────────────────────────────────────────

  Future<void> _pullHistory(String familyId, AppDatabase db) async {
    final entriesSnap = await _col(familyId, 'history').get();
    final ingsSnap = await _col(familyId, 'history_ingredients').get();

    for (final doc in entriesSnap.docs) {
      final data = doc.data();
      await db.historyDao.upsertEntry(CookingHistoryTableCompanion(
        id: Value(data['id'] as String),
        familyId: Value(data['familyId'] as String),
        recipeId: Value(data['recipeId'] as String),
        recipeTitle: Value(data['recipeTitle'] as String),
        servingsCooked: Value(data['servingsCooked'] as int),
        cookedBy: Value(data['cookedBy'] as String? ?? ''),
        cookedAt: Value(data['cookedAt'] as int),
        notes: Value(data['notes'] as String?),
      ));
    }

    for (final doc in ingsSnap.docs) {
      final data = doc.data();
      await db.historyDao.upsertHistoryIngredient(CookingHistoryIngredientsTableCompanion(
        id: Value(data['id'] as String),
        historyId: Value(data['historyId'] as String),
        ingredientName: Value(data['ingredientName'] as String),
        quantityUsed: Value((data['quantityUsed'] as num).toDouble()),
        unit: Value(data['unit'] as String),
        pantryItemId: Value(data['pantryItemId'] as String?),
      ));
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Serialisation helpers
  // ══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _recipeToMap(RecipesTableData r) => {
        'id': r.id,
        'familyId': r.familyId,
        'title': r.title,
        'description': r.description,
        'photoUrl': r.photoUrl,
        'category': r.category,
        'cuisine': r.cuisine,
        'cookTimeMinutes': r.cookTimeMinutes,
        'defaultServings': r.defaultServings,
        'instructions': r.instructions,
        'isFavorite': r.isFavorite,
        'createdBy': r.createdBy,
        'createdAt': r.createdAt,
        'updatedAt': r.updatedAt,
      };

  Map<String, dynamic> _ingredientToMap(IngredientsTableData i) => {
        'id': i.id,
        'recipeId': i.recipeId,
        'name': i.name,
        'quantity': i.quantity,
        'unit': i.unit,
        'category': i.category,
        'sortOrder': i.sortOrder,
      };

  Map<String, dynamic> _pantryToMap(PantryItemsTableData p) => {
        'id': p.id,
        'familyId': p.familyId,
        'name': p.name,
        'quantity': p.quantity,
        'unit': p.unit,
        'category': p.category,
        'minQuantity': p.minQuantity,
        'createdAt': p.createdAt,
        'updatedAt': p.updatedAt,
      };

  Map<String, dynamic> _categoryToMap(CategoriesTableData c) => {
        'id': c.id,
        'familyId': c.familyId,
        'type': c.type,
        'name': c.name,
        'value': c.value,
        'isSystem': c.isSystem,
        'sortOrder': c.sortOrder,
        'createdAt': c.createdAt,
      };

  Map<String, dynamic> _mealPlanToMap(MealPlansTableData p) => {
        'id': p.id,
        'familyId': p.familyId,
        'planDate': p.planDate,
        'mealType': p.mealType,
        'servings': p.servings,
        'createdAt': p.createdAt,
        'updatedAt': p.updatedAt,
      };

  Map<String, dynamic> _mealPlanRecipeToMap(MealPlanRecipesTableData s) => {
        'id': s.id,
        'mealPlanId': s.mealPlanId,
        'recipeId': s.recipeId,
        'sortOrder': s.sortOrder,
      };

  Map<String, dynamic> _shoppingListToMap(ShoppingListsTableData l) => {
        'id': l.id,
        'familyId': l.familyId,
        'name': l.name,
        'dateFrom': l.dateFrom,
        'dateTo': l.dateTo,
        'isCompleted': l.isCompleted,
        'createdAt': l.createdAt,
        'updatedAt': l.updatedAt,
      };

  Map<String, dynamic> _shoppingItemToMap(ShoppingItemsTableData i) => {
        'id': i.id,
        'shoppingListId': i.shoppingListId,
        'name': i.name,
        'quantityNeeded': i.quantityNeeded,
        'quantityInPantry': i.quantityInPantry,
        'quantityToBuy': i.quantityToBuy,
        'unit': i.unit,
        'category': i.category,
        'isChecked': i.isChecked,
        'isManual': i.isManual,
      };

  Map<String, dynamic> _historyEntryToMap(CookingHistoryTableData e) => {
        'id': e.id,
        'familyId': e.familyId,
        'recipeId': e.recipeId,
        'recipeTitle': e.recipeTitle,
        'servingsCooked': e.servingsCooked,
        'cookedBy': e.cookedBy,
        'cookedAt': e.cookedAt,
        'notes': e.notes,
      };

  Map<String, dynamic> _historyIngToMap(CookingHistoryIngredientsTableData i) =>
      {
        'id': i.id,
        'historyId': i.historyId,
        'ingredientName': i.ingredientName,
        'quantityUsed': i.quantityUsed,
        'unit': i.unit,
        'pantryItemId': i.pantryItemId,
      };

  // ── Batch write helper ────────────────────────────────────────────────────

  /// Splits [items] into chunks of 400 and commits each as a Firestore batch.
  Future<void> _batchWrite<T>(
    List<T> items,
    void Function(WriteBatch batch, T item) addOp,
  ) async {
    const chunkSize = 400;
    for (var offset = 0; offset < items.length; offset += chunkSize) {
      final chunk = items.skip(offset).take(chunkSize).toList();
      final batch = _firestore.batch();
      for (final item in chunk) {
        addOp(batch, item);
      }
      await batch.commit();
    }
  }
}
