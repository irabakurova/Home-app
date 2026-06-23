import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pantry_table.dart';

part 'pantry_dao.g.dart';

@DriftAccessor(tables: [PantryItemsTable])
class PantryDao extends DatabaseAccessor<AppDatabase>
    with _$PantryDaoMixin {
  PantryDao(super.db);

  Stream<List<PantryItemsTableData>> watchAll(String familyId) =>
      (select(pantryItemsTable)
            ..where((t) => t.familyId.equals(familyId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.category),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .watch();

  Future<PantryItemsTableData?> getById(String id) =>
      (select(pantryItemsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<PantryItemsTableData?> getByName(String familyId, String name) =>
      (select(pantryItemsTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.name.lower().equals(name.toLowerCase())))
          .getSingleOrNull();

  /// Finds by name (case-insensitive) AND matching unit value.
  /// Used for precise pantry deduction after cooking.
  Future<PantryItemsTableData?> getByNameAndUnit(
          String familyId, String name, String unit) =>
      (select(pantryItemsTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.name.lower().equals(name.toLowerCase()) &
                t.unit.equals(unit)))
          .getSingleOrNull();

  Future<List<PantryItemsTableData>> getAll(String familyId) =>
      (select(pantryItemsTable)
            ..where((t) => t.familyId.equals(familyId)))
          .get();

  Future<int> upsert(PantryItemsTableCompanion item) =>
      into(pantryItemsTable).insertOnConflictUpdate(item);

  Future<int> deleteById(String id) =>
      (delete(pantryItemsTable)..where((t) => t.id.equals(id))).go();

  /// Quick quantity update — used for inline editing and post-cooking deduction
  Future<void> updateQuantity(String id, double quantity, int updatedAt) =>
      (update(pantryItemsTable)..where((t) => t.id.equals(id))).write(
        PantryItemsTableCompanion(
          quantity: Value(quantity),
          updatedAt: Value(updatedAt),
        ),
      );

  /// Zero out a spoiled item
  Future<void> zeroOut(String id, int updatedAt) =>
      updateQuantity(id, 0, updatedAt);

  Future<List<PantryItemsTableData>> search(String familyId, String query) =>
      (select(pantryItemsTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.name.lower().contains(query.toLowerCase())))
          .get();

  Stream<List<PantryItemsTableData>> watchLowStock(String familyId) =>
      (select(pantryItemsTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.quantity.isSmallerOrEqualValue(0)))
          .watch();
}
