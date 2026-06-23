import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/recipes_table.dart';

part 'recipes_dao.g.dart';

@DriftAccessor(tables: [RecipesTable, IngredientsTable])
class RecipesDao extends DatabaseAccessor<AppDatabase>
    with _$RecipesDaoMixin {
  RecipesDao(super.db);

  // ── Recipes ───────────────────────────────────────────────────────────────

  Stream<List<RecipesTableData>> watchAll(String familyId) =>
      (select(recipesTable)
            ..where((t) => t.familyId.equals(familyId))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Stream<List<RecipesTableData>> watchFavorites(String familyId) =>
      (select(recipesTable)
            ..where((t) =>
                t.familyId.equals(familyId) & t.isFavorite.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<RecipesTableData?> getById(String id) =>
      (select(recipesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<RecipesTableData>> search(String familyId, String query) =>
      (select(recipesTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.title.lower().contains(query.toLowerCase())))
          .get();

  Future<List<RecipesTableData>> filterByCategory(
          String familyId, String category) =>
      (select(recipesTable)
            ..where((t) =>
                t.familyId.equals(familyId) & t.category.equals(category)))
          .get();

  Future<int> upsert(RecipesTableCompanion recipe) =>
      into(recipesTable).insertOnConflictUpdate(recipe);

  Future<int> deleteById(String id) =>
      (delete(recipesTable)..where((t) => t.id.equals(id))).go();

  Future<void> toggleFavorite(String id, bool isFavorite) =>
      (update(recipesTable)..where((t) => t.id.equals(id))).write(
        RecipesTableCompanion(isFavorite: Value(isFavorite)),
      );

  // ── Ingredients ───────────────────────────────────────────────────────────

  Stream<List<IngredientsTableData>> watchByRecipe(String recipeId) =>
      (select(ingredientsTable)
            ..where((t) => t.recipeId.equals(recipeId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<IngredientsTableData>> getByRecipe(String recipeId) =>
      (select(ingredientsTable)
            ..where((t) => t.recipeId.equals(recipeId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> upsertIngredient(IngredientsTableCompanion ingredient) =>
      into(ingredientsTable).insertOnConflictUpdate(ingredient);

  Future<void> replaceIngredients(
      String recipeId, List<IngredientsTableCompanion> ingredients) async {
    await transaction(() async {
      await (delete(ingredientsTable)
            ..where((t) => t.recipeId.equals(recipeId)))
          .go();
      for (final ing in ingredients) {
        await into(ingredientsTable).insert(ing);
      }
    });
  }

  Future<int> deleteIngredient(String id) =>
      (delete(ingredientsTable)..where((t) => t.id.equals(id))).go();

  // ── Sync helpers ──────────────────────────────────────────────────────────

  /// Returns all recipes for a family — used by sync push.
  Future<List<RecipesTableData>> getAllForSync(String familyId) =>
      (select(recipesTable)..where((t) => t.familyId.equals(familyId))).get();

  /// Returns all ingredients whose parent recipe belongs to [familyId].
  Future<List<IngredientsTableData>> getAllIngredientsForSync(
      String familyId) async {
    final recipes = await getAllForSync(familyId);
    if (recipes.isEmpty) return [];
    final ids = recipes.map((r) => r.id).toList();
    return (select(ingredientsTable)
          ..where((t) => t.recipeId.isIn(ids)))
        .get();
  }
}
