import 'package:easily_kitchen/core/constants/enums.dart';
import 'package:easily_kitchen/core/utils/quantity_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuantityCalculator.scale', () {
    test('returns same quantity when defaultServings == targetServings', () {
      expect(
        QuantityCalculator.scale(
            quantity: 600, defaultServings: 4, targetServings: 4),
        600.0,
      );
    });

    test('halves quantity when target is half of default', () {
      // 600 г на 4 → 2 человека = 300 г
      expect(
        QuantityCalculator.scale(
            quantity: 600, defaultServings: 4, targetServings: 2),
        300.0,
      );
    });

    test('doubles quantity when target is double of default', () {
      // 600 г на 4 → 8 человек = 1200 г
      expect(
        QuantityCalculator.scale(
            quantity: 600, defaultServings: 4, targetServings: 8),
        1200.0,
      );
    });

    test('scales to 10 servings correctly', () {
      // 600 г на 4 → 10 человек = 1500 г
      expect(
        QuantityCalculator.scale(
            quantity: 600, defaultServings: 4, targetServings: 10),
        1500.0,
      );
    });

    test('returns original quantity when defaultServings is 0', () {
      // защита от деления на ноль
      expect(
        QuantityCalculator.scale(
            quantity: 300, defaultServings: 0, targetServings: 4),
        300.0,
      );
    });

    test('scales fractional quantities correctly', () {
      // 1.5 кг на 2 → 3 человека = 2.25 кг
      expect(
        QuantityCalculator.scale(
            quantity: 1.5, defaultServings: 2, targetServings: 3),
        2.25,
      );
    });

    test('rounds to 3 decimal places to avoid floating-point noise', () {
      // 1 шт на 3 → 2 = 0.667
      final result = QuantityCalculator.scale(
          quantity: 1, defaultServings: 3, targetServings: 2);
      // Should be 0.667, not 0.6666666...
      expect(result, closeTo(0.667, 0.0001));
    });

    test('scale from 1 serving works as multiplier', () {
      // 100 г на 1 → 4 человека = 400 г
      expect(
        QuantityCalculator.scale(
            quantity: 100, defaultServings: 1, targetServings: 4),
        400.0,
      );
    });

    test('target servings 1 returns per-person amount', () {
      // 400 г на 4 → 1 человек = 100 г
      expect(
        QuantityCalculator.scale(
            quantity: 400, defaultServings: 4, targetServings: 1),
        100.0,
      );
    });

    test('handles small quantities (spices)', () {
      // 2 ч.л. на 4 → 2 человека = 1 ч.л.
      expect(
        QuantityCalculator.scale(
            quantity: 2, defaultServings: 4, targetServings: 2),
        1.0,
      );
    });

    test('handles zero quantity', () {
      expect(
        QuantityCalculator.scale(
            quantity: 0, defaultServings: 4, targetServings: 8),
        0.0,
      );
    });
  });

  group('QuantityCalculator.format', () {
    test('formats integer values without decimal point', () {
      expect(QuantityCalculator.format(300.0), '300');
    });

    test('formats decimal values with up to 2 decimal places', () {
      expect(QuantityCalculator.format(1.5), '1.5');
    });

    test('removes trailing zeros after decimal', () {
      expect(QuantityCalculator.format(1.50), '1.5');
    });

    test('formats two decimal places when needed', () {
      expect(QuantityCalculator.format(0.33), '0.33');
    });

    test('formats zero as "0"', () {
      expect(QuantityCalculator.format(0.0), '0');
    });

    test('formats large integer', () {
      expect(QuantityCalculator.format(1500.0), '1500');
    });

    test('formats 0.667 as "0.67"', () {
      // After rounding to 3 places then formatting to 2
      expect(QuantityCalculator.format(0.667), '0.67');
    });
  });

  group('QuantityCalculator.formatWithUnit', () {
    test('formats grams correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(300.0, MeasurementUnit.g),
        '300 г',
      );
    });

    test('formats kilograms correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(1.5, MeasurementUnit.kg),
        '1.5 кг',
      );
    });

    test('formats pieces correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(2.0, MeasurementUnit.pcs),
        '2 шт',
      );
    });

    test('formats tablespoon correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(1.0, MeasurementUnit.tbsp),
        '1 ст.л.',
      );
    });

    test('formats teaspoon correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(0.5, MeasurementUnit.tsp),
        '0.5 ч.л.',
      );
    });

    test('formats millilitres correctly', () {
      expect(
        QuantityCalculator.formatWithUnit(200.0, MeasurementUnit.ml),
        '200 мл',
      );
    });
  });

  group('QuantityCalculator — full scaling pipeline', () {
    // Tests mirroring the spec examples from project requirements

    test('Spec: 600 г курицы на 4 → 2 чел = 300 г', () {
      final scaled = QuantityCalculator.scale(
          quantity: 600, defaultServings: 4, targetServings: 2);
      expect(QuantityCalculator.formatWithUnit(scaled, MeasurementUnit.g),
          '300 г');
    });

    test('Spec: 600 г курицы на 4 → 8 чел = 1200 г', () {
      final scaled = QuantityCalculator.scale(
          quantity: 600, defaultServings: 4, targetServings: 8);
      expect(QuantityCalculator.formatWithUnit(scaled, MeasurementUnit.g),
          '1200 г');
    });

    test('Spec: 600 г курицы на 4 → 10 чел = 1500 г', () {
      final scaled = QuantityCalculator.scale(
          quantity: 600, defaultServings: 4, targetServings: 10);
      expect(QuantityCalculator.formatWithUnit(scaled, MeasurementUnit.g),
          '1500 г');
    });

    test('Boundary: min servings (1)', () {
      final scaled = QuantityCalculator.scale(
          quantity: 800, defaultServings: 4, targetServings: 1);
      expect(scaled, 200.0);
    });

    test('Boundary: max servings (10)', () {
      final scaled = QuantityCalculator.scale(
          quantity: 100, defaultServings: 1, targetServings: 10);
      expect(scaled, 1000.0);
    });
  });
}
