import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/quantity_calculator.dart';
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipes_provider.dart';
import '../widgets/serving_selector.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  int _servings = 4;
  bool _servingsInitialized = false;

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeByIdProvider(widget.recipeId));
    final ingredientsAsync =
        ref.watch(recipeIngredientsProvider(widget.recipeId));

    return recipeAsync.when(
      data: (recipe) {
        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Рецепт не найден')),
          );
        }
        // Set default servings once
        if (!_servingsInitialized) {
          _servings = recipe.defaultServings;
          _servingsInitialized = true;
        }
        return _buildBody(context, recipe, ingredientsAsync);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Ошибка: $e')),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Recipe recipe,
    AsyncValue<List<Ingredient>> ingredientsAsync,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Resolve category/cuisine display names from DB
    final recipeCats = ref.watch(recipeCategoriesProvider);
    final cuisineCats = ref.watch(cuisineCategoriesProvider);
    final categoryName = recipeCats.whenOrNull(
          data: (cats) => cats
              .where((c) => c.value == recipe.category)
              .map((c) => c.name)
              .firstOrNull,
        ) ??
        recipe.category;
    final cuisineName = cuisineCats.whenOrNull(
          data: (cats) => cats
              .where((c) => c.value == recipe.cuisine)
              .map((c) => c.name)
              .firstOrNull,
        ) ??
        recipe.cuisine;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image + app bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.title,
                style: const TextStyle(
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
              background: Container(
                color: colors.primaryContainer,
                child: Icon(Icons.restaurant,
                    size: 80, color: colors.onPrimaryContainer),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? colors.error : null,
                ),
                onPressed: () => ref
                    .read(recipeRepositoryProvider)
                    .toggleFavorite(recipe.id, !recipe.isFavorite),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.pushNamed(
                  RouteNames.recipeEdit,
                  pathParameters: {'id': recipe.id},
                ),
              ),
              _DeleteButton(recipe: recipe),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                          icon: Icons.label_outline,
                          label: categoryName),
                      _InfoChip(
                          icon: Icons.public, label: cuisineName),
                      _InfoChip(
                          icon: Icons.timer_outlined,
                          label: '${recipe.cookTimeMinutes} мин'),
                      _InfoChip(
                          icon: Icons.people_outline,
                          label: '${recipe.defaultServings} порции'),
                    ],
                  ),

                  if (recipe.description != null &&
                      recipe.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(recipe.description!,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colors.onSurfaceVariant)),
                  ],

                  const SizedBox(height: 24),

                  // Serving selector
                  Row(
                    children: [
                      Text('Порций:', style: textTheme.titleMedium),
                      const SizedBox(width: 16),
                      ServingSelector(
                        servings: _servings,
                        onChanged: (v) => setState(() => _servings = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Ingredients
                  Text('Ингредиенты',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  ingredientsAsync.when(
                    data: (ingredients) => _IngredientsList(
                      ingredients: ingredients,
                      defaultServings: recipe.defaultServings,
                      targetServings: _servings,
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('Ошибка: $e'),
                  ),

                  const SizedBox(height: 24),

                  // Instructions
                  if (recipe.instructions.isNotEmpty) ...[
                    Text('Приготовление',
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...recipe.instructions.asMap().entries.map(
                          (e) => _InstructionStep(
                              step: e.key + 1, text: e.value),
                        ),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Cook button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          RouteNames.cookingMode,
          pathParameters: {'id': recipe.id},
        ),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Начать готовить'),
      ),
    );
  }
}

// ── Ingredients list ──────────────────────────────────────────────────────────

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({
    required this.ingredients,
    required this.defaultServings,
    required this.targetServings,
  });

  final List<Ingredient> ingredients;
  final int defaultServings;
  final int targetServings;

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Text('Нет ингредиентов',
          style: TextStyle(color: Colors.grey));
    }
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: ingredients.asMap().entries.map((e) {
          final ing = e.value.scale(defaultServings, targetServings);
          final isLast = e.key == ingredients.length - 1;
          return Column(
            children: [
              ListTile(
                dense: true,
                title: Text(ing.name),
                trailing: Text(
                  QuantityCalculator.formatWithUnit(ing.quantity, ing.unit),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Instruction step ──────────────────────────────────────────────────────────

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({required this.step, required this.text});

  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info chip ─────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 13, color: colors.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

// ── Delete button ─────────────────────────────────────────────────────────────

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Удалить рецепт?'),
            content: Text('«${recipe.title}» будет удалён без возможности восстановления.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Удалить'),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          await ref.read(recipeRepositoryProvider).delete(recipe.id);
          if (context.mounted) context.pop();
        }
      },
    );
  }
}
