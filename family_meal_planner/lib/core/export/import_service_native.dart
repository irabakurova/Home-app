import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';

import '../database/app_database.dart';
import '../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;

// ── Import result ─────────────────────────────────────────────────────────────

class ImportResult {
  const ImportResult({
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

class ImportService {
  const ImportService();

  /// Opens a file picker, reads the selected JSON backup, and upserts all
  /// records into the local DB.  Returns null if the user cancels.
  Future<ImportResult?> importFromFile(AppDatabase db) async {
    // ── Pick file ──────────────────────────────────────────────────────────
    final pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Выберите файл резервной копии',
    );

    if (pickerResult == null || pickerResult.files.isEmpty) return null;

    final path = pickerResult.files.first.path;
    if (path == null) throw Exception('Не удалось получить путь к файлу');

    // ── Read & parse ──────────────────────────────────────────────────────
    final content = await File(path).readAsString(encoding: utf8);
    final data = jsonDecode(content);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Неверный формат файла');
    }

    final version = data['version'];
    if (version != 1) {
      throw Exception('Неподдерживаемая версия бэкапа: $version');
    }

    const familyId = kDefaultFamilyId;

    // ── Upsert all entities respecting FK order ───────────────────────────

    // 1. Categories (no FK deps)
    final categories =
        _list(data['categories']).map((m) => _mapToCategory(m, familyId));
    for (final c in categories) {
      await db.categoriesDao.upsert(c);
    }

    // 2. Recipes (no FK deps on other tables)
    final recipes =
        _list(data['recipes']).map((m) => _mapToRecipe(m, familyId));
    for (final r in recipes) {
      await db.recipesDao.upsert(r);
    }

    // 3. Recipe ingredients (FK → recipes)
    final ingredients =
        _list(data['recipeIngredients']).map(_mapToIngredient);
    for (final i in ingredients) {
      await db.recipesDao.upsertIngredient(i);
    }

    // 4. Pantry (no FK deps)
    final pantry =
        _list(data['pantry']).map((m) => _mapToPantry(m, familyId));
    for (final p in pantry) {
      await db.pantryDao.upsert(p);
    }

    // 5. Meal plans (FK → recipes via slots)
    final mealPlans =
        _list(data['mealPlans']).map((m) => _mapToMealPlan(m, familyId));
    for (final mp in mealPlans) {
      await db.mealPlanDao.upsertPlan(mp);
    }

    // 6. Meal plan slots (FK → meal_plans + recipes)
    final mealPlanSlots = _list(data['mealPlanSlots']).map(_mapToMealPlanSlot);
    for (final s in mealPlanSlots) {
      await db.mealPlanDao.addRecipeToPlan(s);
    }

    // 7. Shopping lists
    final shoppingLists =
        _list(data['shoppingLists']).map((m) => _mapToShoppingList(m, familyId));
    for (final sl in shoppingLists) {
      await db.shoppingDao.upsertList(sl);
    }

    // 8. Shopping items (FK → shopping_lists)
    final shoppingItems = _list(data['shoppingItems']).map(_mapToShoppingItem);
    for (final si in shoppingItems) {
      await db.shoppingDao.upsertItem(si);
    }

    // 9. Cooking history (FK → recipes)
    final history =
        _list(data['cookingHistory']).map((m) => _mapToHistoryEntry(m, familyId));
    for (final h in history) {
      await db.historyDao.upsertEntry(h);
    }

    // 10. History ingredients (FK → cooking_history)
    final historyIngredients =
        _list(data['cookingHistoryIngredients']).map(_mapToHistoryIng);
    for (final hi in historyIngredients) {
      await db.historyDao.upsertHistoryIngredient(hi);
    }

    return ImportResult(
      recipes: _list(data['recipes']).length,
      pantry: _list(data['pantry']).length,
      categories: _list(data['categories']).length,
      mealPlans: _list(data['mealPlans']).length,
      shoppingLists: _list(data['shoppingLists']).length,
      history: _list(data['cookingHistory']).length,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _list(dynamic raw) {
    if (raw == null) return [];
    return (raw as List).cast<Map<String, dynamic>>();
  }

  // ── Deserialization helpers ───────────────────────────────────────────────

  RecipesTableCompanion _mapToRecipe(Map<String, dynamic> m, String familyId) =>
      RecipesTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        title: Value(m['title'] as String),
        description: Value(m['description'] as String?),
        photoUrl: Value(m['photoUrl'] as String?),
        category: Value(m['category'] as String),
        cuisine: Value(m['cuisine'] as String),
        cookTimeMinutes: Value(m['cookTimeMinutes'] as int),
        defaultServings: Value(m['defaultServings'] as int),
        instructions: Value(m['instructions'] as String),
        isFavorite: Value(m['isFavorite'] as bool? ?? false),
        createdBy: Value(m['createdBy'] as String),
        createdAt: Value(m['createdAt'] as int),
        updatedAt: Value(m['updatedAt'] as int),
      );

  IngredientsTableCompanion _mapToIngredient(Map<String, dynamic> m) =>
      IngredientsTableCompanion(
        id: Value(m['id'] as String),
        recipeId: Value(m['recipeId'] as String),
        name: Value(m['name'] as String),
        quantity: Value((m['quantity'] as num).toDouble()),
        unit: Value(m['unit'] as String),
        category: Value(m['category'] as String?),
        sortOrder: Value(m['sortOrder'] as int? ?? 0),
      );

  PantryItemsTableCompanion _mapToPantry(
          Map<String, dynamic> m, String familyId) =>
      PantryItemsTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        name: Value(m['name'] as String),
        quantity: Value((m['quantity'] as num).toDouble()),
        unit: Value(m['unit'] as String),
        category: Value(m['category'] as String),
        minQuantity: Value((m['minQuantity'] as num? ?? 0).toDouble()),
        createdAt: Value(m['createdAt'] as int),
        updatedAt: Value(m['updatedAt'] as int),
      );

  CategoriesTableCompanion _mapToCategory(
          Map<String, dynamic> m, String familyId) =>
      CategoriesTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        type: Value(m['type'] as String),
        name: Value(m['name'] as String),
        value: Value(m['value'] as String),
        isSystem: Value(m['isSystem'] as bool? ?? false),
        sortOrder: Value(m['sortOrder'] as int? ?? 0),
        createdAt: Value(m['createdAt'] as int),
      );

  MealPlansTableCompanion _mapToMealPlan(
          Map<String, dynamic> m, String familyId) =>
      MealPlansTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        planDate: Value(m['planDate'] as int),
        mealType: Value(m['mealType'] as String),
        servings: Value(m['servings'] as int? ?? 4),
        createdAt: Value(m['createdAt'] as int),
        updatedAt: Value(m['updatedAt'] as int),
      );

  MealPlanRecipesTableCompanion _mapToMealPlanSlot(Map<String, dynamic> m) =>
      MealPlanRecipesTableCompanion(
        id: Value(m['id'] as String),
        mealPlanId: Value(m['mealPlanId'] as String),
        recipeId: Value(m['recipeId'] as String),
        sortOrder: Value(m['sortOrder'] as int? ?? 0),
      );

  ShoppingListsTableCompanion _mapToShoppingList(
          Map<String, dynamic> m, String familyId) =>
      ShoppingListsTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        name: Value(m['name'] as String),
        dateFrom: Value(m['dateFrom'] as int),
        dateTo: Value(m['dateTo'] as int),
        isCompleted: Value(m['isCompleted'] as bool? ?? false),
        createdAt: Value(m['createdAt'] as int),
        updatedAt: Value(m['updatedAt'] as int),
      );

  ShoppingItemsTableCompanion _mapToShoppingItem(Map<String, dynamic> m) =>
      ShoppingItemsTableCompanion(
        id: Value(m['id'] as String),
        shoppingListId: Value(m['shoppingListId'] as String),
        name: Value(m['name'] as String),
        quantityNeeded: Value((m['quantityNeeded'] as num).toDouble()),
        quantityInPantry:
            Value((m['quantityInPantry'] as num? ?? 0).toDouble()),
        quantityToBuy: Value((m['quantityToBuy'] as num).toDouble()),
        unit: Value(m['unit'] as String),
        category: Value(m['category'] as String?),
        isChecked: Value(m['isChecked'] as bool? ?? false),
        isManual: Value(m['isManual'] as bool? ?? false),
      );

  CookingHistoryTableCompanion _mapToHistoryEntry(
          Map<String, dynamic> m, String familyId) =>
      CookingHistoryTableCompanion(
        id: Value(m['id'] as String),
        familyId: Value(familyId),
        recipeId: Value(m['recipeId'] as String),
        recipeTitle: Value(m['recipeTitle'] as String),
        servingsCooked: Value(m['servingsCooked'] as int),
        cookedBy: Value(m['cookedBy'] as String),
        cookedAt: Value(m['cookedAt'] as int),
        notes: Value(m['notes'] as String?),
      );

  CookingHistoryIngredientsTableCompanion _mapToHistoryIng(
          Map<String, dynamic> m) =>
      CookingHistoryIngredientsTableCompanion(
        id: Value(m['id'] as String),
        historyId: Value(m['historyId'] as String),
        ingredientName: Value(m['ingredientName'] as String),
        quantityUsed: Value((m['quantityUsed'] as num).toDouble()),
        unit: Value(m['unit'] as String),
        pantryItemId: Value(m['pantryItemId'] as String?),
      );
}
