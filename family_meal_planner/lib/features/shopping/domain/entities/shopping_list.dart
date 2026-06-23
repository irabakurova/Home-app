import '../../../../core/constants/enums.dart';

// ── ShoppingList (header + items) ─────────────────────────────────────────────

class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.familyId,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.isCompleted,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String familyId;
  final String name;
  final DateTime dateFrom;
  final DateTime dateTo;
  final bool isCompleted;
  final DateTime createdAt;
  final List<ShoppingItem> items;

  int get totalCount => items.length;
  int get checkedCount => items.where((i) => i.isChecked).length;

  /// Items that need to be bought (quantityToBuy > 0, or added manually).
  List<ShoppingItem> get toBuyItems =>
      items.where((i) => i.quantityToBuy > 0 || i.isManual).toList();

  /// Items already covered by pantry stock.
  List<ShoppingItem> get coveredItems =>
      items.where((i) => i.quantityToBuy <= 0 && !i.isManual).toList();

  /// [toBuyItems] grouped by category label (for section headers in the list).
  Map<String, List<ShoppingItem>> get itemsByCategory {
    final map = <String, List<ShoppingItem>>{};
    for (final item in toBuyItems) {
      final cat = item.category?.label ?? 'Прочее';
      (map[cat] ??= []).add(item);
    }
    // Sort keys alphabetically for stable ordering
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ShoppingList && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// ── ShoppingItem ──────────────────────────────────────────────────────────────

class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.quantityNeeded,
    required this.quantityInPantry,
    required this.quantityToBuy,
    required this.unit,
    this.category,
    required this.isChecked,
    required this.isManual,
  });

  final String id;
  final String shoppingListId;
  final String name;

  /// Total needed (after summing all meal plan recipes and scaling by servings).
  final double quantityNeeded;

  /// How much is already in pantry (exact name + unit match).
  final double quantityInPantry;

  /// max(0, quantityNeeded − quantityInPantry) — what actually needs buying.
  final double quantityToBuy;

  final MeasurementUnit unit;
  final PantryCategory? category;
  final bool isChecked;

  /// True for items added manually by the user (not generated from meal plan).
  final bool isManual;

  ShoppingItem copyWith({bool? isChecked}) => ShoppingItem(
        id: id,
        shoppingListId: shoppingListId,
        name: name,
        quantityNeeded: quantityNeeded,
        quantityInPantry: quantityInPantry,
        quantityToBuy: quantityToBuy,
        unit: unit,
        category: category,
        isChecked: isChecked ?? this.isChecked,
        isManual: isManual,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ShoppingItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
