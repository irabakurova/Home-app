import 'package:drift/drift.dart';

class ShoppingListsTable extends Table {
  @override
  String get tableName => 'shopping_lists';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get name => text()();
  IntColumn get dateFrom => integer()();
  IntColumn get dateTo => integer()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingItemsTable extends Table {
  @override
  String get tableName => 'shopping_items';

  TextColumn get id => text()();
  TextColumn get shoppingListId =>
      text().references(ShoppingListsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantityNeeded => real()();
  RealColumn get quantityInPantry =>
      real().withDefault(const Constant(0.0))();
  RealColumn get quantityToBuy => real()();
  TextColumn get unit => text()();
  TextColumn get category => text().nullable()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
