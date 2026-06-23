// ignore_for_file: constant_identifier_names

class AppConstants {
  AppConstants._();

  static const String appName = 'Семейное меню';
  static const String appVersion = '1.0.0';

  // Serving limits
  static const int minServings = 1;
  static const int maxServings = 10;
  static const int defaultServings = 4;

  // Sync
  static const int syncRetryLimit = 5;
  static const Duration syncDebounce = Duration(seconds: 3);

  // UI
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
}
