import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipes_provider.dart';
import '../widgets/recipe_card.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecipes = ref.watch(filteredRecipesProvider);
    final searchQuery = ref.watch(recipeSearchQueryProvider);
    final categoryFilter = ref.watch(recipeCategoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchBar(
            value: searchQuery,
            onChanged: (q) =>
                ref.read(recipeSearchQueryProvider.notifier).state = q,
          ),
        ),
      ),
      body: Column(
        children: [
          _CategoryFilterRow(
            selected: categoryFilter,
            onSelected: (slug) =>
                ref.read(recipeCategoryFilterProvider.notifier).state = slug,
          ),
          Expanded(
            child: filteredRecipes.when(
              data: (recipes) => recipes.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.menu_book_outlined,
                      title: 'Нет рецептов',
                      subtitle: 'Нажмите «+» чтобы добавить первый рецепт',
                    )
                  : _RecipesGrid(recipes: recipes),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.recipeNew),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_SearchBar old) {
    super.didUpdateWidget(old);
    if (widget.value != _ctrl.text) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Поиск рецептов…',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: widget.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _ctrl.clear();
                    widget.onChanged('');
                  },
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
    );
  }
}

// ── Category filter chips ─────────────────────────────────────────────────────

class _CategoryFilterRow extends ConsumerWidget {
  const _CategoryFilterRow({required this.selected, required this.onSelected});

  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(recipeCategoriesProvider);

    return SizedBox(
      height: 44,
      child: categoriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (categories) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('Все'),
                selected: selected == null,
                onSelected: (_) => onSelected(null),
              ),
            ),
            ...categories.map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.name),
                  selected: selected == cat.value,
                  onSelected: (v) => onSelected(v ? cat.value : null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recipes grid ──────────────────────────────────────────────────────────────

class _RecipesGrid extends ConsumerWidget {
  const _RecipesGrid({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
            ? 3
            : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, i) {
        final recipe = recipes[i];
        return RecipeCard(
          recipe: recipe,
          onTap: () => context.pushNamed(
            RouteNames.recipeDetail,
            pathParameters: {'id': recipe.id},
          ),
          onFavoriteToggle: () => ref
              .read(recipeRepositoryProvider)
              .toggleFavorite(recipe.id, !recipe.isFavorite),
        );
      },
    );
  }
}
