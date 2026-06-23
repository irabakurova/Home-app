import 'package:drift/drift.dart';

class RecipesTable extends Table {
  @override
  String get tableName => 'recipes';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get category => text()();
  TextColumn get cuisine => text()();
  IntColumn get cookTimeMinutes => integer().withDefault(const Constant(30))();
  IntColumn get defaultServings => integer().withDefault(const Constant(4))();
  TextColumn get instructions => text()(); // JSON array of strings
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class IngredientsTable extends Table {
  @override
  String get tableName => 'ingredients';

  TextColumn get id => text()();
  TextColumn get recipeId =>
      text().references(RecipesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  TextColumn get category => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
