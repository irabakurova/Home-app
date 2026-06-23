import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/meal_plan_table.dart';

part 'meal_plan_dao.g.dart';

@DriftAccessor(tables: [MealPlansTable, MealPlanRecipesTable])
class MealPlanDao extends DatabaseAccessor<AppDatabase>
    with _$MealPlanDaoMixin {
  MealPlanDao(super.db);

  Stream<List<MealPlansTableData>> watchRange(
          String familyId, int dateFrom, int dateTo) =>
      (select(mealPlansTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.planDate.isBiggerOrEqualValue(dateFrom) &
                t.planDate.isSmallerOrEqualValue(dateTo))
            ..orderBy([(t) => OrderingTerm.asc(t.planDate)]))
          .watch();

  Future<List<MealPlanRecipesTableData>> getRecipesForPlan(
          String mealPlanId) =>
      (select(mealPlanRecipesTable)
            ..where((t) => t.mealPlanId.equals(mealPlanId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> upsertPlan(MealPlansTableCompanion plan) =>
      into(mealPlansTable).insertOnConflictUpdate(plan);

  Future<int> addRecipeToPlan(MealPlanRecipesTableCompanion entry) =>
      into(mealPlanRecipesTable).insertOnConflictUpdate(entry);

  Future<int> removeRecipeFromPlan(String mealPlanRecipeId) =>
      (delete(mealPlanRecipesTable)
            ..where((t) => t.id.equals(mealPlanRecipeId)))
          .go();

  Future<int> deletePlan(String id) =>
      (delete(mealPlansTable)..where((t) => t.id.equals(id))).go();

  Future<List<MealPlansTableData>> getRange(
          String familyId, int dateFrom, int dateTo) =>
      (select(mealPlansTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.planDate.isBiggerOrEqualValue(dateFrom) &
                t.planDate.isSmallerOrEqualValue(dateTo)))
          .get();

  /// Finds the plan slot for a specific (familyId, date, mealType) combination.
  /// Returns null if no slot exists yet.
  Future<MealPlansTableData?> getPlanByDateAndType(
          String familyId, int planDate, String mealType) =>
      (select(mealPlansTable)
            ..where((t) =>
                t.familyId.equals(familyId) &
                t.planDate.equals(planDate) &
                t.mealType.equals(mealType)))
          .getSingleOrNull();

  /// Removes all recipe entries for a given plan (used before deleting the plan).
  Future<int> deleteRecipesForPlan(String mealPlanId) =>
      (delete(mealPlanRecipesTable)
            ..where((t) => t.mealPlanId.equals(mealPlanId)))
          .go();

  // ── Sync helpers ──────────────────────────────────────────────────────────

  /// Returns all meal plans for a family — used by sync push.
  Future<List<MealPlansTableData>> getAllForSync(String familyId) =>
      (select(mealPlansTable)..where((t) => t.familyId.equals(familyId))).get();

  /// Returns all recipe slots whose parent plan belongs to [familyId].
  Future<List<MealPlanRecipesTableData>> getAllSlotsForSync(
      String familyId) async {
    final plans = await getAllForSync(familyId);
    if (plans.isEmpty) return [];
    final planIds = plans.map((p) => p.id).toList();
    return (select(mealPlanRecipesTable)
          ..where((t) => t.mealPlanId.isIn(planIds)))
        .get();
  }

  /// Upserts a meal plan recipe slot — alias for addRecipeToPlan.
  Future<int> upsertSlot(MealPlanRecipesTableCompanion slot) =>
      addRecipeToPlan(slot);
}
