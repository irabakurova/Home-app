import '../../../../core/constants/enums.dart';
import '../../../../core/utils/quantity_calculator.dart';

class Ingredient {
  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.category,
    required this.sortOrder,
  });

  final String id;
  final String recipeId;
  final String name;
  final double quantity;
  final MeasurementUnit unit;
  final PantryCategory? category;
  final int sortOrder;

  /// Returns a copy with quantity scaled for [targetServings].
  Ingredient scale(int defaultServings, int targetServings) {
    return copyWith(
      quantity: QuantityCalculator.scale(
        quantity: quantity,
        defaultServings: defaultServings,
        targetServings: targetServings,
      ),
    );
  }

  Ingredient copyWith({
    String? id,
    String? recipeId,
    String? name,
    double? quantity,
    MeasurementUnit? unit,
    Object? category = _sentinel,
    int? sortOrder,
  }) {
    return Ingredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category:
          category == _sentinel ? this.category : category as PantryCategory?,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ingredient && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const _sentinel = Object();
