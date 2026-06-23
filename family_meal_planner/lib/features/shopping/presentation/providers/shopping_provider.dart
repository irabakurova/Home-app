import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../meal_planner/presentation/providers/meal_plan_provider.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/repositories/shopping_list_repository.dart';

// ── Repository provider ───────────────────────────────────────────────────────

final shoppingRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ShoppingListRepositoryImpl(
    db.shoppingDao,
    ref.watch(mealPlanRepositoryProvider),
    db.recipesDao,
    db.pantryDao,
  );
});

// ── All lists ─────────────────────────────────────────────────────────────────

final shoppingListsProvider =
    StreamProvider<List<ShoppingList>>((ref) {
  final repo = ref.watch(shoppingRepositoryProvider);
  return repo.watchLists(kDefaultFamilyId);
});

// ── Most recent list ID ───────────────────────────────────────────────────────

/// ID of the most recently created list (null if no lists exist).
final _latestListIdProvider = StreamProvider<String?>((ref) {
  final repo = ref.watch(shoppingRepositoryProvider);
  return repo
      .watchLists(kDefaultFamilyId)
      .map((lists) => lists.isEmpty ? null : lists.first.id);
});

// ── Most recent list (item-reactive) ─────────────────────────────────────────

/// The most recent shopping list with full item-level reactivity.
/// Re-emits whenever any item is checked/unchecked or added/deleted.
final latestShoppingListProvider = StreamProvider<ShoppingList?>((ref) {
  final idAsync = ref.watch(_latestListIdProvider);
  return idAsync.when(
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
    data: (id) {
      if (id == null) return Stream.value(null);
      return ref.watch(shoppingRepositoryProvider).watchList(id);
    },
  );
});

// ── Single list by id ─────────────────────────────────────────────────────────

final shoppingListByIdProvider =
    StreamProvider.family<ShoppingList?, String>((ref, id) {
  final repo = ref.watch(shoppingRepositoryProvider);
  return repo.watchList(id);
});

// ── Notifier for mutations ────────────────────────────────────────────────────

class ShoppingNotifier extends AsyncNotifier<void> {
  ShoppingListRepository get _repo => ref.read(shoppingRepositoryProvider);

  @override
  Future<void> build() async {}

  /// Generates a new list from the planner's current date range.
  Future<void> generate({String? name}) async {
    state = const AsyncLoading();
    final start = ref.read(plannerStartDateProvider);
    final end = ref.read(plannerEndDateProvider);

    state = await AsyncValue.guard(() async {
      await _repo.generateFromMealPlan(
        familyId: kDefaultFamilyId,
        dateFrom: start,
        dateTo: end,
        name: name,
      );
    });
  }

  Future<void> toggle(String itemId, {required bool isChecked}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _repo.toggleItem(itemId, isChecked: isChecked));
  }

  Future<void> deleteList(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteList(id));
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _repo.deleteItem(id));
  }

  Future<void> addManualItem({
    required String listId,
    required String name,
    required double quantity,
    required MeasurementUnit unit,
    PantryCategory? category,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.addManualItem(
          listId: listId,
          name: name,
          quantity: quantity,
          unit: unit,
          category: category,
        ));
  }
}

final shoppingNotifierProvider =
    AsyncNotifierProvider<ShoppingNotifier, void>(ShoppingNotifier.new);
