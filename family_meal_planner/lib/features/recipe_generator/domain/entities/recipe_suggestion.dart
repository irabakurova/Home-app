import '../../../../core/constants/enums.dart';
import '../../../recipes/domain/entities/recipe.dart';

/// One ingredient that is missing from the pantry for a given recipe.
class MissingIngredient {
  const MissingIngredient({
    required this.name,
    required this.quantityNeeded,
    required this.unit,
  });

  final String name;
  final double quantityNeeded;
  final MeasurementUnit unit;
}

/// A recipe with pantry-match metadata, produced by the local suggestion engine.
class RecipeSuggestion {
  const RecipeSuggestion({
    required this.recipe,
    required this.matchPercent,
    required this.available,
    required this.missing,
  });

  final Recipe recipe;

  /// Fraction of ingredients available in the pantry. Range: 0.0–1.0.
  final double matchPercent;

  /// Names of ingredients that are present in the pantry.
  final List<String> available;

  /// Ingredients that are absent or empty in the pantry.
  final List<MissingIngredient> missing;

  bool get isFullyAvailable => matchPercent >= 1.0;
  bool get isNearlyAvailable => matchPercent >= 0.75;
}
