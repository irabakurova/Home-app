/// Domain entity for a pantry (storage) item.
/// [category] is a value slug matching CategoriesTable.value for type='pantry'.
class PantryItem {
  const PantryItem({
    required this.id,
    required this.familyId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.minQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String familyId;
  final String name;
  final double quantity;
  final String unit;

  /// Value slug — matches CategoriesTable.value for type='pantry'
  final String category;

  /// If > 0 and quantity ≤ minQuantity, item is flagged as low stock.
  final double minQuantity;

  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isLowStock => minQuantity > 0 && quantity <= minQuantity;
  bool get isEmpty => quantity <= 0;

  PantryItem copyWith({
    String? id,
    String? familyId,
    String? name,
    double? quantity,
    String? unit,
    String? category,
    double? minQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PantryItem(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      minQuantity: minQuantity ?? this.minQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PantryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PantryItem($name, qty: $quantity $unit)';
}
