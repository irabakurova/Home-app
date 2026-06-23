import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/quantity_calculator.dart';
import '../../domain/entities/recipe_suggestion.dart';
import '../providers/recipe_generator_provider.dart';

class RecipeGeneratorScreen extends ConsumerWidget {
  const RecipeGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredSuggestionsProvider);
    final filter = ref.watch(suggestionFilterProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Что можно приготовить?'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: () =>
                ref.invalidate(rawSuggestionsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter chips ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  _FilterChip(
                    label: 'Все',
                    selected: filter == SuggestionFilter.all,
                    onTap: () => ref
                        .read(suggestionFilterProvider.notifier)
                        .state = SuggestionFilter.all,
                  ),
                  _FilterChip(
                    label: '≥75% ингредиентов',
                    selected: filter == SuggestionFilter.nearly,
                    onTap: () => ref
                        .read(suggestionFilterProvider.notifier)
                        .state = SuggestionFilter.nearly,
                  ),
                  _FilterChip(
                    label: 'Всё есть',
                    selected: filter == SuggestionFilter.full,
                    color: colors.primaryContainer,
                    onTap: () => ref
                        .read(suggestionFilterProvider.notifier)
                        .state = SuggestionFilter.full,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ── Results ──────────────────────────────────────────────────────
          Expanded(
            child: filtered.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (suggestions) {
                if (suggestions.isEmpty) {
                  return _EmptyState(filter: filter);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _SuggestionCard(suggestion: suggestions[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: color ?? colors.secondaryContainer,
      onSelected: (_) => onTap(),
    );
  }
}

// ── Suggestion card ───────────────────────────────────────────────────────────

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion});

  final RecipeSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pct = suggestion.matchPercent;
    final pctLabel = '${(pct * 100).round()}%';

    // Color the progress bar by match level
    final barColor = pct >= 1.0
        ? colors.primary
        : pct >= 0.75
            ? colors.secondary
            : colors.tertiary;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNamed(
          RouteNames.recipeDetail,
          pathParameters: {'id': suggestion.recipe.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      suggestion.recipe.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Match % badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: barColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: barColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      pctLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: barColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  backgroundColor:
                      colors.onSurface.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              // Available count
              Text(
                'Есть: ${suggestion.available.length} из '
                '${suggestion.available.length + suggestion.missing.length} '
                'ингредиентов',
                style: textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              // Missing ingredients (up to 3)
              if (suggestion.missing.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: suggestion.missing
                      .take(3)
                      .map((m) => _MissingChip(item: m))
                      .toList(),
                ),
                if (suggestion.missing.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+ ещё ${suggestion.missing.length - 3}',
                      style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Missing ingredient chip ───────────────────────────────────────────────────

class _MissingChip extends StatelessWidget {
  const _MissingChip({required this.item});

  final MissingIngredient item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final qty = QuantityCalculator.formatWithUnit(
        item.quantityNeeded, item.unit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${item.name} $qty',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onErrorContainer,
            ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final SuggestionFilter filter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (icon, title, subtitle) = switch (filter) {
      SuggestionFilter.full => (
          Icons.check_circle_outline,
          'Нет полных совпадений',
          'Пополните кладовую — и здесь появятся рецепты, для которых всё есть.',
        ),
      SuggestionFilter.nearly => (
          Icons.hourglass_empty,
          'Нет рецептов с ≥75%',
          'Добавьте больше продуктов в кладовую.',
        ),
      SuggestionFilter.all => (
          Icons.kitchen_outlined,
          'Кладовая пуста',
          'Добавьте продукты в кладовую, и система подберёт рецепты, которые можно приготовить прямо сейчас.',
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 72,
                color: colors.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
