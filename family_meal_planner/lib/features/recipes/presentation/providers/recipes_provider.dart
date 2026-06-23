import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

// ── Constants ─────────────────────────────────────────────────────────────────

/// Shared family ID used as the key for all data in Firestore and SQLite.
/// Both devices (PC and phone) use this same ID so they sync to the same data.
const kDefaultFamilyId = 'default_family';

const kDefaultUserId = 'default_user';

// ── Repository ────────────────────────────────────────────────────────────────

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecipeRepositoryImpl(db.recipesDao);
});

// ── Recipes stream ────────────────────────────────────────────────────────────

final recipesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeRepositoryProvider).watchAll(kDefaultFamilyId);
});

final favoritesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  return ref.watch(recipeRepositoryProvider).watchFavorites(kDefaultFamilyId);
});

// ── Recipe by ID ──────────────────────────────────────────────────────────────

final recipeByIdProvider =
    FutureProvider.family<Recipe?, String>((ref, id) async {
  return ref.watch(recipeRepositoryProvider).getById(id);
});

// ── Ingredients ───────────────────────────────────────────────────────────────

final recipeIngredientsProvider =
    StreamProvider.family<List<Ingredient>, String>((ref, recipeId) {
  return ref.watch(recipeRepositoryProvider).watchIngredients(recipeId);
});

// ── Search & Filter state ─────────────────────────────────────────────────────

final recipeSearchQueryProvider = StateProvider<String>((ref) => '');

/// Active category filter — holds the category value slug (e.g. 'hot_dish')
/// or null for "all categories".
final recipeCategoryFilterProvider = StateProvider<String?>((ref) => null);

// ── Filtered list ─────────────────────────────────────────────────────────────

final filteredRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final recipes = ref.watch(recipesStreamProvider);
  final query = ref.watch(recipeSearchQueryProvider).trim().toLowerCase();
  final categoryValue = ref.watch(recipeCategoryFilterProvider);

  return recipes.whenData((list) {
    var filtered = list;
    if (query.isNotEmpty) {
      filtered = filtered.where((r) {
        final titleMatch = r.title.toLowerCase().contains(query);
        final descMatch =
            r.description?.toLowerCase().contains(query) ?? false;
        return titleMatch || descMatch;
      }).toList();
    }
    if (categoryValue != null) {
      filtered = filtered.where((r) => r.category == categoryValue).toList();
    }
    return filtered;
  });
});
