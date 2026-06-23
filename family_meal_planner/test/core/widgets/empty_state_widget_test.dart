import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easily_kitchen/core/widgets/empty_state_widget.dart';

void main() {
  Widget buildWidget({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? action,
    String? actionLabel,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EmptyStateWidget(
          icon: icon,
          title: title,
          subtitle: subtitle,
          action: action,
          actionLabel: actionLabel,
        ),
      ),
    );
  }

  group('EmptyStateWidget', () {
    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(
        buildWidget(icon: Icons.menu_book, title: 'Нет рецептов'),
      );

      expect(find.text('Нет рецептов'), findsOneWidget);
    });

    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(
        buildWidget(icon: Icons.menu_book, title: 'Пусто'),
      );

      expect(find.byIcon(Icons.menu_book), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          icon: Icons.menu_book,
          title: 'Пусто',
          subtitle: 'Добавьте первый рецепт',
        ),
      );

      expect(find.text('Добавьте первый рецепт'), findsOneWidget);
    });

    testWidgets('hides subtitle when not provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(icon: Icons.menu_book, title: 'Пусто'),
      );

      expect(find.byType(Text), findsNWidgets(1)); // only title
    });

    testWidgets('displays action button when provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          icon: Icons.menu_book,
          title: 'Пусто',
          action: () {},
          actionLabel: 'Добавить',
        ),
      );

      expect(find.text('Добавить'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('hides action button when not provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(icon: Icons.menu_book, title: 'Пусто'),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('action button calls callback when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildWidget(
          icon: Icons.menu_book,
          title: 'Пусто',
          action: () => tapped = true,
          actionLabel: 'Добавить',
        ),
      );

      await tester.tap(find.byType(FilledButton));
      expect(tapped, isTrue);
    });

    testWidgets('centered layout', (tester) async {
      await tester.pumpWidget(
        buildWidget(icon: Icons.menu_book, title: 'Пусто'),
      );

      // Should be wrapped in Center (there may be other Centers from Scaffold)
      expect(find.byType(Center), findsWidgets);
    });
  });
}
