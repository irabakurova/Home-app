import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart';
import '../providers/meal_plan_provider.dart';
import '../widgets/day_card.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rangeLength = ref.watch(plannerRangeLengthProvider);
    final weekOffset = ref.watch(plannerWeekOffsetProvider);
    final startDate = ref.watch(plannerStartDateProvider);
    final endDate = ref.watch(plannerEndDateProvider);
    final daysAsync = ref.watch(mealPlanDaysProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Планировщик меню'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              // ── Range toggle ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 7, label: Text('Неделя')),
                    ButtonSegment(value: 14, label: Text('2 недели')),
                  ],
                  selected: {rangeLength},
                  onSelectionChanged: (set) {
                    ref.read(plannerRangeLengthProvider.notifier).state =
                        set.first;
                    ref.read(plannerWeekOffsetProvider.notifier).state = 0;
                  },
                  style: SegmentedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Week navigation ──────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => ref
                          .read(plannerWeekOffsetProvider.notifier)
                          .state = weekOffset - 1,
                    ),
                    Text(
                      _rangeLabel(startDate, endDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        if (weekOffset != 0)
                          TextButton(
                            onPressed: () => ref
                                .read(plannerWeekOffsetProvider.notifier)
                                .state = 0,
                            child: const Text('Сегодня'),
                          ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => ref
                              .read(plannerWeekOffsetProvider.notifier)
                              .state = weekOffset + 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: daysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (days) => ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 88),
          itemCount: days.length,
          itemBuilder: (context, i) => DayCard(
            key: ValueKey(days[i].date),
            day: days[i],
            onAddRecipe: (date, mealType) =>
                _showRecipePicker(context, ref, date, mealType),
          ),
        ),
      ),
      // Quick-add FAB always visible — opens picker for today's dinner
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final today = DateTime.now().dateOnly;
          _showRecipePicker(context, ref, today, MealType.dinner);
        },
        tooltip: 'Добавить блюдо на сегодня',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _rangeLabel(DateTime start, DateTime end) {
    final startStr =
        '${start.day} ${_monthShort(start.month)}';
    final endStr = '${end.day} ${_monthShort(end.month)}';
    if (start.year != end.year) {
      return '$startStr ${start.year} — $endStr ${end.year}';
    }
    return '$startStr — $endStr ${start.year}';
  }

  static String _monthShort(int m) {
    const n = ['', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
                'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    return n[m];
  }

  void _showRecipePicker(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    MealType mealType,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _RecipePickerSheet(
        date: date,
        mealType: mealType,
      ),
    );
  }
}

// ── Recipe picker bottom sheet ────────────────────────────────────────────────

class _RecipePickerSheet extends ConsumerStatefulWidget {
  const _RecipePickerSheet({
    required this.date,
    required this.mealType,
  });

  final DateTime date;
  final MealType mealType;

  @override
  ConsumerState<_RecipePickerSheet> createState() =>
      _RecipePickerSheetState();
}

class _RecipePickerSheetState extends ConsumerState<_RecipePickerSheet> {
  String _query = '';
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesStreamProvider);
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollCtrl) {
        return Column(
          children: [
            // Handle
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Добавить в ${widget.mealType.label.toLowerCase()} '
                      '(${widget.date.day} ${_monthShort(widget.date.month)})',
                      style: textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                autofocus: false,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Поиск рецептов…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _query = ''),
                        )
                      : null,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
            ),

            // Recipe list
            Expanded(
              child: recipesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка: $e')),
                data: (allRecipes) {
                  final filtered = _query.trim().isEmpty
                      ? allRecipes
                      : allRecipes
                          .where((r) => r.title
                              .toLowerCase()
                              .contains(_query.trim().toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Рецепты не найдены',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollCtrl,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _RecipePickerTile(
                      recipe: filtered[i],
                      adding: _adding,
                      onTap: () => _addRecipe(filtered[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addRecipe(Recipe recipe) async {
    if (_adding) return;
    setState(() => _adding = true);
    try {
      await ref.read(mealPlanNotifierProvider.notifier).addRecipe(
            date: widget.date,
            mealType: widget.mealType,
            recipeId: recipe.id,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  static String _monthShort(int m) {
    const n = ['', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
                'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    return n[m];
  }
}

class _RecipePickerTile extends StatelessWidget {
  const _RecipePickerTile({
    required this.recipe,
    required this.adding,
    required this.onTap,
  });

  final Recipe recipe;
  final bool adding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(recipe.title),
      subtitle: Text(
        '${recipe.cookTimeMinutes} мин · ${recipe.defaultServings} порции',
        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.restaurant,
            color: colors.onPrimaryContainer, size: 22),
      ),
      trailing: adding
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(Icons.add_circle_outline, color: colors.primary),
      onTap: adding ? null : onTap,
    );
  }
}
