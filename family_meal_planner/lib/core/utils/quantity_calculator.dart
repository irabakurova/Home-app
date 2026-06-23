import '../constants/enums.dart';

class QuantityCalculator {
  QuantityCalculator._();

  /// Scales ingredient quantity from [defaultServings] to [targetServings].
  /// Returns the scaled value rounded to avoid floating-point noise.
  static double scale({
    required double quantity,
    required int defaultServings,
    required int targetServings,
  }) {
    if (defaultServings == 0) return quantity;
    final result = (quantity / defaultServings) * targetServings;
    return _round(result);
  }

  /// Formats a quantity for display: removes trailing zeros.
  /// 300.0 → "300", 1.5 → "1.5", 0.333 → "0.33"
  static String format(double quantity) {
    if (quantity == quantity.truncate()) {
      return quantity.truncate().toString();
    }
    // 2 decimal places max
    return quantity.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
  }

  /// Full display string: "300 г" or "1.5 кг"
  static String formatWithUnit(double quantity, MeasurementUnit unit) {
    return '${format(quantity)} ${unit.label}';
  }

  static double _round(double value) {
    return (value * 1000).round() / 1000;
  }
}
