import '../entities/recipe_suggestion.dart';

abstract class RecipeGeneratorRepository {
  /// Returns all recipes sorted by pantry-match percentage (descending).
  /// Only recipes with at least one matching ingredient are included.
  Future<List<RecipeSuggestion>> getSuggestions(String familyId);
}
