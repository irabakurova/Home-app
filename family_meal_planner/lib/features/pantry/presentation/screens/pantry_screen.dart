import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/sync/sync_provider.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/pantry_item.dart';
import '../providers/pantry_provider.dart';
import '../widgets/pantry_item_tile.dart';

class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredPantryProvider);
    final searchQuery = ref.watch(pantrySearchQueryProvider);
    final categoryFilter = ref.watch(pantryCategoryFilterProvider);
    final lowStock = ref.watch(pantryLowStockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кладовая'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            tooltip: 'Что можно приготовить?',
            onPressed: () =>
                context.pushNamed(RouteNames.recipeGenerator),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _PantrySearchBar(
            value: searchQuery,
            onChanged: (q) =>
                ref.read(pantrySearchQueryProvider.notifier).state = q,
          ),
        ),
      ),
      body: Column(
        children: [
          // Low stock banner
          lowStock.whenOrNull(
                data: (items) => items.isNotEmpty
                    ? _LowStockBanner(count: items.length)
                    : null,
              ) ??
              const SizedBox.shrink(),

          // Category filter chips
          _CategoryFilterRow(
            selected: categoryFilter,
            onSelected: (v) =>
                ref.read(pantryCategoryFilterProvider.notifier).state = v,
          ),

          // Items list
          Expanded(
            child: filtered.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (items) => items.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.kitchen_outlined,
                      title: searchQuery.isNotEmpty || categoryFilter != null
                          ? 'Ничего не найдено'
                          : 'Кладовая пуста',
                      subtitle:
                          searchQuery.isNotEmpty || categoryFilter != null
                              ? 'Попробуйте другой запрос или сбросьте фильтр'
                              : 'Нажмите «+» чтобы добавить первый продукт',
                    )
                  : _PantryList(items: items),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouteNames.pantryItemNew),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }
}

// ── Low stock banner ──────────────────────────────────────────────────────────

class _LowStockBanner extends StatelessWidget {
  const _LowStockBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.warning_amber_outlined,
                size: 18, color: colors.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                count == 1
                    ? '1 продукт заканчивается'
                    : '$count продуктов заканчивается',
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _PantrySearchBar extends StatefulWidget {
  const _PantrySearchBar({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_PantrySearchBar> createState() => _PantrySearchBarState();
}

class _PantrySearchBarState extends State<_PantrySearchBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_PantrySearchBar old) {
    super.didUpdateWidget(old);
    if (widget.value != _ctrl.text) _ctrl.text = widget.value;
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
          hintText: 'Поиск продуктов…',
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
  const _CategoryFilterRow(
      {required this.selected, required this.onSelected});
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(pantryCategoriesProvider);
    return SizedBox(
      height: 44,
      child: categoriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (cats) => ListView(
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
            ...cats.map(
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

// ── Items list ────────────────────────────────────────────────────────────────

class _PantryList extends ConsumerWidget {
  const _PantryList({required this.items});
  final List<PantryItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final item = items[i];
        return PantryItemTile(
          key: ValueKey(item.id),
          item: item,
          onEdit: () => context.pushNamed(
            RouteNames.pantryItemEdit,
            pathParameters: {'id': item.id},
          ),
          onDelete: () {
            // 1. Delete from local SQLite
            ref.read(pantryRepositoryProvider).delete(item.id);
            // 2. Delete from Firestore + write tombstone so other devices
            //    don't restore this item on their next pull
            ref
                .read(syncServiceProvider)
                .deleteRemotePantryItem(kDefaultFamilyId, item.id);
          },
        );
      },
    );
  }
}
