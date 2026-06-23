import '../entities/ingredient.dart';
import '../entities/recipe.dart';

abstract class RecipeRepository {
  /// Stream of all recipes for a family, sorted by updatedAt desc.
  Stream<List<Recipe>> watchAll(String familyId);

  /// Stream of favorite recipes.
  Stream<List<Recipe>> watchFavorites(String familyId);

  /// Get a single recipe by id, or null if not found.
  Future<Recipe?> getById(String id);

  /// Full-text search in recipe titles.
  Future<List<Recipe>> search(String familyId, String query);

  /// Filter by category value slug (e.g. 'hot_dish', 'soup').
  Future<List<Recipe>> filterByCategory(
      String familyId, String categoryValue);

  /// Stream of ingredients for a recipe.
  Stream<List<Ingredient>> watchIngredients(String recipeId);

  /// Load ingredients once.
  Future<List<Ingredient>> getIngredients(String recipeId);

  /// Save (insert or update) a recipe along with its ingredients.
  Future<void> save(Recipe recipe, List<Ingredient> ingredients);

  /// Delete a recipe (ingredients cascade).
  Future<void> delete(String id);

  /// Toggle the favourite flag.
  Future<void> toggleFavorite(String id, bool isFavorite);
}
