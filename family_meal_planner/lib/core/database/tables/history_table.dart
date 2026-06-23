import 'package:drift/drift.dart';

import 'recipes_table.dart';
import 'pantry_table.dart';

class CookingHistoryTable extends Table {
  @override
  String get tableName => 'cooking_history';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get recipeId =>
      text().references(RecipesTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get recipeTitle => text()();
  IntColumn get servingsCooked => integer()();
  TextColumn get cookedBy => text()();
  IntColumn get cookedAt => integer()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CookingHistoryIngredientsTable extends Table {
  @override
  String get tableName => 'cooking_history_ingredients';

  TextColumn get id => text()();
  TextColumn get historyId => text().references(CookingHistoryTable, #id,
      onDelete: KeyAction.cascade)();
  TextColumn get ingredientName => text()();
  RealColumn get quantityUsed => real()();
  TextColumn get unit => text()();
  TextColumn get pantryItemId =>
      text().nullable().references(PantryItemsTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
