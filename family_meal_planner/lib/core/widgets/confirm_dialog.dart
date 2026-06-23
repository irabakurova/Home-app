import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmLabel = 'Удалить',
    this.cancelLabel = 'Отмена',
    this.isDestructive = true,
  });

  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = 'Удалить',
    String cancelLabel = 'Отмена',
    bool isDestructive = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: scheme.error)
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
