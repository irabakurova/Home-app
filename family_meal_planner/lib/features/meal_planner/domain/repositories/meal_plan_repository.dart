import '../../../../core/constants/enums.dart';
import '../entities/meal_plan_entry.dart';

abstract class MealPlanRepository {
  /// Reactive stream of all entries in the [start]..[end] date range.
  /// Re-emits whenever plans or their recipes change.
  Stream<List<MealPlanEntry>> watchRange(
      String familyId, DateTime start, DateTime end);

  /// One-shot fetch for the same range (used for shopping list generation).
  Future<List<MealPlanEntry>> getRange(
      String familyId, DateTime start, DateTime end);

  /// Adds [recipeId] to the slot identified by ([familyId], [date], [mealType]).
  /// Creates the slot if it doesn't exist yet.
  Future<void> addRecipeToSlot({
    required String familyId,
    required DateTime date,
    required MealType mealType,
    required String recipeId,
    int servings = 4,
  });

  /// Removes one recipe entry from a plan slot by its join-table row id.
  Future<void> removeRecipeFromSlot(String mealPlanRecipeId);

  /// Deletes an entire slot (all recipes for that date + meal type).
  Future<void> removeSlot(String mealPlanId);
}
