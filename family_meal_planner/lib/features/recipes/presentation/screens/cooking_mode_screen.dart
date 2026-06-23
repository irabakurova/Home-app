import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/quantity_calculator.dart';
import '../../../history/domain/entities/cooking_history_entry.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipes_provider.dart';
import '../widgets/serving_selector.dart';

class CookingModeScreen extends ConsumerStatefulWidget {
  const CookingModeScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  int _step = 0;
  int _servings = 4;
  bool _servingsInitialized = false;
  bool _forceDark = false;

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeByIdProvider(widget.recipeId));
    final ingredientsAsync =
        ref.watch(recipeIngredientsProvider(widget.recipeId));

    return recipeAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Ошибка: $e')),
      ),
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Рецепт не найден')),
          );
        }
        if (!_servingsInitialized) {
          _servings = recipe.defaultServings;
          _servingsInitialized = true;
        }
        return ingredientsAsync.when(
          loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Ошибка: $e')),
          ),
          data: (ingredients) =>
              _buildScreen(context, recipe, ingredients),
        );
      },
    );
  }

  Widget _buildScreen(
      BuildContext context, Recipe recipe, List<Ingredient> ingredients) {
    final steps = recipe.instructions;
    final hasSteps = steps.isNotEmpty;
    final isLastStep = !hasSteps || _step >= steps.length - 1;

    // Theme override for cooking dark mode
    Widget body = _CookingBody(
      recipe: recipe,
      ingredients: ingredients,
      servings: _servings,
      step: _step,
      onServingsChanged: (v) => setState(() => _servings = v),
      onPrev: _step > 0 ? () => setState(() => _step--) : null,
      onNext: hasSteps && !isLastStep ? () => setState(() => _step++) : null,
      onMarkCooked: () => _confirmAndMarkCooked(context, recipe, ingredients),
    );

    if (_forceDark) {
      body = Theme(
        data: ThemeData.dark(useMaterial3: true),
        child: body,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _confirmExit(context);
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: _forceDark ? const Color(0xFF121212) : null,
        appBar: AppBar(
          backgroundColor: _forceDark ? const Color(0xFF1E1E1E) : null,
          foregroundColor: _forceDark ? Colors.white : null,
          title: Text(
            recipe.title,
            style: TextStyle(color: _forceDark ? Colors.white : null),
          ),
          actions: [
            // Dark mode toggle
            IconButton(
              icon: Icon(
                _forceDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: _forceDark ? Colors.amber : null,
              ),
              tooltip: _forceDark ? 'Светлая тема' : 'Тёмный режим готовки',
              onPressed: () => setState(() => _forceDark = !_forceDark),
            ),
            // Close (with confirmation)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Выйти из режима готовки',
              onPressed: () async {
                final shouldPop = await _confirmExit(context);
                if (shouldPop && context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: body,
      ),
    );
  }

  Future<bool> _confirmExit(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Выйти из режима готовки?'),
            content: const Text(
                'Блюдо не будет отмечено как приготовленное, продукты не будут списаны.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Остаться'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Выйти'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _confirmAndMarkCooked(
    BuildContext context,
    Recipe recipe,
    List<Ingredient> ingredients,
  ) async {
    final scaledIngredients = ingredients
        .map((ing) => ing.scale(recipe.defaultServings, _servings))
        .toList();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) =>
          _ConfirmCookDialog(recipe: recipe, scaledIngredients: scaledIngredients),
    );
    if (confirmed != true || !context.mounted) return;

    final notifier = ref.read(cookingNotifierProvider.notifier);
    final deductions = await notifier.markCooked(
      recipeId: recipe.id,
      recipeTitle: recipe.title,
      servingsCooked: _servings,
      scaledIngredients: scaledIngredients,
    );

    if (!context.mounted) return;

    final missingItems =
        deductions.where((d) => d.notInPantry || !d.wasFullyDeducted).toList();

    if (missingItems.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (_) => _DeductionWarningDialog(missingItems: missingItems),
      );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '«${recipe.title}» готово! $_servings ${_portionsLabel(_servings)} — продукты списаны.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  String _portionsLabel(int n) {
    if (n == 1) return 'порция';
    if (n >= 2 && n <= 4) return 'порции';
    return 'порций';
  }
}

// ── Main cooking body ─────────────────────────────────────────────────────────

class _CookingBody extends StatelessWidget {
  const _CookingBody({
    required this.recipe,
    required this.ingredients,
    required this.servings,
    required this.step,
    required this.onServingsChanged,
    required this.onPrev,
    required this.onNext,
    required this.onMarkCooked,
  });

  final Recipe recipe;
  final List<Ingredient> ingredients;
  final int servings;
  final int step;
  final ValueChanged<int> onServingsChanged;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onMarkCooked;

  @override
  Widget build(BuildContext context) {
    final steps = recipe.instructions;
    final hasSteps = steps.isNotEmpty;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Serving selector strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
            border: Border(
                bottom: BorderSide(color: colors.outlineVariant, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Порций:', style: textTheme.titleMedium),
              const SizedBox(width: 16),
              ServingSelector(
                servings: servings,
                onChanged: onServingsChanged,
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step card
                if (hasSteps) ...[
                  _StepCard(
                    currentStep: step,
                    totalSteps: steps.length,
                    stepText: steps[step],
                    onPrev: onPrev,
                    onNext: onNext,
                  ),
                  const SizedBox(height: 24),
                ],

                // Ingredients
                _IngredientsCard(
                  ingredients: ingredients,
                  defaultServings: recipe.defaultServings,
                  targetServings: servings,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Bottom bar with "Блюдо приготовлено"
        _MarkCookedBar(onMarkCooked: onMarkCooked),
      ],
    );
  }
}

// ── Step card ─────────────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.currentStep,
    required this.totalSteps,
    required this.stepText,
    required this.onPrev,
    required this.onNext,
  });

  final int currentStep;
  final int totalSteps;
  final String stepText;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step counter
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Шаг ${currentStep + 1} из $totalSteps',
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Step text (big)
            Text(
              stepText,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Prev / Next buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onPrev,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Назад'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward),
                    iconAlignment: IconAlignment.end,
                    label: const Text('Далее'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Ingredients card ──────────────────────────────────────────────────────────

class _IngredientsCard extends StatefulWidget {
  const _IngredientsCard({
    required this.ingredients,
    required this.defaultServings,
    required this.targetServings,
  });

  final List<Ingredient> ingredients;
  final int defaultServings;
  final int targetServings;

  @override
  State<_IngredientsCard> createState() => _IngredientsCardState();
}

class _IngredientsCardState extends State<_IngredientsCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.shopping_basket_outlined,
                      color: colors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Ингредиенты',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${widget.ingredients.length}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            ...widget.ingredients.asMap().entries.map((e) {
              final ing =
                  e.value.scale(widget.defaultServings, widget.targetServings);
              final isLast = e.key == widget.ingredients.length - 1;
              return Column(
                children: [
                  const Divider(height: 1),
                  ListTile(
                    dense: true,
                    title: Text(ing.name,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontSize: 16)),
                    trailing: Text(
                      QuantityCalculator.formatWithUnit(
                          ing.quantity, ing.unit),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (isLast) const SizedBox(height: 4),
                ],
              );
            }),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _MarkCookedBar extends StatelessWidget {
  const _MarkCookedBar({required this.onMarkCooked});

  final VoidCallback onMarkCooked;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              top: BorderSide(color: colors.outlineVariant, width: 0.5)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onMarkCooked,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              'Блюдо приготовлено',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colors.tertiary,
              foregroundColor: colors.onTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Confirm cook dialog ───────────────────────────────────────────────────────

class _ConfirmCookDialog extends StatelessWidget {
  const _ConfirmCookDialog({
    required this.recipe,
    required this.scaledIngredients,
  });

  final Recipe recipe;
  final List<Ingredient> scaledIngredients;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Отметить как приготовленное?'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Следующие продукты будут списаны со склада:',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: Column(
                  children: scaledIngredients.map((ing) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record,
                              size: 8),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ing.name)),
                          Text(
                            QuantityCalculator.formatWithUnit(
                                ing.quantity, ing.unit),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Отмена'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.check),
          label: const Text('Приготовлено!'),
        ),
      ],
    );
  }
}

// ── Deduction warning dialog ──────────────────────────────────────────────────

class _DeductionWarningDialog extends StatelessWidget {
  const _DeductionWarningDialog({required this.missingItems});

  final List<DeductionResult> missingItems;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded,
          color: colors.error, size: 32),
      title: const Text('Недостаточно на складе'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Часть продуктов не нашлась в кладовой или оказалась в недостаточном количестве:'),
            const SizedBox(height: 12),
            ...missingItems.map((d) {
              final label = d.notInPantry
                  ? '${d.ingredientName} — не найден в кладовой'
                  : '${d.ingredientName}: нужно '
                      '${QuantityCalculator.formatWithUnit(d.quantityNeeded, d.unit)}'
                      ', было '
                      '${QuantityCalculator.formatWithUnit(d.quantityDeducted, d.unit)}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline,
                        size: 16, color: colors.error),
                    const SizedBox(width: 6),
                    Expanded(child: Text(label)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Понятно'),
        ),
      ],
    );
  }
}
