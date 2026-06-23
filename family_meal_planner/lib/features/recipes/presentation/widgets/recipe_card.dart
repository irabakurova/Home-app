import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/recipe.dart';

class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Resolve display name for category slug from DB
    final categoriesAsync = ref.watch(recipeCategoriesProvider);
    final categoryName = categoriesAsync.whenOrNull(
          data: (cats) => cats
              .where((c) => c.value == recipe.category)
              .map((c) => c.name)
              .firstOrNull,
        ) ??
        recipe.category; // fallback to slug while loading

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo placeholder — compact warm header ───────────────────
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primaryContainer,
                    colors.secondaryContainer.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Subtle large icon as background texture
                  Positioned(
                    right: -8,
                    bottom: -8,
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: colors.onPrimaryContainer.withValues(alpha: 0.08),
                    ),
                  ),
                  // Centered icon
                  Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 28,
                      color: colors.onPrimaryContainer.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title row with favourite ──────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 2, 0),
                          child: Icon(
                            recipe.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 19,
                            color: recipe.isFavorite
                                ? colors.error
                                : colors.outlineVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // ── Meta chips ────────────────────────────────────────
                  Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: [
                      _MetaChip(
                        icon: Icons.label_rounded,
                        label: categoryName,
                        color: colors.secondaryContainer,
                        textColor: colors.onSecondaryContainer,
                      ),
                      _MetaChip(
                        icon: Icons.schedule_rounded,
                        label: '${recipe.cookTimeMinutes} мин',
                        color: colors.tertiaryContainer,
                        textColor: colors.onTertiaryContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: textColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
