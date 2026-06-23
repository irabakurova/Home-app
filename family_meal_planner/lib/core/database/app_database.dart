import 'package:drift/drift.dart';

import 'connection.dart';

import 'daos/categories_dao.dart';
import 'daos/history_dao.dart';
import 'daos/meal_plan_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/recipes_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/shopping_dao.dart';
import 'tables/categories_table.dart';
import 'tables/history_table.dart';
import 'tables/meal_plan_table.dart';
import 'tables/pantry_table.dart';
import 'tables/recipes_table.dart';
import 'tables/shopping_table.dart';
import 'tables/sync_table.dart';

part 'app_database.g.dart';

// ── System category seeds ─────────────────────────────────────────────────────

const _kDefaultFamily = 'default_family';

const _recipeCategories = [
  ('hot_dish',   'Горячее',    0),
  ('soup',       'Суп',        1),
  ('salad',      'Салат',      2),
  ('side',       'Гарнир',     3),
  ('baking',     'Выпечка',    4),
  ('dessert',    'Десерт',     5),
  ('breakfast',  'Завтрак',    6),
  ('appetizer',  'Закуска',    7),
  ('drink',      'Напиток',    8),
  ('other_rc',   'Другое',     9),
];

const _cuisines = [
  ('russian',   'Русская',       0),
  ('european',  'Европейская',   1),
  ('asian',     'Азиатская',     2),
  ('italian',   'Итальянская',   3),
  ('french',    'Французская',   4),
  ('american',  'Американская',  5),
  ('eastern',   'Восточная',     6),
  ('other_cu',  'Другое',        7),
];

const _pantryCategories = [
  ('vegetables', 'Овощи',       0),
  ('fruits',     'Фрукты',      1),
  ('meat',       'Мясо',        2),
  ('fish',       'Рыба',        3),
  ('dairy',      'Молочные',    4),
  ('grains',     'Крупы',       5),
  ('pasta',      'Макароны',    6),
  ('spices',     'Специи',      7),
  ('baking',     'Выпечка',     8),
  ('frozen',     'Заморозка',   9),
  ('drinks',     'Напитки',    10),
  ('canned',     'Консервы',   11),
  ('other_pa',   'Прочее',     12),
];

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    RecipesTable,
    IngredientsTable,
    PantryItemsTable,
    MealPlansTable,
    MealPlanRecipesTable,
    ShoppingListsTable,
    ShoppingItemsTable,
    CookingHistoryTable,
    CookingHistoryIngredientsTable,
    SyncQueueTable,
    AppSettingsTable,
    CategoriesTable,
  ],
  daos: [
    RecipesDao,
    PantryDao,
    MealPlanDao,
    ShoppingDao,
    HistoryDao,
    SettingsDao,
    CategoriesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDatabaseConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(categoriesTable);
          }
          if (from < 3) {
            // Bug #77 fix: remove duplicated system categories (caused by
            // random UUID generation on each seed call) and re-seed with
            // stable, deterministic IDs so insertOnConflictUpdate works.
            await customStatement(
                'DELETE FROM categories WHERE is_system = 1');
            await _seedCategories();
          }
        },
      );

  /// Seeds system categories using **stable, deterministic IDs**
  /// (`sys_<type>_<value>`) so that `insertOnConflictUpdate` correctly
  /// detects conflicts and never creates duplicates.
  Future<void> _seedCategories() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    Future<void> seed(
      String type,
      List<(String, String, int)> entries,
    ) async {
      for (final (value, name, order) in entries) {
        // Stable ID = deterministic per (type, value) — no random UUIDs.
        final stableId = 'sys_${type}_$value';
        await into(categoriesTable).insertOnConflictUpdate(
          CategoriesTableCompanion(
            id: Value(stableId),
            familyId: const Value(_kDefaultFamily),
            type: Value(type),
            name: Value(name),
            value: Value(value),
            isSystem: const Value(true),
            sortOrder: Value(order),
            createdAt: Value(now),
          ),
        );
      }
    }

    await seed('recipe',  _recipeCategories);
    await seed('cuisine', _cuisines);
    await seed('pantry',  _pantryCategories);
  }
}

