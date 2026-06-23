import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import '../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;

// ── Export format version ─────────────────────────────────────────────────────
const _kExportVersion = 1;

// ── Export result ─────────────────────────────────────────────────────────────

class ExportResult {
  const ExportResult({required this.filePath, required this.stats});

  final String filePath;
  final ExportStats stats;
}

class ExportStats {
  const ExportStats({
    required this.recipes,
    required this.pantry,
    required this.categories,
    required this.mealPlans,
    required this.shoppingLists,
    required this.history,
  });

  final int recipes;
  final int pantry;
  final int categories;
  final int mealPlans;
  final int shoppingLists;
  final int history;

  String get summary =>
      'Рецептов: $recipes, кладовая: $pantry, '
      'меню: $mealPlans, покупки: $shoppingLists, история: $history';
}

// ── Service ───────────────────────────────────────────────────────────────────

class ExportService {
  const ExportService();

  Future<ExportResult> exportToFile(AppDatabase db) async {
    const familyId = kDefaultFamilyId;

    // ── Collect all data ────────────────────────────────────────────────────
    final recipes = await db.recipesDao.getAllForSync(familyId);
    final ingredients = await db.recipesDao.getAllIngredientsForSync(familyId);
    final pantry = await db.pantryDao.getAll(familyId);
    final categories = await db.categoriesDao.getAll(familyId);
    final mealPlans = await db.mealPlanDao.getAllForSync(familyId);
    final mealPlanSlots = await db.mealPlanDao.getAllSlotsForSync(familyId);
    final shoppingLists = await db.shoppingDao.getAllListsForSync(familyId);
    final listIds = shoppingLists.map((l) => l.id).toList();
    final shoppingItems = await db.shoppingDao.getAllItemsForSync(listIds);
    final history = await db.historyDao.getAllForSync(familyId);
    final historyIds = history.map((h) => h.id).toList();
    final historyIngredients =
        await db.historyDao.getAllIngredientsForSync(historyIds);

    // ── Build JSON payload ──────────────────────────────────────────────────
    final data = <String, dynamic>{
      'version': _kExportVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'familyId': familyId,
      'recipes': recipes.map(_recipeToMap).toList(),
      'recipeIngredients': ingredients.map(_ingredientToMap).toList(),
      'pantry': pantry.map(_pantryToMap).toList(),
      'categories': categories.map(_categoryToMap).toList(),
      'mealPlans': mealPlans.map(_mealPlanToMap).toList(),
      'mealPlanSlots': mealPlanSlots.map(_mealPlanSlotToMap).toList(),
      'shoppingLists': shoppingLists.map(_shoppingListToMap).toList(),
      'shoppingItems': shoppingItems.map(_shoppingItemToMap).toList(),
      'cookingHistory': history.map(_historyEntryToMap).toList(),
      'cookingHistoryIngredients':
          historyIngredients.map(_historyIngToMap).toList(),
    };

    // ── Write file ─────────────────────────────────────────────────────────
    final dir = await getApplicationDocumentsDirectory();
    final subDir =
        Directory('${dir.path}${Platform.pathSeparator}СемейноеМеню');
    if (!await subDir.exists()) await subDir.create(recursive: true);

    final timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath =
        '${subDir.path}${Platform.pathSeparator}семейное_меню_$timestamp.json';
    final file = File(filePath);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
      encoding: utf8,
    );

    return ExportResult(
      filePath: filePath,
      stats: ExportStats(
        recipes: recipes.length,
        pantry: pantry.length,
        categories: categories.length,
        mealPlans: mealPlans.length,
        shoppingLists: shoppingLists.length,
        history: history.length,
      ),
    );
  }

  // ── Serialization helpers ─────────────────────────────────────────────────

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

  Map<String, dynamic> _mealPlanToMap(MealPlansTableData m) => {
        'id': m.id,
        'familyId': m.familyId,
        'planDate': m.planDate,
        'mealType': m.mealType,
        'servings': m.servings,
        'createdAt': m.createdAt,
        'updatedAt': m.updatedAt,
      };

  Map<String, dynamic> _mealPlanSlotToMap(MealPlanRecipesTableData s) => {
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

  Map<String, dynamic> _historyEntryToMap(CookingHistoryTableData h) => {
        'id': h.id,
        'familyId': h.familyId,
        'recipeId': h.recipeId,
        'recipeTitle': h.recipeTitle,
        'servingsCooked': h.servingsCooked,
        'cookedBy': h.cookedBy,
        'cookedAt': h.cookedAt,
        'notes': h.notes,
      };

  Map<String, dynamic> _historyIngToMap(
          CookingHistoryIngredientsTableData i) =>
      {
        'id': i.id,
        'historyId': i.historyId,
        'ingredientName': i.ingredientName,
        'quantityUsed': i.quantityUsed,
        'unit': i.unit,
        'pantryItemId': i.pantryItemId,
      };
}
