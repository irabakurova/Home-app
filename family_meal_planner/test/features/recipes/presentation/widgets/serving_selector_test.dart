import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easily_kitchen/core/constants/app_constants.dart';
import 'package:easily_kitchen/features/recipes/presentation/widgets/serving_selector.dart';

void main() {
  Widget buildWidget({
    int servings = 4,
    ValueChanged<int>? onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ServingSelector(
          servings: servings,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    );
  }

  group('ServingSelector', () {
    testWidgets('displays current serving count', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 4));

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('displays "человека" for 2-4 servings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 3));
      expect(find.text('человека'), findsOneWidget);

      await tester.pumpWidget(buildWidget(servings: 2));
      expect(find.text('человека'), findsOneWidget);

      await tester.pumpWidget(buildWidget(servings: 4));
      expect(find.text('человека'), findsOneWidget);
    });

    testWidgets('displays "человек" for 1 serving', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 1));
      expect(find.text('человек'), findsOneWidget);
    });

    testWidgets('displays "человек" for 5+ servings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 5));
      expect(find.text('человек'), findsOneWidget);

      await tester.pumpWidget(buildWidget(servings: 10));
      expect(find.text('человек'), findsOneWidget);
    });

    testWidgets('calls onChanged with decremented value when minus tapped',
        (tester) async {
      int? result;
      await tester.pumpWidget(
        buildWidget(servings: 4, onChanged: (v) => result = v),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(result, 3);
    });

    testWidgets('calls onChanged with incremented value when plus tapped',
        (tester) async {
      int? result;
      await tester.pumpWidget(
        buildWidget(servings: 4, onChanged: (v) => result = v),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(result, 5);
    });

    testWidgets('minus button is disabled at minServings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: AppConstants.minServings));

      final minusIconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.remove),
          matching: find.byType(IconButton),
        ),
      );
      expect(minusIconButton.onPressed, isNull);
    });

    testWidgets('plus button is disabled at maxServings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: AppConstants.maxServings));

      final plusIconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.add),
          matching: find.byType(IconButton),
        ),
      );
      expect(plusIconButton.onPressed, isNull);
    });

    testWidgets('minus button enabled above minServings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 2));

      final minusIconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.remove),
          matching: find.byType(IconButton),
        ),
      );
      expect(minusIconButton.onPressed, isNotNull);
    });

    testWidgets('plus button enabled below maxServings', (tester) async {
      await tester.pumpWidget(buildWidget(servings: 9));

      final plusIconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.add),
          matching: find.byType(IconButton),
        ),
      );
      expect(plusIconButton.onPressed, isNotNull);
    });

    testWidgets('renders within a Row layout', (tester) async {
      await tester.pumpWidget(buildWidget());

      // Should have minus, number, plus in a row
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
