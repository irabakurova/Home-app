import 'package:drift/drift.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/meal_plan_dao.dart';
import '../../../../core/database/daos/recipes_dao.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../recipes/data/models/recipe_mapper.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../domain/entities/meal_plan_entry.dart';
import '../../domain/repositories/meal_plan_repository.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  MealPlanRepositoryImpl(this._dao, this._recipesDao);

  final MealPlanDao _dao;
  final RecipesDao _recipesDao;

  // ── Watch range ───────────────────────────────────────────────────────────

  @override
  Stream<List<MealPlanEntry>> watchRange(
      String familyId, DateTime start, DateTime end) {
    final from = _dayMs(start);
    final to = _dayMs(end);

    return _dao.watchRange(familyId, from, to).asyncMap((plans) async {
      return _resolveEntries(plans);
    });
  }

  // ── Get range (one-shot) ──────────────────────────────────────────────────

  @override
  Future<List<MealPlanEntry>> getRange(
      String familyId, DateTime start, DateTime end) async {
    final plans = await _dao.getRange(familyId, _dayMs(start), _dayMs(end));
    return _resolveEntries(plans);
  }

  // ── Add recipe to slot ────────────────────────────────────────────────────

  @override
  Future<void> addRecipeToSlot({
    required String familyId,
    required DateTime date,
    required MealType mealType,
    required String recipeId,
    int servings = 4,
  }) async {
    final dayMs = _dayMs(date);
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Find or create the plan slot
    var plan = await _dao.getPlanByDateAndType(
        familyId, dayMs, mealType.value);

    String planId;
    if (plan == null) {
      planId = UuidGenerator.generate();
      await _dao.upsertPlan(MealPlansTableCompanion(
        id: Value(planId),
        familyId: Value(familyId),
        planDate: Value(dayMs),
        mealType: Value(mealType.value),
        servings: Value(servings),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));
    } else {
      planId = plan.id;
    }

    // 2. Get current recipes to determine sort order
    final existing = await _dao.getRecipesForPlan(planId);

    // 3. Add the recipe (idempotent — skip if already in this slot)
    final alreadyAdded = existing.any((r) => r.recipeId == recipeId);
    if (alreadyAdded) return;

    await _dao.addRecipeToPlan(MealPlanRecipesTableCompanion(
      id: Value(UuidGenerator.generate()),
      mealPlanId: Value(planId),
      recipeId: Value(recipeId),
      sortOrder: Value(existing.length),
    ));
  }

  // ── Remove recipe from slot ───────────────────────────────────────────────

  @override
  Future<void> removeRecipeFromSlot(String mealPlanRecipeId) async {
    await _dao.removeRecipeFromPlan(mealPlanRecipeId);
    // Note: we intentionally leave the empty plan slot in place to keep the
    // date structure stable (the UI shows empty slots as placeholders).
  }

  // ── Remove entire slot ────────────────────────────────────────────────────

  @override
  Future<void> removeSlot(String mealPlanId) async {
    // Cascade delete handles meal_plan_recipes via FK onDelete: cascade
    await _dao.deletePlan(mealPlanId);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Converts a DateTime to start-of-day milliseconds for DB storage.
  int _dayMs(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;

  /// Resolves a list of DB plan rows into domain [MealPlanEntry] objects
  /// by loading recipe details for each plan.
  Future<List<MealPlanEntry>> _resolveEntries(
      List<MealPlansTableData> plans) async {
    final entries = <MealPlanEntry>[];
    for (final plan in plans) {
      final recipeRows = await _dao.getRecipesForPlan(plan.id);
      final recipes = <Recipe>[];
      for (final row in recipeRows) {
        final recipeData = await _recipesDao.getById(row.recipeId);
        if (recipeData != null) {
          recipes.add(RecipeMapper.fromDb(recipeData));
        }
      }
      entries.add(MealPlanEntry(
        id: plan.id,
        familyId: plan.familyId,
        date: DateTime.fromMillisecondsSinceEpoch(plan.planDate),
        mealType: MealType.fromValue(plan.mealType),
        servings: plan.servings,
        recipes: recipes,
      ));
    }
    return entries;
  }
}
