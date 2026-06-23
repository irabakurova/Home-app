import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/history_table.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [CookingHistoryTable, CookingHistoryIngredientsTable])
class HistoryDao extends DatabaseAccessor<AppDatabase>
    with _$HistoryDaoMixin {
  HistoryDao(super.db);

  Stream<List<CookingHistoryTableData>> watchAll(String familyId) =>
      (select(cookingHistoryTable)
            ..where((t) => t.familyId.equals(familyId))
            ..orderBy([(t) => OrderingTerm.desc(t.cookedAt)]))
          .watch();

  Future<List<CookingHistoryTableData>> getByRecipe(
          String familyId, String recipeId) =>
      (select(cookingHistoryTable)
            ..where((t) =>
                t.familyId.equals(familyId) & t.recipeId.equals(recipeId))
            ..orderBy([(t) => OrderingTerm.desc(t.cookedAt)]))
          .get();

  Future<List<CookingHistoryIngredientsTableData>> getIngredients(
          String historyId) =>
      (select(cookingHistoryIngredientsTable)
            ..where((t) => t.historyId.equals(historyId)))
          .get();

  Future<int> insertHistory(CookingHistoryTableCompanion entry) =>
      into(cookingHistoryTable).insert(entry);

  Future<int> insertIngredient(
          CookingHistoryIngredientsTableCompanion entry) =>
      into(cookingHistoryIngredientsTable).insert(entry);

  // ── Sync helpers ──────────────────────────────────────────────────────────

  /// Returns all history entries for a family — used by sync push.
  Future<List<CookingHistoryTableData>> getAllForSync(String familyId) =>
      (select(cookingHistoryTable)
            ..where((t) => t.familyId.equals(familyId)))
          .get();

  /// Returns all cooking ingredients for a history entry.
  Future<List<CookingHistoryIngredientsTableData>> getIngredientsForEntry(
          String historyId) =>
      getIngredients(historyId);

  /// Upserts a history entry (insert or update) — used when pulling from Firestore.
  Future<int> upsertEntry(CookingHistoryTableCompanion entry) =>
      into(cookingHistoryTable).insertOnConflictUpdate(entry);

  /// Upserts a history ingredient — used when pulling from Firestore.
  Future<int> upsertHistoryIngredient(
          CookingHistoryIngredientsTableCompanion entry) =>
      into(cookingHistoryIngredientsTable).insertOnConflictUpdate(entry);

  /// Returns all cooking ingredients for the given history entry IDs — used by export.
  Future<List<CookingHistoryIngredientsTableData>> getAllIngredientsForSync(
      List<String> historyIds) {
    if (historyIds.isEmpty) return Future.value([]);
    return (select(cookingHistoryIngredientsTable)
          ..where((t) => t.historyId.isIn(historyIds)))
        .get();
  }

  /// Returns cook count per recipe, ordered by count descending
  Future<List<Map<String, dynamic>>> getPopularRecipes(
      String familyId, int limit) async {
    final query = customSelect(
      'SELECT recipe_id, recipe_title, COUNT(*) as cook_count, '
      'MAX(cooked_at) as last_cooked_at '
      'FROM cooking_history '
      'WHERE family_id = ? '
      'GROUP BY recipe_id '
      'ORDER BY cook_count DESC '
      'LIMIT ?',
      variables: [Variable.withString(familyId), Variable.withInt(limit)],
      readsFrom: {cookingHistoryTable},
    );
    final rows = await query.get();
    return rows
        .map((r) => {
              'recipe_id': r.read<String>('recipe_id'),
              'recipe_title': r.read<String>('recipe_title'),
              'cook_count': r.read<int>('cook_count'),
              'last_cooked_at': r.read<int>('last_cooked_at'),
            })
        .toList();
  }
}
