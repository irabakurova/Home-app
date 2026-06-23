import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/presentation/providers/recipes_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          favoritesAsync.whenOrNull(
            data: (list) => list.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Center(
                      child: Chip(
                        label: Text('${list.length}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  )
                : null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (recipes) {
          if (recipes.isEmpty) {
            return _EmptyFavoritesState(
              onBrowse: () => context.goNamed(RouteNames.recipes),
            );
          }
          return _FavoritesList(recipes: recipes);
        },
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border,
                size: 72, color: colors.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(
              'Нет избранных рецептов',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Открывайте любой рецепт и нажимайте ♡ чтобы добавить его сюда.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onBrowse,
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Перейти к рецептам'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favorites list ────────────────────────────────────────────────────────────

class _FavoritesList extends ConsumerWidget {
  const _FavoritesList({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, i) => _FavoritesTile(recipe: recipes[i]),
    );
  }
}

// ── Single tile ───────────────────────────────────────────────────────────────

class _FavoritesTile extends ConsumerWidget {
  const _FavoritesTile({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(recipe.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.errorContainer,
        child: Icon(Icons.heart_broken_outlined, color: colors.onErrorContainer),
      ),
      confirmDismiss: (_) => _confirmRemove(context, recipe.title),
      onDismissed: (_) {
        ref
            .read(recipeRepositoryProvider)
            .toggleFavorite(recipe.id, false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('«${recipe.title}» удалён из избранного'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Отмена',
              onPressed: () => ref
                  .read(recipeRepositoryProvider)
                  .toggleFavorite(recipe.id, true),
            ),
          ),
        );
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          child: Icon(Icons.restaurant,
              color: colors.onPrimaryContainer, size: 20),
        ),
        title: Text(
          recipe.title,
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _RecipeSubtitle(recipe: recipe),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick un-favourite button
            IconButton(
              icon: const Icon(Icons.favorite, size: 20),
              color: colors.error,
              tooltip: 'Убрать из избранного',
              onPressed: () async {
                final confirmed =
                    await _confirmRemove(context, recipe.title);
                if (confirmed == true) {
                  ref
                      .read(recipeRepositoryProvider)
                      .toggleFavorite(recipe.id, false);
                }
              },
            ),
            Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
          ],
        ),
        onTap: () => context.pushNamed(
          RouteNames.recipeDetail,
          pathParameters: {'id': recipe.id},
        ),
      ),
    );
  }

  Future<bool?> _confirmRemove(BuildContext context, String title) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Убрать из избранного?'),
          content: Text('«$title» будет удалён из избранного.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Убрать'),
            ),
          ],
        ),
      );
}

// ── Subtitle ──────────────────────────────────────────────────────────────────

class _RecipeSubtitle extends StatelessWidget {
  const _RecipeSubtitle({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final parts = <String>[];
    if (recipe.cookTimeMinutes > 0) {
      parts.add('${recipe.cookTimeMinutes} мин');
    }
    parts.add('${recipe.defaultServings} порц.');

    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 13, color: colors.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          parts.join(' · '),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
