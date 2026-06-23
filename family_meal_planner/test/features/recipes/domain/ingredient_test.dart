import 'package:easily_kitchen/core/constants/enums.dart';
import 'package:easily_kitchen/features/recipes/domain/entities/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

// Helper to quickly build test ingredients
Ingredient _ing({
  String id = 'test-id',
  String recipeId = 'recipe-1',
  String name = 'Тест',
  required double quantity,
  MeasurementUnit unit = MeasurementUnit.g,
  int sortOrder = 0,
}) {
  return Ingredient(
    id: id,
    recipeId: recipeId,
    name: name,
    quantity: quantity,
    unit: unit,
    sortOrder: sortOrder,
  );
}

void main() {
  group('Ingredient.scale', () {
    test('returns same quantity when default == target servings', () {
      final ing = _ing(quantity: 400);
      final scaled = ing.scale(4, 4);
      expect(scaled.quantity, 400.0);
    });

    test('halves quantity for half servings', () {
      final ing = _ing(quantity: 600);
      final scaled = ing.scale(4, 2);
      expect(scaled.quantity, 300.0);
    });

    test('doubles quantity for double servings', () {
      final ing = _ing(quantity: 600);
      final scaled = ing.scale(4, 8);
      expect(scaled.quantity, 1200.0);
    });

    test('scales to max servings (10)', () {
      final ing = _ing(quantity: 600);
      final scaled = ing.scale(4, 10);
      expect(scaled.quantity, 1500.0);
    });

    test('preserves all fields except quantity', () {
      final ing = _ing(
        id: 'abc',
        recipeId: 'r1',
        name: 'Куриная грудка',
        quantity: 600,
        unit: MeasurementUnit.g,
        sortOrder: 2,
      );
      final scaled = ing.scale(4, 2);

      expect(scaled.id, 'abc');
      expect(scaled.recipeId, 'r1');
      expect(scaled.name, 'Куриная грудка');
      expect(scaled.unit, MeasurementUnit.g);
      expect(scaled.sortOrder, 2);
      expect(scaled.quantity, 300.0); // only this changes
    });

    test('handles default servings = 0 gracefully (no crash)', () {
      final ing = _ing(quantity: 300);
      // Should not throw — QuantityCalculator.scale protects against /0
      expect(() => ing.scale(0, 4), returnsNormally);
      final scaled = ing.scale(0, 4);
      expect(scaled.quantity, 300.0); // unchanged
    });

    test('scale to 1 serving gives per-person amount', () {
      final ing = _ing(quantity: 400);
      final scaled = ing.scale(4, 1);
      expect(scaled.quantity, 100.0);
    });

    test('fractional result is rounded to 3 decimal places', () {
      // 1 шт на 3 → 2 = 0.667
      final ing = _ing(quantity: 1, unit: MeasurementUnit.pcs);
      final scaled = ing.scale(3, 2);
      expect(scaled.quantity, closeTo(0.667, 0.0001));
    });

    test('works with kilograms unit', () {
      final ing = _ing(quantity: 1.5, unit: MeasurementUnit.kg);
      final scaled = ing.scale(2, 4);
      expect(scaled.quantity, 3.0);
      expect(scaled.unit, MeasurementUnit.kg); // unit preserved
    });

    test('works with tablespoon unit', () {
      final ing = _ing(quantity: 4, unit: MeasurementUnit.tbsp);
      final scaled = ing.scale(4, 2);
      expect(scaled.quantity, 2.0);
      expect(scaled.unit, MeasurementUnit.tbsp);
    });

    test('zero quantity stays zero after scaling', () {
      final ing = _ing(quantity: 0);
      final scaled = ing.scale(4, 10);
      expect(scaled.quantity, 0.0);
    });

    test('scale is not applied in-place — original unchanged', () {
      final ing = _ing(quantity: 600);
      ing.scale(4, 2); // discard result
      expect(ing.quantity, 600.0); // original untouched
    });
  });

  group('Ingredient.copyWith', () {
    test('copyWith creates new instance with changed fields', () {
      final ing = _ing(id: 'x', name: 'Рис', quantity: 200);
      final copy = ing.copyWith(quantity: 400, name: 'Гречка');
      expect(copy.quantity, 400.0);
      expect(copy.name, 'Гречка');
      expect(copy.id, 'x'); // unchanged
    });

    test('copyWith with no args returns equivalent object', () {
      final ing = _ing(id: 'y', name: 'Лук', quantity: 100);
      final copy = ing.copyWith();
      expect(copy.id, ing.id);
      expect(copy.name, ing.name);
      expect(copy.quantity, ing.quantity);
    });

    test('nullable category can be set to null via copyWith', () {
      final ing = _ing(quantity: 100).copyWith(
        category: PantryCategory.vegetables,
      );
      final cleared = ing.copyWith(category: null);
      expect(cleared.category, isNull);
    });
  });

  group('Ingredient equality', () {
    test('two ingredients with same id are equal', () {
      final a = _ing(id: 'same', quantity: 100);
      final b = _ing(id: 'same', quantity: 999); // different qty
      expect(a, equals(b));
    });

    test('two ingredients with different ids are not equal', () {
      final a = _ing(id: 'a', quantity: 100);
      final b = _ing(id: 'b', quantity: 100);
      expect(a, isNot(equals(b)));
    });
  });
}
