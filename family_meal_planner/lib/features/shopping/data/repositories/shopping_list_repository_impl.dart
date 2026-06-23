import 'package:drift/drift.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/database/daos/recipes_dao.dart';
import '../../../../core/database/daos/shopping_dao.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../meal_planner/domain/repositories/meal_plan_repository.dart';
import '../../../recipes/data/models/recipe_mapper.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/repositories/shopping_list_repository.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  ShoppingListRepositoryImpl(
    this._shoppingDao,
    this._mealPlanRepo,
    this._recipesDao,
    this._pantryDao,
  );

  final ShoppingDao _shoppingDao;
  final MealPlanRepository _mealPlanRepo;
  final RecipesDao _recipesDao;
  final PantryDao _pantryDao;

  // ── Watch all lists ───────────────────────────────────────────────────────

  @override
  Stream<List<ShoppingList>> watchLists(String familyId) {
    return _shoppingDao.watchAll(familyId).asyncMap((rows) async {
      final lists = <ShoppingList>[];
      for (final row in rows) {
        final items = await _shoppingDao.getItems(row.id);
        lists.add(_buildList(row, items));
      }
      return lists;
    });
  }

  // ── Watch single list (reacts to item changes) ────────────────────────────

  @override
  Stream<ShoppingList?> watchList(String id) {
    return _shoppingDao.watchItems(id).asyncMap((itemRows) async {
      final listRow = await _shoppingDao.getById(id);
      if (listRow == null) return null;
      return _buildList(listRow, itemRows);
    });
  }

  // ── Generate from meal plan ───────────────────────────────────────────────

  @override
  Future<ShoppingList> generateFromMealPlan({
    required String familyId,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? name,
  }) async {
    // 1. Load all meal plan entries for the date range
    final entries = await _mealPlanRepo.getRange(familyId, dateFrom, dateTo);

    // 2. Aggregate ingredients across all recipes, scaling by entry.servings
    final aggregated = <String, _IngAgg>{};
    for (final entry in entries) {
      for (final recipe in entry.recipes) {
        final ingRows = await _recipesDao.getByRecipe(recipe.id);
        for (final row in ingRows) {
          final ing = RecipeMapper.ingredientFromDb(row);

          // Scale: entry specifies how many servings were planned
          final scale = recipe.defaultServings > 0
              ? entry.servings / recipe.defaultServings
              : 1.0;
          final scaledQty = ing.quantity * scale;

          // Key: normalised name + unit for aggregation
          final key =
              '${ing.name.trim().toLowerCase()}|${ing.unit.value}';

          if (aggregated.containsKey(key)) {
            aggregated[key] = aggregated[key]!
                .copyWithQty(aggregated[key]!.quantity + scaledQty);
          } else {
            aggregated[key] = _IngAgg(
              name: ing.name.trim(),
              quantity: scaledQty,
              unit: ing.unit,
              category: ing.category,
            );
          }
        }
      }
    }

    // 3. Load pantry stock for pantry matching
    final pantryItems = await _pantryDao.getAll(familyId);

    // 4. Create the shopping list header
    final listId = UuidGenerator.generate();
    final now = DateTime.now().millisecondsSinceEpoch;
    final listName = name ?? _defaultName(dateFrom, dateTo);

    await _shoppingDao.upsertList(ShoppingListsTableCompanion(
      id: Value(listId),
      familyId: Value(familyId),
      name: Value(listName),
      dateFrom: Value(dateFrom.millisecondsSinceEpoch),
      dateTo: Value(dateTo.millisecondsSinceEpoch),
      isCompleted: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));

    // 5. Create one ShoppingItem per aggregated ingredient
    for (final agg in aggregated.values) {
      // Find pantry stock: exact name (case-insensitive) + exact unit
      final inPantry = pantryItems
          .where((p) =>
              p.name.trim().toLowerCase() == agg.name.toLowerCase() &&
              p.unit == agg.unit.value)
          .fold<double>(0.0, (sum, p) => sum + p.quantity);

      final toBuy =
          (agg.quantity - inPantry).clamp(0.0, double.maxFinite);

      await _shoppingDao.upsertItem(ShoppingItemsTableCompanion(
        id: Value(UuidGenerator.generate()),
        shoppingListId: Value(listId),
        name: Value(agg.name),
        quantityNeeded: Value(agg.quantity),
        quantityInPantry: Value(inPantry),
        quantityToBuy: Value(toBuy),
        unit: Value(agg.unit.value),
        category: Value(agg.category?.value),
        isChecked: const Value(false),
        isManual: const Value(false),
      ));
    }

    // 6. Fetch and return the newly created list
    final listRow = await _shoppingDao.getById(listId);
    final itemRows = await _shoppingDao.getItems(listId);
    return _buildList(listRow!, itemRows);
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  @override
  Future<void> toggleItem(String itemId, {required bool isChecked}) =>
      _shoppingDao.toggleItem(itemId, isChecked);

  @override
  Future<void> deleteList(String id) => _shoppingDao.deleteList(id);

  @override
  Future<void> deleteItem(String id) => _shoppingDao.deleteItem(id);

  @override
  Future<void> addManualItem({
    required String listId,
    required String name,
    required double quantity,
    required MeasurementUnit unit,
    PantryCategory? category,
  }) async {
    await _shoppingDao.upsertItem(ShoppingItemsTableCompanion(
      id: Value(UuidGenerator.generate()),
      shoppingListId: Value(listId),
      name: Value(name.trim()),
      quantityNeeded: Value(quantity),
      quantityInPantry: const Value(0.0),
      quantityToBuy: Value(quantity),
      unit: Value(unit.value),
      category: Value(category?.value),
      isChecked: const Value(false),
      isManual: const Value(true),
    ));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  ShoppingList _buildList(
    ShoppingListsTableData row,
    List<ShoppingItemsTableData> itemRows,
  ) {
    return ShoppingList(
      id: row.id,
      familyId: row.familyId,
      name: row.name,
      dateFrom: DateTime.fromMillisecondsSinceEpoch(row.dateFrom),
      dateTo: DateTime.fromMillisecondsSinceEpoch(row.dateTo),
      isCompleted: row.isCompleted,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      items: itemRows.map(_mapItem).toList(),
    );
  }

  ShoppingItem _mapItem(ShoppingItemsTableData data) {
    return ShoppingItem(
      id: data.id,
      shoppingListId: data.shoppingListId,
      name: data.name,
      quantityNeeded: data.quantityNeeded,
      quantityInPantry: data.quantityInPantry,
      quantityToBuy: data.quantityToBuy,
      unit: MeasurementUnit.fromValue(data.unit),
      category: data.category != null
          ? PantryCategory.fromValue(data.category!)
          : null,
      isChecked: data.isChecked,
      isManual: data.isManual,
    );
  }

  /// Default name: "7 июн — 13 июн"
  String _defaultName(DateTime from, DateTime to) {
    const months = [
      '', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ];
    return '${from.day} ${months[from.month]} — '
        '${to.day} ${months[to.month]}';
  }
}

// ── Private aggregation helper ────────────────────────────────────────────────

class _IngAgg {
  const _IngAgg({
    required this.name,
    required this.quantity,
    required this.unit,
    this.category,
  });

  final String name;
  final double quantity;
  final MeasurementUnit unit;
  final PantryCategory? category;

  _IngAgg copyWithQty(double qty) =>
      _IngAgg(name: name, quantity: qty, unit: unit, category: category);
}
