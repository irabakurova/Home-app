import '../../../../core/constants/enums.dart';
import '../../../recipes/domain/entities/recipe.dart';

/// One slot in the meal plan: a specific date + meal type + list of recipes.
/// Corresponds to one row in [MealPlansTable] with its joined [MealPlanRecipesTable] rows.
class MealPlanEntry {
  const MealPlanEntry({
    required this.id,
    required this.familyId,
    required this.date,
    required this.mealType,
    required this.servings,
    required this.recipes,
  });

  final String id;
  final String familyId;

  /// Date at midnight (no time component).
  final DateTime date;

  final MealType mealType;

  /// Default serving count used when generating the shopping list.
  final int servings;

  /// Recipes assigned to this slot, in sortOrder order.
  final List<Recipe> recipes;

  bool get isEmpty => recipes.isEmpty;

  MealPlanEntry copyWith({
    String? id,
    String? familyId,
    DateTime? date,
    MealType? mealType,
    int? servings,
    List<Recipe>? recipes,
  }) {
    return MealPlanEntry(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      servings: servings ?? this.servings,
      recipes: recipes ?? this.recipes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MealPlanEntry && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// All meal plan entries grouped under a single calendar date.
class MealPlanDay {
  const MealPlanDay({required this.date, required this.entries});

  final DateTime date;

  /// Entries for this day, one per MealType (may be absent if no recipes added).
  final List<MealPlanEntry> entries;

  /// Returns the entry for a given [mealType], or null if none exists yet.
  MealPlanEntry? entryFor(MealType mealType) =>
      entries.where((e) => e.mealType == mealType).firstOrNull;

  bool get isEmpty => entries.every((e) => e.isEmpty);
}
