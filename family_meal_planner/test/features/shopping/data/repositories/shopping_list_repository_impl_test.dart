import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:easily_kitchen/core/constants/enums.dart';
import 'package:easily_kitchen/core/database/app_database.dart';
import 'package:easily_kitchen/features/meal_planner/domain/entities/meal_plan_entry.dart';
import 'package:easily_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:easily_kitchen/features/shopping/data/repositories/shopping_list_repository_impl.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late ShoppingListRepositoryImpl repo;
  late MockShoppingDao mockShoppingDao;
  late MockMealPlanRepository mockMealPlanRepo;
  late MockRecipesDao mockRecipesDao;
  late MockPantryDao mockPantryDao;

  setUp(() {
    mockShoppingDao = MockShoppingDao();
    mockMealPlanRepo = MockMealPlanRepository();
    mockRecipesDao = MockRecipesDao();
    mockPantryDao = MockPantryDao();
    repo = ShoppingListRepositoryImpl(
      mockShoppingDao,
      mockMealPlanRepo,
      mockRecipesDao,
      mockPantryDao,
    );
  });

  Recipe _recipe({
    required String id,
    required String title,
    int defaultServings = 4,
    String category = 'hot_dish',
  }) {
    return Recipe(
      id: id,
      familyId: 'f1',
      title: title,
      category: category,
      cuisine: 'russian',
      cookTimeMinutes: 30,
      defaultServings: defaultServings,
      instructions: const ['Step 1'],
      isFavorite: false,
      createdBy: 'user1',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  MealPlanEntry _entry({
    required String id,
    required List<Recipe> recipes,
    int servings = 4,
    MealType mealType = MealType.lunch,
  }) {
    return MealPlanEntry(
      id: id,
      familyId: 'f1',
      date: DateTime(2026, 6, 23),
      mealType: mealType,
      servings: servings,
      recipes: recipes,
    );
  }

  group('generateFromMealPlan', () {
    ShoppingListsTableData _fakeListRow(String id) {
      return ShoppingListsTableData(
        id: id,
        familyId: 'f1',
        name: 'Test List',
        dateFrom: DateTime(2026, 6, 23).millisecondsSinceEpoch,
        dateTo: DateTime(2026, 6, 23).millisecondsSinceEpoch,
        isCompleted: false,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }

    test('generates list from single recipe with one ingredient', () async {
      final recipe = _recipe(id: 'r1', title: 'Омлет');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      // Recipe has 3 eggs for 4 servings
      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Яйца',
              quantity: 3,
              unit: 'pcs',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      // Capture what gets inserted
      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'name': inv.positionalArguments[0].name.value,
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
          'unit': inv.positionalArguments[0].unit.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems.length, 1);
      expect(insertedItems[0]['name'], 'Яйца');
      // 3 eggs for 4 servings, planning for 4 servings → no scaling
      expect(insertedItems[0]['quantityNeeded'], 3.0);
      expect(insertedItems[0]['quantityToBuy'], 3.0);
    });

    test('scales ingredients when servings differ from default', () async {
      final recipe = _recipe(id: 'r1', title: 'Суп', defaultServings: 4);
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 8);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Картофель',
              quantity: 400,
              unit: 'g',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'name': inv.positionalArguments[0].name.value,
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // 400g for 4 servings, planning for 8 → 800g
      expect(insertedItems[0]['quantityNeeded'], 800.0);
    });

    test('aggregates duplicate ingredients from multiple recipes', () async {
      final r1 = _recipe(id: 'r1', title: 'Омлет');
      final r2 = _recipe(id: 'r2', title: 'Яичница');
      final entry = _entry(id: 'e1', recipes: [r1, r2], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Яйца',
              quantity: 3,
              unit: 'pcs',
            ),
          ]);
      when(mockRecipesDao.getByRecipe('r2')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i2',
              recipeId: 'r2',
              name: 'Яйца',
              quantity: 2,
              unit: 'pcs',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'name': inv.positionalArguments[0].name.value,
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // 3 + 2 = 5 eggs aggregated
      expect(insertedItems.length, 1);
      expect(insertedItems[0]['name'], 'Яйца');
      expect(insertedItems[0]['quantityNeeded'], 5.0);
    });

    test('deducts pantry stock from needed quantity', () async {
      final recipe = _recipe(id: 'r1', title: 'Суп');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Картофель',
              quantity: 400,
              unit: 'g',
            ),
          ]);

      // Pantry has 150g of potatoes
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(
              id: 'p1',
              name: 'Картофель',
              quantity: 150,
              unit: 'g',
            ),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems[0]['quantityNeeded'], 400.0);
      expect(insertedItems[0]['quantityInPantry'], 150.0);
      // toBuy = max(0, 400 - 150) = 250
      expect(insertedItems[0]['quantityToBuy'], 250.0);
    });

    test('sets toBuy to 0 when pantry covers full need', () async {
      final recipe = _recipe(id: 'r1', title: 'Салат');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Морковь',
              quantity: 200,
              unit: 'g',
            ),
          ]);

      // Pantry has 300g — more than needed
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(
              id: 'p1',
              name: 'Морковь',
              quantity: 300,
              unit: 'g',
            ),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems[0]['quantityToBuy'], 0.0);
    });

    test('handles empty meal plan (no entries)', () async {
      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => []);
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({});
        return 1;
      });

      final result = await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems.length, 0);
      expect(result.items.length, 0);
    });

    test('does not aggregate ingredients with different units', () async {
      final recipe = _recipe(id: 'r1', title: 'Пирог');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      // Two ingredients named "Мука" but different units
      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Мука',
              quantity: 200,
              unit: 'g',
            ),
            _ingredientRow(
              id: 'i2',
              recipeId: 'r1',
              name: 'Мука',
              quantity: 1,
              unit: 'cup',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'name': inv.positionalArguments[0].name.value,
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
          'unit': inv.positionalArguments[0].unit.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // Two separate items: Мука (g) and Мука (cup)
      expect(insertedItems.length, 2);
      expect(insertedItems[0]['unit'], 'g');
      expect(insertedItems[1]['unit'], 'cup');
    });

    test('aggregates ingredients across multiple days', () async {
      final recipe = _recipe(id: 'r1', title: 'Борщ');
      final entry1 = _entry(id: 'e1', recipes: [recipe], servings: 4);
      final entry2 = MealPlanEntry(
        id: 'e2',
        familyId: 'f1',
        date: DateTime(2026, 6, 24),
        mealType: MealType.dinner,
        servings: 4,
        recipes: [recipe],
      );

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry1, entry2]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Свёкла',
              quantity: 300,
              unit: 'g',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 24),
      );

      // 300g × 2 days = 600g
      expect(insertedItems.length, 1);
      expect(insertedItems[0]['quantityNeeded'], 600.0);
    });

    test('pantry match is case-insensitive', () async {
      final recipe = _recipe(id: 'r1', title: 'Плов');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Рис',
              quantity: 500,
              unit: 'g',
            ),
          ]);

      // Pantry has "РИС" (uppercase)
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(
              id: 'p1',
              name: 'РИС',
              quantity: 200,
              unit: 'g',
            ),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // Should match "Рис" with "РИС" (case-insensitive)
      expect(insertedItems[0]['quantityInPantry'], 200.0);
      expect(insertedItems[0]['quantityToBuy'], 300.0);
    });

    test('pantry items with different units are not matched', () async {
      final recipe = _recipe(id: 'r1', title: 'Тесто');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Мука',
              quantity: 500,
              unit: 'g',
            ),
          ]);

      // Pantry has flour in cups, not grams
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(
              id: 'p1',
              name: 'Мука',
              quantity: 2,
              unit: 'cup',
            ),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // Different unit → no pantry match
      expect(insertedItems[0]['quantityInPantry'], 0.0);
      expect(insertedItems[0]['quantityToBuy'], 500.0);
    });

    test('sums multiple pantry items with same name and unit', () async {
      final recipe = _recipe(id: 'r1', title: 'Пирог');
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Яйца',
              quantity: 10,
              unit: 'pcs',
            ),
          ]);

      // Two pantry entries for eggs
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(id: 'p1', name: 'Яйца', quantity: 4, unit: 'pcs'),
            _pantryRow(id: 'p2', name: 'Яйца', quantity: 3, unit: 'pcs'),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems[0]['quantityNeeded'], 10.0);
      // 4 + 3 = 7 eggs in pantry
      expect(insertedItems[0]['quantityInPantry'], 7.0);
      expect(insertedItems[0]['quantityToBuy'], 3.0);
    });

    test('handles recipe with zero defaultServings (no scaling)', () async {
      final recipe = _recipe(id: 'r1', title: 'Салат', defaultServings: 0);
      final entry = _entry(id: 'e1', recipes: [recipe], servings: 4);

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Помидоры',
              quantity: 300,
              unit: 'g',
            ),
          ]);

      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      // Scale = 1.0 when defaultServings is 0
      expect(insertedItems[0]['quantityNeeded'], 300.0);
    });

    test('generates default name from date range', () async {
      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => []);
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);
      when(mockShoppingDao.upsertList(any)).thenAnswer((inv) async {
        // Capture the list name
        final companion = inv.positionalArguments[0];
        expect(companion.name.value, '23 июн — 25 июн');
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 25),
      );
    });

    test('uses custom name when provided', () async {
      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => []);
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => []);
      when(mockShoppingDao.upsertList(any)).thenAnswer((inv) async {
        final companion = inv.positionalArguments[0];
        expect(companion.name.value, 'На дачу');
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 25),
        name: 'На дачу',
      );
    });

    test('complex scenario: multi-day, multi-recipe, partial pantry', () async {
      final r1 = _recipe(id: 'r1', title: 'Борщ', defaultServings: 4);
      final r2 = _recipe(id: 'r2', title: 'Плов', defaultServings: 6);
      final entry1 = _entry(
        id: 'e1',
        recipes: [r1],
        servings: 4,
        mealType: MealType.lunch,
      );
      final entry2 = _entry(
        id: 'e2',
        recipes: [r2],
        servings: 6,
        mealType: MealType.dinner,
      );

      when(mockMealPlanRepo.getRange(any, any, any))
          .thenAnswer((_) async => [entry1, entry2]);

      when(mockRecipesDao.getByRecipe('r1')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i1',
              recipeId: 'r1',
              name: 'Свёкла',
              quantity: 300,
              unit: 'g',
            ),
            _ingredientRow(
              id: 'i2',
              recipeId: 'r1',
              name: 'Морковь',
              quantity: 150,
              unit: 'g',
            ),
          ]);

      when(mockRecipesDao.getByRecipe('r2')).thenAnswer((_) async => [
            _ingredientRow(
              id: 'i3',
              recipeId: 'r2',
              name: 'Морковь',
              quantity: 200,
              unit: 'g',
            ),
            _ingredientRow(
              id: 'i4',
              recipeId: 'r2',
              name: 'Рис',
              quantity: 400,
              unit: 'g',
            ),
          ]);

      // Pantry: 100g carrots
      when(mockPantryDao.getAll('f1')).thenAnswer((_) async => [
            _pantryRow(id: 'p1', name: 'Морковь', quantity: 100, unit: 'g'),
          ]);

      final insertedItems = <Map<String, dynamic>>[];
      when(mockShoppingDao.upsertList(any)).thenAnswer((_) async => 1);
      when(mockShoppingDao.upsertItem(any)).thenAnswer((inv) async {
        insertedItems.add({
          'name': inv.positionalArguments[0].name.value,
          'quantityNeeded': inv.positionalArguments[0].quantityNeeded.value,
          'quantityInPantry': inv.positionalArguments[0].quantityInPantry.value,
          'quantityToBuy': inv.positionalArguments[0].quantityToBuy.value,
        });
        return 1;
      });
      when(mockShoppingDao.getById(any)).thenAnswer((_) async => _fakeListRow('test-list-id'));
      when(mockShoppingDao.getItems(any)).thenAnswer((_) async => []);

      await repo.generateFromMealPlan(
        familyId: 'f1',
        dateFrom: DateTime(2026, 6, 23),
        dateTo: DateTime(2026, 6, 23),
      );

      expect(insertedItems.length, 3);

      // Свёкла: 300g (same servings as default)
      final svkla = insertedItems.firstWhere((i) => i['name'] == 'Свёкла');
      expect(svkla['quantityNeeded'], 300.0);
      expect(svkla['quantityToBuy'], 300.0);

      // Морковь: 150 (r1) + 200 (r2, same servings as default) = 350g
      final morkov = insertedItems.firstWhere((i) => i['name'] == 'Морковь');
      expect(morkov['quantityNeeded'], 350.0);
      expect(morkov['quantityInPantry'], 100.0);
      expect(morkov['quantityToBuy'], 250.0);

      // Рис: 400g
      final ris = insertedItems.firstWhere((i) => i['name'] == 'Рис');
      expect(ris['quantityNeeded'], 400.0);
      expect(ris['quantityToBuy'], 400.0);
    });
  });
}

// ── Helpers to create Drift table data rows ──────────────────────────────────

IngredientsTableData _ingredientRow({
  required String id,
  required String recipeId,
  required String name,
  required double quantity,
  required String unit,
  String? category,
}) {
  return IngredientsTableData(
    id: id,
    recipeId: recipeId,
    name: name,
    quantity: quantity,
    unit: unit,
    category: category,
    sortOrder: 0,
  );
}

PantryItemsTableData _pantryRow({
  required String id,
  required String name,
  required double quantity,
  required String unit,
  String category = 'other',
}) {
  return PantryItemsTableData(
    id: id,
    familyId: 'f1',
    name: name,
    quantity: quantity,
    unit: unit,
    category: category,
    minQuantity: 0,
    createdAt: 0,
    updatedAt: 0,
  );
}
