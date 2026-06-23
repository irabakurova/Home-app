import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/shopping_table.dart';

part 'shopping_dao.g.dart';

@DriftAccessor(tables: [ShoppingListsTable, ShoppingItemsTable])
class ShoppingDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingDaoMixin {
  ShoppingDao(super.db);

  Stream<List<ShoppingListsTableData>> watchAll(String familyId) =>
      (select(shoppingListsTable)
            ..where((t) => t.familyId.equals(familyId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<ShoppingListsTableData?> getById(String id) =>
      (select(shoppingListsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Stream<List<ShoppingItemsTableData>> watchItems(String listId) =>
      (select(shoppingItemsTable)
            ..where((t) => t.shoppingListId.equals(listId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.category),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .watch();

  Future<List<ShoppingItemsTableData>> getItems(String listId) =>
      (select(shoppingItemsTable)
            ..where((t) => t.shoppingListId.equals(listId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.category),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .get();

  Future<int> upsertList(ShoppingListsTableCompanion list) =>
      into(shoppingListsTable).insertOnConflictUpdate(list);

  Future<int> upsertItem(ShoppingItemsTableCompanion item) =>
      into(shoppingItemsTable).insertOnConflictUpdate(item);

  Future<void> toggleItem(String itemId, bool isChecked) =>
      (update(shoppingItemsTable)..where((t) => t.id.equals(itemId))).write(
        ShoppingItemsTableCompanion(isChecked: Value(isChecked)),
      );

  Future<int> deleteList(String id) =>
      (delete(shoppingListsTable)..where((t) => t.id.equals(id))).go();

  Future<int> deleteItem(String id) =>
      (delete(shoppingItemsTable)..where((t) => t.id.equals(id))).go();

  // ── Sync helpers ──────────────────────────────────────────────────────────

  /// Returns all shopping lists for a family — used by sync push.
  Future<List<ShoppingListsTableData>> getAllListsForSync(String familyId) =>
      (select(shoppingListsTable)
            ..where((t) => t.familyId.equals(familyId)))
          .get();

  /// Returns all shopping items for the given list IDs — used by export.
  Future<List<ShoppingItemsTableData>> getAllItemsForSync(
      List<String> listIds) {
    if (listIds.isEmpty) return Future.value([]);
    return (select(shoppingItemsTable)
          ..where((t) => t.shoppingListId.isIn(listIds)))
        .get();
  }
}
