import 'package:drift/drift.dart';

/// Unified table for all user-manageable categories.
/// type: 'recipe' | 'cuisine' | 'pantry'
/// is_system: true = seeded from code, cannot be deleted
/// value: slug used as FK in recipes/pantry (e.g. 'hot_dish', 'custom_uuid')
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get type => text()(); // 'recipe' | 'cuisine' | 'pantry'
  TextColumn get name => text()();
  TextColumn get value => text()(); // slug stored in recipes/pantry
  BoolColumn get isSystem =>
      boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
