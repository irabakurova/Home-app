import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// A compact +/- row for changing serving count.
class ServingSelector extends StatelessWidget {
  const ServingSelector({
    super.key,
    required this.servings,
    required this.onChanged,
  });

  final int servings;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            iconSize: 18,
            onPressed: servings > AppConstants.minServings
                ? () => onChanged(servings - 1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$servings',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _personLabel(servings),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 18,
            onPressed: servings < AppConstants.maxServings
                ? () => onChanged(servings + 1)
                : null,
          ),
        ],
      ),
    );
  }

  static String _personLabel(int n) {
    if (n == 1) return 'человек';
    if (n >= 2 && n <= 4) return 'человека';
    return 'человек';
  }
}
