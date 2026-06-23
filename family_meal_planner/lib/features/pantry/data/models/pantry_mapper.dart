import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/pantry_item.dart';

class PantryMapper {
  PantryMapper._();

  static PantryItem fromDb(PantryItemsTableData data) {
    return PantryItem(
      id: data.id,
      familyId: data.familyId,
      name: data.name,
      quantity: data.quantity,
      unit: data.unit,
      category: data.category, // String slug, no enum conversion
      minQuantity: data.minQuantity,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }

  static PantryItemsTableCompanion toDb(PantryItem item) {
    return PantryItemsTableCompanion(
      id: Value(item.id),
      familyId: Value(item.familyId),
      name: Value(item.name),
      quantity: Value(item.quantity),
      unit: Value(item.unit),
      category: Value(item.category),
      minQuantity: Value(item.minQuantity),
      createdAt: Value(item.createdAt.millisecondsSinceEpoch),
      updatedAt: Value(item.updatedAt.millisecondsSinceEpoch),
    );
  }
}
