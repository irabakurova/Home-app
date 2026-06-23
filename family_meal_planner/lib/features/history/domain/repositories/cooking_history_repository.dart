import '../../../recipes/domain/entities/ingredient.dart';
import '../entities/cooking_history_entry.dart';

abstract class CookingHistoryRepository {
  /// All cooking sessions, newest first.
  Stream<List<CookingHistoryEntry>> watchAll(String familyId);

  /// Sessions for a specific recipe, newest first.
  Future<List<CookingHistoryEntry>> getByRecipe(
      String familyId, String recipeId);

  /// Records a cooked dish:
  /// 1. Inserts a [CookingHistoryEntry] row.
  /// 2. For each ingredient in [scaledIngredients], tries to find a matching
  ///    pantry item (name case-insensitive + same unit) and deducts the
  ///    quantity (clamped at 0).
  /// 3. Returns the saved entry together with per-ingredient [DeductionResult]s
  ///    so the UI can warn the user about items not in pantry.
  Future<({CookingHistoryEntry entry, List<DeductionResult> deductions})>
      markCooked({
    required String familyId,
    required String recipeId,
    required String recipeTitle,
    required int servingsCooked,
    required String cookedBy,

    /// Already scaled to [servingsCooked].
    required List<Ingredient> scaledIngredients,
    String? notes,
  });

  /// Aggregated stats: recipe_id, recipe_title, cook_count, last_cooked_at.
  Future<List<Map<String, dynamic>>> getPopularRecipes(
      String familyId, int limit);
}
