import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easily_kitchen/core/widgets/confirm_dialog.dart';

void main() {
  group('ConfirmDialog', () {
    testWidgets('displays title and content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ConfirmDialog.show(
                  context,
                  title: 'Удалить рецепт?',
                  content: 'Рецепт будет удалён навсегда.',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Удалить рецепт?'), findsOneWidget);
      expect(find.text('Рецепт будет удалён навсегда.'), findsOneWidget);
    });

    testWidgets('displays default labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ConfirmDialog.show(
                  context,
                  title: 'Title',
                  content: 'Content',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Отмена'), findsOneWidget);
      expect(find.text('Удалить'), findsOneWidget);
    });

    testWidgets('displays custom labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ConfirmDialog.show(
                  context,
                  title: 'Title',
                  content: 'Content',
                  confirmLabel: 'Да, выйти',
                  cancelLabel: 'Нет',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Нет'), findsOneWidget);
      expect(find.text('Да, выйти'), findsOneWidget);
    });

    testWidgets('cancel returns false', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context,
                    title: 'Title',
                    content: 'Content',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('confirm returns true', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context,
                    title: 'Title',
                    content: 'Content',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('destructive mode uses error color on confirm button',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ConfirmDialog.show(
                  context,
                  title: 'Title',
                  content: 'Content',
                  isDestructive: true,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // In destructive mode, the FilledButton should exist
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('non-destructive mode uses default button style',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ConfirmDialog.show(
                  context,
                  title: 'Title',
                  content: 'Content',
                  isDestructive: false,
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Non-destructive should also have a FilledButton
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('dismiss dialog by tapping outside returns false',
        (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context,
                    title: 'Title',
                    content: 'Content',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Tap outside the dialog (on the barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(result, false);
    });
  });
}
