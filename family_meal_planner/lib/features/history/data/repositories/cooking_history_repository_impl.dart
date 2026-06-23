import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/history_dao.dart';
import '../../../../core/database/daos/pantry_dao.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../recipes/domain/entities/ingredient.dart';
import '../../domain/entities/cooking_history_entry.dart';
import '../../domain/repositories/cooking_history_repository.dart';
import '../models/history_mapper.dart';

class CookingHistoryRepositoryImpl implements CookingHistoryRepository {
  CookingHistoryRepositoryImpl(this._historyDao, this._pantryDao);

  final HistoryDao _historyDao;
  final PantryDao _pantryDao;

  // ── Watch ────────────────────────────────────────────────────────────────────

  @override
  Stream<List<CookingHistoryEntry>> watchAll(String familyId) {
    return _historyDao.watchAll(familyId).asyncMap((rows) async {
      final entries = <CookingHistoryEntry>[];
      for (final row in rows) {
        final ingRows = await _historyDao.getIngredients(row.id);
        entries.add(HistoryMapper.fromDb(row, ingRows));
      }
      return entries;
    });
  }

  // ── Fetch ────────────────────────────────────────────────────────────────────

  @override
  Future<List<CookingHistoryEntry>> getByRecipe(
      String familyId, String recipeId) async {
    final rows = await _historyDao.getByRecipe(familyId, recipeId);
    final entries = <CookingHistoryEntry>[];
    for (final row in rows) {
      final ingRows = await _historyDao.getIngredients(row.id);
      entries.add(HistoryMapper.fromDb(row, ingRows));
    }
    return entries;
  }

  // ── Mark cooked ──────────────────────────────────────────────────────────────

  @override
  Future<({CookingHistoryEntry entry, List<DeductionResult> deductions})>
      markCooked({
    required String familyId,
    required String recipeId,
    required String recipeTitle,
    required int servingsCooked,
    required String cookedBy,
    required List<Ingredient> scaledIngredients,
    String? notes,
  }) async {
    final entryId = UuidGenerator.generate();
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;

    // 1. Insert history header
    await _historyDao.insertHistory(
      CookingHistoryTableCompanion(
        id: Value(entryId),
        familyId: Value(familyId),
        recipeId: Value(recipeId),
        recipeTitle: Value(recipeTitle),
        servingsCooked: Value(servingsCooked),
        cookedBy: Value(cookedBy),
        cookedAt: Value(nowMs),
        notes: Value(notes),
      ),
    );

    // 2. Process each ingredient
    final ingredientEntities = <CookingHistoryIngredient>[];
    final deductions = <DeductionResult>[];

    for (final ing in scaledIngredients) {
      // Try to match pantry item by name (case-insensitive) + same unit
      final pantryRow = await _pantryDao.getByNameAndUnit(
          familyId, ing.name, ing.unit.value);

      String? pantryItemId;
      double quantityDeducted = 0;

      if (pantryRow != null) {
        pantryItemId = pantryRow.id;
        quantityDeducted =
            ing.quantity.clamp(0, pantryRow.quantity).toDouble();
        final newQty = (pantryRow.quantity - ing.quantity).clamp(0.0, double.infinity);
        await _pantryDao.updateQuantity(pantryRow.id, newQty, nowMs);
      }

      // Log ingredient usage
      final ingId = UuidGenerator.generate();
      await _historyDao.insertIngredient(
        CookingHistoryIngredientsTableCompanion(
          id: Value(ingId),
          historyId: Value(entryId),
          ingredientName: Value(ing.name),
          quantityUsed: Value(ing.quantity),
          unit: Value(ing.unit.value),
          pantryItemId: Value(pantryItemId),
        ),
      );

      ingredientEntities.add(CookingHistoryIngredient(
        id: ingId,
        historyId: entryId,
        ingredientName: ing.name,
        quantityUsed: ing.quantity,
        unit: ing.unit,
        pantryItemId: pantryItemId,
      ));

      deductions.add(DeductionResult(
        ingredientName: ing.name,
        quantityNeeded: ing.quantity,
        quantityDeducted: quantityDeducted,
        unit: ing.unit,
        pantryItemId: pantryItemId,
      ));
    }

    final entry = CookingHistoryEntry(
      id: entryId,
      familyId: familyId,
      recipeId: recipeId,
      recipeTitle: recipeTitle,
      servingsCooked: servingsCooked,
      cookedBy: cookedBy,
      cookedAt: now,
      notes: notes,
      ingredients: ingredientEntities,
    );

    return (entry: entry, deductions: deductions);
  }

  // ── Statistics ───────────────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getPopularRecipes(
          String familyId, int limit) =>
      _historyDao.getPopularRecipes(familyId, limit);
}
