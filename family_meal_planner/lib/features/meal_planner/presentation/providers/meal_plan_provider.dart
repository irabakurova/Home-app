import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../data/repositories/meal_plan_repository_impl.dart';
import '../../domain/entities/meal_plan_entry.dart';
import '../../domain/repositories/meal_plan_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────────

final mealPlanRepositoryProvider = Provider<MealPlanRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MealPlanRepositoryImpl(db.mealPlanDao, db.recipesDao);
});

// ── Planner navigation state ──────────────────────────────────────────────────

/// 7 = one week, 14 = two weeks.
final plannerRangeLengthProvider = StateProvider<int>((ref) => 7);

/// Offset in weeks from the current week (0 = this week, 1 = next week, etc.).
final plannerWeekOffsetProvider = StateProvider<int>((ref) => 0);

// ── Derived date range ────────────────────────────────────────────────────────

/// The Monday (start) of the currently viewed range.
final plannerStartDateProvider = Provider<DateTime>((ref) {
  final offset = ref.watch(plannerWeekOffsetProvider);
  final base = DateTime.now().startOfWeek;
  return base.add(Duration(days: offset * 7));
});

/// The last day of the currently viewed range (inclusive).
final plannerEndDateProvider = Provider<DateTime>((ref) {
  final start = ref.watch(plannerStartDateProvider);
  final length = ref.watch(plannerRangeLengthProvider);
  return start.add(Duration(days: length - 1));
});

// ── Stream of entries ─────────────────────────────────────────────────────────

final mealPlanEntriesProvider = StreamProvider<List<MealPlanEntry>>((ref) {
  final repo = ref.watch(mealPlanRepositoryProvider);
  final start = ref.watch(plannerStartDateProvider);
  final end = ref.watch(plannerEndDateProvider);
  return repo.watchRange(kDefaultFamilyId, start, end);
});

// ── Derived: grouped by day ───────────────────────────────────────────────────

/// Returns a [MealPlanDay] for every day in the current range.
/// Days without entries still appear (with empty entry lists).
final mealPlanDaysProvider = Provider<AsyncValue<List<MealPlanDay>>>((ref) {
  final start = ref.watch(plannerStartDateProvider);
  final length = ref.watch(plannerRangeLengthProvider);
  final entriesAsync = ref.watch(mealPlanEntriesProvider);

  return entriesAsync.whenData((entries) {
    return List.generate(length, (i) {
      final date = start.add(Duration(days: i));
      final dayEntries = entries
          .where((e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day)
          .toList()
        ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));
      return MealPlanDay(date: date, entries: dayEntries);
    });
  });
});

// ── Notifier for mutations ────────────────────────────────────────────────────

class MealPlanNotifier extends AsyncNotifier<void> {
  MealPlanRepository get _repo => ref.read(mealPlanRepositoryProvider);

  @override
  Future<void> build() async {}

  Future<void> addRecipe({
    required DateTime date,
    required MealType mealType,
    required String recipeId,
    int servings = 4,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.addRecipeToSlot(
          familyId: kDefaultFamilyId,
          date: date,
          mealType: mealType,
          recipeId: recipeId,
          servings: servings,
        ));
  }

  Future<void> removeRecipe(String mealPlanRecipeId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => _repo.removeRecipeFromSlot(mealPlanRecipeId));
  }

  Future<void> removeSlot(String mealPlanId) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _repo.removeSlot(mealPlanId));
  }
}

final mealPlanNotifierProvider =
    AsyncNotifierProvider<MealPlanNotifier, void>(MealPlanNotifier.new);
