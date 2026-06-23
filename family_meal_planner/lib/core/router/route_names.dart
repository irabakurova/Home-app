class RouteNames {
  RouteNames._();

  static const splash = 'splash';
  static const auth = 'auth';
  static const home = 'home';

  // Recipes
  static const recipes = 'recipes';
  static const recipeDetail = 'recipe-detail';
  static const recipeNew = 'recipe-new';
  static const recipeEdit = 'recipe-edit';
  static const cookingMode = 'cooking-mode';

  // Pantry
  static const pantry = 'pantry';
  static const pantryItemNew = 'pantry-item-new';
  static const pantryItemEdit = 'pantry-item-edit';

  // Planner
  static const planner = 'planner';

  // Shopping
  static const shopping = 'shopping';

  // Favorites
  static const favorites = 'favorites';

  // History
  static const history = 'history';

  // Recipe generator
  static const recipeGenerator = 'recipe-generator';

  // Settings
  static const settings = 'settings';
  static const categories = 'categories';
}

class RoutePaths {
  RoutePaths._();

  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';

  static const recipes = '/home/recipes';
  static const recipeNew = '/home/recipes/new';
  static String recipeDetail(String id) => '/home/recipes/$id';
  static String recipeEdit(String id) => '/home/recipes/$id/edit';
  static String cookingMode(String id) => '/home/recipes/$id/cook';

  static const pantry = '/home/pantry';
  static const pantryItemNew = '/home/pantry/new';
  static String pantryItemEdit(String id) => '/home/pantry/$id/edit';

  static const planner = '/home/planner';
  static const shopping = '/home/shopping';
  static const favorites = '/home/favorites';
  static const history = '/history';
  static const recipeGenerator = '/recipe-generator';
  static const settings = '/settings';
  static const categories = '/settings/categories';
}
