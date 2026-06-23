import '../../../../core/database/daos/recipes_dao.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../models/recipe_mapper.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._dao);

  final RecipesDao _dao;

  @override
  Stream<List<Recipe>> watchAll(String familyId) {
    return _dao
        .watchAll(familyId)
        .map((rows) => rows.map(RecipeMapper.fromDb).toList());
  }

  @override
  Stream<List<Recipe>> watchFavorites(String familyId) {
    return _dao
        .watchFavorites(familyId)
        .map((rows) => rows.map(RecipeMapper.fromDb).toList());
  }

  @override
  Future<Recipe?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : RecipeMapper.fromDb(row);
  }

  @override
  Future<List<Recipe>> search(String familyId, String query) async {
    final rows = await _dao.search(familyId, query);
    return rows.map(RecipeMapper.fromDb).toList();
  }

  @override
  Future<List<Recipe>> filterByCategory(
      String familyId, String categoryValue) async {
    final rows = await _dao.filterByCategory(familyId, categoryValue);
    return rows.map(RecipeMapper.fromDb).toList();
  }

  @override
  Stream<List<Ingredient>> watchIngredients(String recipeId) {
    return _dao
        .watchByRecipe(recipeId)
        .map((rows) => rows.map(RecipeMapper.ingredientFromDb).toList());
  }

  @override
  Future<List<Ingredient>> getIngredients(String recipeId) async {
    final rows = await _dao.getByRecipe(recipeId);
    return rows.map(RecipeMapper.ingredientFromDb).toList();
  }

  @override
  Future<void> save(Recipe recipe, List<Ingredient> ingredients) async {
    await _dao.upsert(RecipeMapper.toDb(recipe));
    await _dao.replaceIngredients(
      recipe.id,
      ingredients.map(RecipeMapper.ingredientToDb).toList(),
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteById(id);

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) =>
      _dao.toggleFavorite(id, isFavorite);
}
