import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../data/repositories/recipe_generator_repository_impl.dart';
import '../../domain/entities/recipe_suggestion.dart';
import '../../domain/repositories/recipe_generator_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final recipeGeneratorRepositoryProvider =
    Provider<RecipeGeneratorRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecipeGeneratorRepositoryImpl(db.recipesDao, db.pantryDao);
});

// ── Filter threshold ──────────────────────────────────────────────────────────

enum SuggestionFilter { all, nearly, full }

final suggestionFilterProvider = StateProvider<SuggestionFilter>(
  (ref) => SuggestionFilter.all,
);

// ── Raw suggestions (one-shot, refreshable via ref.invalidate) ────────────────

final rawSuggestionsProvider =
    FutureProvider<List<RecipeSuggestion>>((ref) async {
  return ref
      .watch(recipeGeneratorRepositoryProvider)
      .getSuggestions(kDefaultFamilyId);
});

// ── Filtered suggestions ──────────────────────────────────────────────────────

final filteredSuggestionsProvider =
    Provider<AsyncValue<List<RecipeSuggestion>>>((ref) {
  final raw = ref.watch(rawSuggestionsProvider);
  final filter = ref.watch(suggestionFilterProvider);

  return raw.whenData((list) {
    return switch (filter) {
      SuggestionFilter.all => list,
      SuggestionFilter.nearly =>
        list.where((s) => s.isNearlyAvailable).toList(),
      SuggestionFilter.full =>
        list.where((s) => s.isFullyAvailable).toList(),
    };
  });
});
