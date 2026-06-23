import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easily_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:easily_kitchen/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:easily_kitchen/features/settings/domain/entities/app_category.dart';
import 'package:easily_kitchen/features/settings/presentation/providers/categories_provider.dart';

void main() {
  Recipe _recipe({
    String title = 'Борщ',
    String category = 'hot_dish',
    int cookTimeMinutes = 60,
    bool isFavorite = false,
  }) {
    return Recipe(
      id: 'r1',
      familyId: 'f1',
      title: title,
      category: category,
      cuisine: 'russian',
      cookTimeMinutes: cookTimeMinutes,
      defaultServings: 4,
      instructions: const ['Step 1'],
      isFavorite: isFavorite,
      createdBy: 'user1',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  AppCategory _category({
    String name = 'Горячее блюдо',
    String value = 'hot_dish',
  }) {
    return AppCategory(
      id: 'c1',
      familyId: 'f1',
      type: 'recipe',
      name: name,
      value: value,
      isSystem: true,
      sortOrder: 0,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  Widget buildWidget({
    Recipe? recipe,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<AppCategory>? categories,
  }) {
    final cats = categories ?? [_category()];
    return ProviderScope(
      overrides: [
        recipeCategoriesProvider.overrideWith(
          (ref) => Stream<List<AppCategory>>.fromIterable([cats]),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: RecipeCard(
            recipe: recipe ?? _recipe(),
            onTap: onTap ?? () {},
            onFavoriteToggle: onFavoriteToggle ?? () {},
          ),
        ),
      ),
    );
  }

  group('RecipeCard', () {
    testWidgets('displays recipe title', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Борщ'), findsOneWidget);
    });

    testWidgets('displays cook time', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('60 мин'), findsOneWidget);
    });

    testWidgets('displays category name from provider', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump(); // let stream emit
      expect(find.text('Горячее блюдо'), findsOneWidget);
    });

    testWidgets('falls back to category slug when loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recipeCategoriesProvider.overrideWith(
              (ref) => const Stream<List<AppCategory>>.empty(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: RecipeCard(
                recipe: _recipe(category: 'salad'),
                onTap: () {},
                onFavoriteToggle: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show the slug as fallback
      expect(find.text('salad'), findsOneWidget);
    });

    testWidgets('shows unfilled heart when not favorite', (tester) async {
      await tester.pumpWidget(buildWidget(recipe: _recipe(isFavorite: false)));
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    });

    testWidgets('shows filled heart when favorite', (tester) async {
      await tester.pumpWidget(buildWidget(recipe: _recipe(isFavorite: true)));
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    });

    testWidgets('calls onTap when card tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildWidget(onTap: () => tapped = true),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('calls onFavoriteToggle when heart tapped', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        buildWidget(onFavoriteToggle: () => toggled = true),
      );

      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      expect(toggled, isTrue);
    });

    testWidgets('renders within a Card', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays restaurant icon in header', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });
  });
}
