import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/recipe_generator/presentation/screens/recipe_generator_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/meal_planner/presentation/screens/meal_planner_screen.dart';
import '../../features/pantry/presentation/screens/pantry_item_form_screen.dart';
import '../../features/pantry/presentation/screens/pantry_screen.dart';
import '../../features/recipes/presentation/screens/cooking_mode_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/recipe_form_screen.dart';
import '../../features/recipes/presentation/screens/recipes_screen.dart';
import '../../features/settings/presentation/screens/categories_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shopping/presentation/screens/shopping_list_screen.dart';
import '../widgets/app_shell.dart';
import 'go_router_refresh_stream.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.recipes,
  debugLogDiagnostics: true,

  // Redirect unauthenticated users to /auth; redirect authenticated users
  // away from /auth to the main screen.
  redirect: (BuildContext context, GoRouterState state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isOnAuthPage = state.matchedLocation == RoutePaths.auth;

    if (!isLoggedIn && !isOnAuthPage) return RoutePaths.auth;
    if (isLoggedIn && isOnAuthPage) return RoutePaths.recipes;
    return null; // No redirect needed.
  },

  // Re-evaluate redirect whenever auth state changes.
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  routes: [
    // Auth
    GoRoute(
      path: RoutePaths.auth,
      name: RouteNames.auth,
      builder: (context, state) => const AuthScreen(),
    ),

    // Main shell with bottom nav / nav rail
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.recipes,
          name: RouteNames.recipes,
          builder: (context, state) => const RecipesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              name: RouteNames.recipeNew,
              builder: (context, state) => const RecipeFormScreen(),
            ),
            GoRoute(
              path: ':id',
              name: RouteNames.recipeDetail,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return RecipeDetailScreen(recipeId: id);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  name: RouteNames.recipeEdit,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return RecipeFormScreen(recipeId: id);
                  },
                ),
                GoRoute(
                  path: 'cook',
                  name: RouteNames.cookingMode,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return CookingModeScreen(recipeId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.pantry,
          name: RouteNames.pantry,
          builder: (context, state) => const PantryScreen(),
          routes: [
            GoRoute(
              path: 'new',
              name: RouteNames.pantryItemNew,
              builder: (context, state) => const PantryItemFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              name: RouteNames.pantryItemEdit,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return PantryItemFormScreen(itemId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.planner,
          name: RouteNames.planner,
          builder: (context, state) => const MealPlannerScreen(),
        ),
        GoRoute(
          path: RoutePaths.shopping,
          name: RouteNames.shopping,
          builder: (context, state) => const ShoppingListScreen(),
        ),
        GoRoute(
          path: RoutePaths.favorites,
          name: RouteNames.favorites,
          builder: (context, state) => const FavoritesScreen(),
        ),
      ],
    ),

    // Full-screen routes (no shell)
    GoRoute(
      path: RoutePaths.history,
      name: RouteNames.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: RoutePaths.recipeGenerator,
      name: RouteNames.recipeGenerator,
      builder: (context, state) => const RecipeGeneratorScreen(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'categories',
          name: RouteNames.categories,
          builder: (context, state) => const CategoriesScreen(),
        ),
      ],
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Страница не найдена: ${state.error}'),
    ),
  ),
);
