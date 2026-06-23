import 'package:mockito/annotations.dart';
import 'package:easily_kitchen/core/database/daos/recipes_dao.dart';
import 'package:easily_kitchen/core/database/daos/pantry_dao.dart';
import 'package:easily_kitchen/core/database/daos/shopping_dao.dart';
import 'package:easily_kitchen/core/database/daos/history_dao.dart';
import 'package:easily_kitchen/features/meal_planner/domain/repositories/meal_plan_repository.dart';

@GenerateMocks([RecipesDao, PantryDao, ShoppingDao, HistoryDao, MealPlanRepository])
void main() {}
