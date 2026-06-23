import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_names.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 600;

    if (isWide) {
      return _DesktopShell(child: child);
    } else {
      return _MobileShell(child: child);
    }
  }
}

// ─── Mobile: BottomNavigationBar ─────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexFromPath(location);

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.4),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) {
            if (i == _destinations.length) {
              // "Ещё" tab — show bottom sheet
              _showMoreSheet(context);
            } else {
              _navigate(context, i);
            }
          },
          destinations: [
            ..._destinations.map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                )),
            const NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz),
              label: 'Ещё',
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _MoreSheetItem(
                icon: Icons.favorite_outline,
                label: 'Избранное',
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.go(RoutePaths.favorites);
                },
              ),
              _MoreSheetItem(
                icon: Icons.history_outlined,
                label: 'История',
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.pushNamed('history');
                },
              ),
              _MoreSheetItem(
                icon: Icons.auto_awesome_outlined,
                label: 'Что приготовить?',
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.pushNamed('recipe-generator');
                },
              ),
              _MoreSheetItem(
                icon: Icons.settings_outlined,
                label: 'Настройки',
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.pushNamed('settings');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSheetItem extends StatelessWidget {
  const _MoreSheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(label, style: TextStyle(color: scheme.onSurface)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

// ─── Desktop: NavigationRail ──────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexFromPath(location);
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isExtended = width >= 900;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) => _navigate(context, i),
            backgroundColor: scheme.surfaceContainerLow,
            extended: isExtended,
            minWidth: 64,
            minExtendedWidth: 180,
            destinations: _destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ))
                .toList(),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RailTrailingButton(
                        icon: Icons.favorite_outline,
                        label: 'Избранное',
                        isExtended: isExtended,
                        onPressed: () => context.go(RoutePaths.favorites),
                      ),
                      _RailTrailingButton(
                        icon: Icons.auto_awesome_outlined,
                        label: 'Что приготовить?',
                        isExtended: isExtended,
                        onPressed: () => context.pushNamed('recipe-generator'),
                      ),
                      _RailTrailingButton(
                        icon: Icons.history_outlined,
                        label: 'История',
                        isExtended: isExtended,
                        onPressed: () => context.pushNamed('history'),
                      ),
                      _RailTrailingButton(
                        icon: Icons.settings_outlined,
                        label: 'Настройки',
                        isExtended: isExtended,
                        onPressed: () => context.pushNamed('settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// A trailing rail button that adapts between icon-only and icon+label modes.
class _RailTrailingButton extends StatelessWidget {
  const _RailTrailingButton({
    required this.icon,
    required this.label,
    required this.isExtended,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isExtended;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (isExtended) {
      return TextButton.icon(
        icon: Icon(icon, size: 20, color: scheme.onSurfaceVariant),
        label: Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          minimumSize: const Size(160, 44),
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: onPressed,
      );
    }

    return IconButton(
      icon: Icon(icon, size: 22),
      color: scheme.onSurfaceVariant,
      tooltip: label,
      onPressed: onPressed,
    );
  }
}

// ─── Shared data ─────────────────────────────────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
}

const _destinations = [
  _NavItem(
    label: 'Рецепты',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
    path: RoutePaths.recipes,
  ),
  _NavItem(
    label: 'Кладовая',
    icon: Icons.kitchen_outlined,
    selectedIcon: Icons.kitchen,
    path: RoutePaths.pantry,
  ),
  _NavItem(
    label: 'Меню',
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month,
    path: RoutePaths.planner,
  ),
  _NavItem(
    label: 'Покупки',
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
    path: RoutePaths.shopping,
  ),
];

int _indexFromPath(String path) {
  for (var i = 0; i < _destinations.length; i++) {
    if (path.startsWith(_destinations[i].path)) return i;
  }
  // Favorites and other secondary screens — highlight "Ещё" (index 4)
  if (path.startsWith(RoutePaths.favorites)) return 4;
  return 0;
}

void _navigate(BuildContext context, int index) {
  final path = _destinations[index].path;
  context.go(path);
}
