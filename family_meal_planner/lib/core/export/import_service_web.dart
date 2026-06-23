import '../database/app_database.dart';

// Web stub — file-based import is unavailable in the PWA/browser.
// All data persists via Firebase Firestore sync.

class ImportResult {
  const ImportResult({
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

class ImportService {
  const ImportService();

  Future<ImportResult?> importFromFile(AppDatabase db) {
    throw UnsupportedError(
      'Импорт файлов недоступен в веб-версии. '
      'Используйте приложение на Android или Windows.',
    );
  }
}
