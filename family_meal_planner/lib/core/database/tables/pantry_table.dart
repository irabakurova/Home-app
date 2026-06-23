import 'package:drift/drift.dart';

class PantryItemsTable extends Table {
  @override
  String get tableName => 'pantry_items';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get name => text()();
  RealColumn get quantity => real().withDefault(const Constant(0.0))();
  TextColumn get unit => text()();
  TextColumn get category => text()();
  RealColumn get minQuantity => real().withDefault(const Constant(0.0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
