import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../data/repositories/pantry_repository_impl.dart';
import '../../domain/entities/pantry_item.dart';
import '../../domain/repositories/pantry_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PantryRepositoryImpl(db.pantryDao);
});

// ── Streams ───────────────────────────────────────────────────────────────────

final pantryStreamProvider = StreamProvider<List<PantryItem>>((ref) {
  return ref.watch(pantryRepositoryProvider).watchAll(kDefaultFamilyId);
});

final pantryLowStockProvider = StreamProvider<List<PantryItem>>((ref) {
  return ref.watch(pantryRepositoryProvider).watchLowStock(kDefaultFamilyId);
});

// ── Search & filter state ─────────────────────────────────────────────────────

final pantrySearchQueryProvider = StateProvider<String>((ref) => '');

/// Active category filter — value slug or null for "all".
final pantryCategoryFilterProvider = StateProvider<String?>((ref) => null);

// ── Filtered list ─────────────────────────────────────────────────────────────

final filteredPantryProvider = Provider<AsyncValue<List<PantryItem>>>((ref) {
  final items = ref.watch(pantryStreamProvider);
  final query = ref.watch(pantrySearchQueryProvider).trim().toLowerCase();
  final category = ref.watch(pantryCategoryFilterProvider);

  return items.whenData((list) {
    var filtered = list;
    if (query.isNotEmpty) {
      filtered = filtered
          .where((i) => i.name.toLowerCase().contains(query))
          .toList();
    }
    if (category != null) {
      filtered = filtered.where((i) => i.category == category).toList();
    }
    return filtered;
  });
});

// ── Single item ───────────────────────────────────────────────────────────────

final pantryItemByIdProvider =
    FutureProvider.family<PantryItem?, String>((ref, id) async {
  return ref.watch(pantryRepositoryProvider).getById(id);
});
