import 'package:drift/drift.dart';

import 'recipes_table.dart';

class MealPlansTable extends Table {
  @override
  String get tableName => 'meal_plans';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  IntColumn get planDate => integer()();
  TextColumn get mealType => text()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class MealPlanRecipesTable extends Table {
  @override
  String get tableName => 'meal_plan_recipes';

  TextColumn get id => text()();
  TextColumn get mealPlanId =>
      text().references(MealPlansTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get recipeId =>
      text().references(RecipesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
