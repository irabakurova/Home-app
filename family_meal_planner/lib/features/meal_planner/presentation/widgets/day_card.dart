import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../domain/entities/meal_plan_entry.dart';
import '../providers/meal_plan_provider.dart';

class DayCard extends ConsumerWidget {
  const DayCard({
    super.key,
    required this.day,
    required this.onAddRecipe,
  });

  final MealPlanDay day;

  /// Called when user taps "+ Добавить" for a meal slot.
  /// Receives the date and meal type to add to.
  final void Function(DateTime date, MealType mealType) onAddRecipe;

  bool get _isToday {
    final now = DateTime.now();
    return day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Day header ───────────────────────────────────────────────────
          Container(
            color: _isToday
                ? colors.primaryContainer
                : colors.surfaceContainerHighest,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text(
                  day.date.russianWeekday,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isToday
                        ? colors.onPrimaryContainer
                        : colors.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${day.date.day} ${_monthShort(day.date.month)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _isToday
                        ? colors.onPrimaryContainer
                        : colors.onSurfaceVariant,
                  ),
                ),
                if (_isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Сегодня',
                      style: textTheme.labelSmall?.copyWith(
                          color: colors.onPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Meal slots ───────────────────────────────────────────────────
          ...MealType.values.map((mealType) {
            final entry = day.entryFor(mealType);
            return _MealSlot(
              date: day.date,
              mealType: mealType,
              entry: entry,
              onAdd: () => onAddRecipe(day.date, mealType),
            );
          }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  static String _monthShort(int month) {
    const names = [
      '', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
    ];
    return names[month];
  }
}

// ── Meal slot section ─────────────────────────────────────────────────────────

class _MealSlot extends ConsumerWidget {
  const _MealSlot({
    required this.date,
    required this.mealType,
    required this.entry,
    required this.onAdd,
  });

  final DateTime date;
  final MealType mealType;
  final MealPlanEntry? entry;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final recipes = entry?.recipes ?? [];

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal type label
          SizedBox(
            width: 72,
            child: Text(
              mealType.label,
              style: textTheme.labelMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),

          // Recipe chips + add button
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...recipes.map((recipe) => _RecipeChip(
                      recipe: recipe,
                      entry: entry!,
                      onRemove: () {
                        // Find the mealPlanRecipeId for this recipe in this entry
                        // We pass the mealPlanId and recipeId; repository will handle
                        _removeRecipe(ref, context, recipe);
                      },
                    )),
                // Add button
                ActionChip(
                  avatar: Icon(Icons.add,
                      size: 16, color: colors.onSecondaryContainer),
                  label: const Text('Добавить'),
                  backgroundColor: colors.secondaryContainer,
                  labelStyle:
                      TextStyle(color: colors.onSecondaryContainer),
                  onPressed: onAdd,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeRecipe(WidgetRef ref, BuildContext context, Recipe recipe) {
    if (entry == null) return;
    // We need the mealPlanRecipeId — for now we use removeSlot if only one recipe,
    // or remove the entire slot. Full per-recipe removal requires passing the
    // join-table row id down from the repository.
    // Since the repository doesn't expose mealPlanRecipeIds in MealPlanEntry,
    // we remove the entire slot when a recipe is removed (simpler UX for now).
    // TODO Stage 8: expose individual recipe IDs for granular removal.
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Убрать блюдо?'),
        content: Text(
            '«${recipe.title}» будет удалено из ${mealType.label.toLowerCase()}.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отмена')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Удалить')),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && entry != null) {
        ref.read(mealPlanNotifierProvider.notifier).removeSlot(entry!.id);
      }
    });
  }
}

// ── Recipe chip ───────────────────────────────────────────────────────────────

class _RecipeChip extends StatelessWidget {
  const _RecipeChip({
    required this.recipe,
    required this.entry,
    required this.onRemove,
  });

  final Recipe recipe;
  final MealPlanEntry entry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Chip(
      label: Text(
        recipe.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      deleteIcon: Icon(Icons.close, size: 14, color: colors.onSurface),
      onDeleted: onRemove,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
