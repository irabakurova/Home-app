import '../../../../core/constants/enums.dart';

/// A single ingredient that was consumed when a dish was cooked.
class CookingHistoryIngredient {
  const CookingHistoryIngredient({
    required this.id,
    required this.historyId,
    required this.ingredientName,
    required this.quantityUsed,
    required this.unit,
    this.pantryItemId,
  });

  final String id;
  final String historyId;
  final String ingredientName;
  final double quantityUsed;
  final MeasurementUnit unit;

  /// Non-null if the ingredient was deducted from a known pantry item.
  final String? pantryItemId;
}

/// One record in the cooking history log.
class CookingHistoryEntry {
  const CookingHistoryEntry({
    required this.id,
    required this.familyId,
    required this.recipeId,
    required this.recipeTitle,
    required this.servingsCooked,
    required this.cookedBy,
    required this.cookedAt,
    this.notes,
    this.ingredients = const [],
  });

  final String id;
  final String familyId;
  final String recipeId;
  final String recipeTitle;
  final int servingsCooked;
  final String cookedBy;
  final DateTime cookedAt;
  final String? notes;
  final List<CookingHistoryIngredient> ingredients;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CookingHistoryEntry && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CookingHistoryEntry($recipeTitle, $servingsCooked порц., $cookedAt)';
}

/// Result of a deduction attempt for a single ingredient.
class DeductionResult {
  const DeductionResult({
    required this.ingredientName,
    required this.quantityNeeded,
    required this.quantityDeducted,
    required this.unit,
    required this.pantryItemId,
  });

  final String ingredientName;
  final double quantityNeeded;
  final double quantityDeducted;
  final MeasurementUnit unit;

  /// Null means no matching pantry item was found.
  final String? pantryItemId;

  bool get wasFullyDeducted => quantityDeducted >= quantityNeeded;
  bool get notInPantry => pantryItemId == null;
}
