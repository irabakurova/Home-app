import '../database/app_database.dart';

// Web stub — export to a local file is unavailable in the PWA/browser.
// All data persists via Firebase Firestore sync.

class ExportStats {
  const ExportStats({
    required this.recipes,
    required this.pantry,
    required this.categories,
    required this.mealPlans,
    required this.shoppingLists,
    required this.history,
  });

  final int recipes;
  final int pantry;
  final int categories;
  final int mealPlans;
  final int shoppingLists;
  final int history;

  String get summary =>
      'Рецептов: $recipes, кладовая: $pantry, '
      'меню: $mealPlans, покупки: $shoppingLists, история: $history';
}

class ExportResult {
  const ExportResult({required this.filePath, required this.stats});
  final String filePath;
  final ExportStats stats;
}

class ExportService {
  const ExportService();

  Future<ExportResult> exportToFile(AppDatabase db) {
    throw UnsupportedError(
      'Экспорт файлов недоступен в веб-версии. '
      'Используйте приложение на Android или Windows.',
    );
  }
}
