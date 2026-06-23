import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../recipes/domain/entities/ingredient.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId, kDefaultUserId;
import '../../data/repositories/cooking_history_repository_impl.dart';
import '../../domain/entities/cooking_history_entry.dart';
import '../../domain/repositories/cooking_history_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────────

final cookingHistoryRepositoryProvider =
    Provider<CookingHistoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CookingHistoryRepositoryImpl(db.historyDao, db.pantryDao);
});

// ── Stream providers ──────────────────────────────────────────────────────────

final cookingHistoryProvider =
    StreamProvider<List<CookingHistoryEntry>>((ref) {
  return ref
      .watch(cookingHistoryRepositoryProvider)
      .watchAll(kDefaultFamilyId);
});

// ── Search / filter ───────────────────────────────────────────────────────────

final historySearchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered history: search by recipe title (case-insensitive).
final filteredHistoryProvider =
    Provider<AsyncValue<List<CookingHistoryEntry>>>((ref) {
  final history = ref.watch(cookingHistoryProvider);
  final query = ref.watch(historySearchQueryProvider).trim().toLowerCase();
  return history.whenData((list) {
    if (query.isEmpty) return list;
    return list
        .where((e) => e.recipeTitle.toLowerCase().contains(query))
        .toList();
  });
});

final recipeHistoryProvider =
    FutureProvider.family<List<CookingHistoryEntry>, String>(
        (ref, recipeId) async {
  return ref
      .watch(cookingHistoryRepositoryProvider)
      .getByRecipe(kDefaultFamilyId, recipeId);
});

final popularRecipesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref
      .watch(cookingHistoryRepositoryProvider)
      .getPopularRecipes(kDefaultFamilyId, 10);
});

// ── Notifier ──────────────────────────────────────────────────────────────────

class CookingNotifier extends AsyncNotifier<void> {
  CookingHistoryRepository get _repo =>
      ref.read(cookingHistoryRepositoryProvider);

  @override
  Future<void> build() async {}

  /// Marks the recipe as cooked, deducts ingredients from pantry, and logs
  /// the session to cooking history. Returns the deduction results so the
  /// UI can show which items were missing from the pantry.
  Future<List<DeductionResult>> markCooked({
    required String recipeId,
    required String recipeTitle,
    required int servingsCooked,
    required List<Ingredient> scaledIngredients,
    String? notes,
  }) async {
    state = const AsyncLoading();
    late List<DeductionResult> deductions;
    state = await AsyncValue.guard(() async {
      final result = await _repo.markCooked(
        familyId: kDefaultFamilyId,
        recipeId: recipeId,
        recipeTitle: recipeTitle,
        servingsCooked: servingsCooked,
        cookedBy: kDefaultUserId,
        scaledIngredients: scaledIngredients,
        notes: notes,
      );
      deductions = result.deductions;
    });
    if (state is AsyncError) return [];
    return deductions;
  }
}

final cookingNotifierProvider =
    AsyncNotifierProvider<CookingNotifier, void>(CookingNotifier.new);
