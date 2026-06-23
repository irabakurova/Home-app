import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:easily_kitchen/core/constants/enums.dart';
import 'package:easily_kitchen/core/database/app_database.dart';
import 'package:easily_kitchen/features/history/data/repositories/cooking_history_repository_impl.dart';
import 'package:easily_kitchen/features/recipes/domain/entities/ingredient.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late CookingHistoryRepositoryImpl repo;
  late MockHistoryDao mockHistoryDao;
  late MockPantryDao mockPantryDao;

  setUp(() {
    mockHistoryDao = MockHistoryDao();
    mockPantryDao = MockPantryDao();
    repo = CookingHistoryRepositoryImpl(mockHistoryDao, mockPantryDao);
  });

  Ingredient _ingredient({
    String name = 'Картофель',
    double quantity = 400,
    MeasurementUnit unit = MeasurementUnit.g,
    PantryCategory? category,
  }) {
    return Ingredient(
      id: 'i1',
      recipeId: 'r1',
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
  }) {
    return PantryItemsTableData(
      id: id,
      familyId: 'f1',
      name: name,
      quantity: quantity,
      unit: unit,
      category: 'other',
      minQuantity: 0,
      createdAt: 0,
      updatedAt: 0,
    );
  }

  group('markCooked — pantry deduction', () {
    setUp(() {
      when(mockHistoryDao.insertHistory(any)).thenAnswer((_) async => 1);
      when(mockHistoryDao.insertIngredient(any)).thenAnswer((_) async => 1);
    });

    test('deducts full quantity when pantry has enough', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Картофель', 'g'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p1',
                name: 'Картофель',
                quantity: 500,
                unit: 'g',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Суп',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(quantity: 400)],
      );

      expect(result.deductions.length, 1);
      expect(result.deductions[0].quantityDeducted, 400.0);
      expect(result.deductions[0].pantryItemId, 'p1');
      expect(result.deductions[0].wasFullyDeducted, isTrue);

      // Verify pantry was updated: 500 - 400 = 100
      verify(mockPantryDao.updateQuantity('p1', 100.0, any)).called(1);
    });

    test('deducts partial quantity when pantry has less than needed', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Морковь', 'g'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p2',
                name: 'Морковь',
                quantity: 100,
                unit: 'g',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Салат',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(name: 'Морковь', quantity: 200)],
      );

      expect(result.deductions[0].quantityDeducted, 100.0);
      expect(result.deductions[0].wasFullyDeducted, isFalse);

      // Verify pantry was zeroed: max(0, 100 - 200) = 0
      verify(mockPantryDao.updateQuantity('p2', 0.0, any)).called(1);
    });

    test('does not deduct when pantry has zero quantity', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Лук', 'pcs'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p3',
                name: 'Лук',
                quantity: 0,
                unit: 'pcs',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Плов',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(name: 'Лук', quantity: 3, unit: MeasurementUnit.pcs)],
      );

      expect(result.deductions[0].quantityDeducted, 0.0);
      expect(result.deductions[0].wasFullyDeducted, isFalse);

      // Pantry updated to 0
      verify(mockPantryDao.updateQuantity('p3', 0.0, any)).called(1);
    });

    test('no deduction when pantry item not found', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Шафран', 'pinch'))
          .thenAnswer((_) async => null);

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Паэлья',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [
          _ingredient(name: 'Шафран', quantity: 1, unit: MeasurementUnit.pinch),
        ],
      );

      expect(result.deductions[0].pantryItemId, isNull);
      expect(result.deductions[0].notInPantry, isTrue);
      expect(result.deductions[0].quantityDeducted, 0.0);

      // No pantry update should happen
      verifyNever(mockPantryDao.updateQuantity(any, any, any));
    });

    test('pantry lookup delegates to DAO with ingredient name and unit', () async {
      // The DAO handles case-insensitive matching in the DB.
      // We verify the repository passes the correct arguments to the DAO.
      when(mockPantryDao.getByNameAndUnit('f1', 'Рис', 'g'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p4',
                name: 'Рис',
                quantity: 500,
                unit: 'g',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Плов',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(name: 'Рис', quantity: 300)],
      );

      expect(result.deductions[0].pantryItemId, 'p4');
      expect(result.deductions[0].quantityDeducted, 300.0);

      // Verify the DAO was called with the correct arguments
      verify(mockPantryDao.getByNameAndUnit('f1', 'Рис', 'g')).called(1);
    });

    test('different units do not match pantry', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Мука', 'cup'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p5',
                name: 'Мука',
                quantity: 2,
                unit: 'cup',
              ));
      when(mockPantryDao.getByNameAndUnit(any, any, any))
          .thenAnswer((_) async => null);

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Пирог',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(name: 'Мука', quantity: 500, unit: MeasurementUnit.g)],
      );

      // "Мука" in g doesn't match "Мука" in cup
      expect(result.deductions[0].pantryItemId, isNull);
      expect(result.deductions[0].notInPantry, isTrue);
    });

    test('multiple ingredients processed independently', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Картофель', 'g'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p1',
                name: 'Картофель',
                quantity: 300,
                unit: 'g',
              ));
      when(mockPantryDao.getByNameAndUnit('f1', 'Морковь', 'g'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p2',
                name: 'Морковь',
                quantity: 150,
                unit: 'g',
              ));
      when(mockPantryDao.getByNameAndUnit('f1', 'Лавровый лист', 'pcs'))
          .thenAnswer((_) async => null);

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Суп',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [
          _ingredient(name: 'Картофель', quantity: 400),
          _ingredient(name: 'Морковь', quantity: 150),
          _ingredient(name: 'Лавровый лист', quantity: 2, unit: MeasurementUnit.pcs),
        ],
      );

      expect(result.deductions.length, 3);

      // Картофель: 400 needed, 300 in pantry → deducted 300, pantry → 0
      expect(result.deductions[0].quantityDeducted, 300.0);
      verify(mockPantryDao.updateQuantity('p1', 0.0, any)).called(1);

      // Морковь: 150 needed, 150 in pantry → deducted 150, pantry → 0
      expect(result.deductions[1].quantityDeducted, 150.0);
      verify(mockPantryDao.updateQuantity('p2', 0.0, any)).called(1);

      // Лавровый лист: not in pantry
      expect(result.deductions[2].pantryItemId, isNull);
    });

    test('creates history entry with correct data', () async {
      when(mockPantryDao.getByNameAndUnit(any, any, any))
          .thenAnswer((_) async => null);

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Борщ',
        servingsCooked: 6,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient()],
        notes: 'Добавил сметану',
      );

      expect(result.entry.familyId, 'f1');
      expect(result.entry.recipeId, 'r1');
      expect(result.entry.recipeTitle, 'Борщ');
      expect(result.entry.servingsCooked, 6);
      expect(result.entry.cookedBy, 'user1');
      expect(result.entry.notes, 'Добавил сметану');
      expect(result.entry.ingredients.length, 1);
    });

    test('history ingredient logs pantryItemId when matched', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Яйца', 'pcs'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p6',
                name: 'Яйца',
                quantity: 10,
                unit: 'pcs',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Омлет',
        servingsCooked: 2,
        cookedBy: 'user1',
        scaledIngredients: [
          _ingredient(name: 'Яйца', quantity: 3, unit: MeasurementUnit.pcs),
        ],
      );

      expect(result.entry.ingredients[0].pantryItemId, 'p6');
      expect(result.entry.ingredients[0].quantityUsed, 3.0);
    });

    test('history ingredient has null pantryItemId when not matched', () async {
      when(mockPantryDao.getByNameAndUnit(any, any, any))
          .thenAnswer((_) async => null);

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Салат',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [_ingredient(name: 'Авокадо', quantity: 2, unit: MeasurementUnit.pcs)],
      );

      expect(result.entry.ingredients[0].pantryItemId, isNull);
    });

    test('handles zero quantity ingredient', () async {
      when(mockPantryDao.getByNameAndUnit('f1', 'Соль', 'pinch'))
          .thenAnswer((_) async => _pantryRow(
                id: 'p7',
                name: 'Соль',
                quantity: 100,
                unit: 'pinch',
              ));

      final result = await repo.markCooked(
        familyId: 'f1',
        recipeId: 'r1',
        recipeTitle: 'Суп',
        servingsCooked: 4,
        cookedBy: 'user1',
        scaledIngredients: [
          _ingredient(name: 'Соль', quantity: 0, unit: MeasurementUnit.pinch),
        ],
      );

      // quantityDeducted = clamp(0, 0, 100) = 0
      expect(result.deductions[0].quantityDeducted, 0.0);
      // Pantry: 100 - 0 = 100 (unchanged)
      verify(mockPantryDao.updateQuantity('p7', 100.0, any)).called(1);
    });
  });
}
