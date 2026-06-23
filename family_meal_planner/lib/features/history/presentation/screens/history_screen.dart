import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/quantity_calculator.dart';
import '../../domain/entities/cooking_history_entry.dart';
import '../providers/history_provider.dart';

// ── Main screen ───────────────────────────────────────────────────────────────

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _searchController = TextEditingController();
  bool _searchActive = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Поиск по рецепту…',
                  border: InputBorder.none,
                ),
                onChanged: (q) =>
                    ref.read(historySearchQueryProvider.notifier).state = q,
              )
            : const Text('История готовки'),
        actions: [
          IconButton(
            icon: Icon(_searchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _searchActive = !_searchActive);
              if (!_searchActive) {
                _searchController.clear();
                ref.read(historySearchQueryProvider.notifier).state = '';
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'Записи'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Статистика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _HistoryTab(),
          _StatsTab(),
        ],
      ),
    );
  }
}

// ── History tab ───────────────────────────────────────────────────────────────

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredHistoryProvider);
    final query = ref.watch(historySearchQueryProvider);

    return filtered.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (entries) {
        if (entries.isEmpty) {
          return _EmptyHistory(isFiltered: query.isNotEmpty);
        }
        // Group entries by date
        final grouped = _groupByDate(entries);
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: grouped.length,
          itemBuilder: (context, i) {
            final group = grouped[i];
            return _DateGroup(date: group.date, entries: group.entries);
          },
        );
      },
    );
  }

  List<_HistoryGroup> _groupByDate(List<CookingHistoryEntry> entries) {
    final map = <String, List<CookingHistoryEntry>>{};
    for (final e in entries) {
      final key = _dateKey(e.cookedAt);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map.entries
        .map((e) => _HistoryGroup(date: e.key, entries: e.value))
        .toList();
  }

  String _dateKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Сегодня';
    if (d == today.subtract(const Duration(days: 1))) return 'Вчера';
    return DateFormat('d MMMM y', 'ru').format(dt);
  }
}

class _HistoryGroup {
  const _HistoryGroup({required this.date, required this.entries});
  final String date;
  final List<CookingHistoryEntry> entries;
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.date, required this.entries});

  final String date;
  final List<CookingHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            date,
            style: textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...entries.map((e) => _HistoryTile(entry: e)),
        const Divider(height: 1),
      ],
    );
  }
}

// ── Single history tile ───────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final CookingHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final time = DateFormat('HH:mm').format(entry.cookedAt);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: colors.secondaryContainer,
        child: Icon(Icons.restaurant_menu,
            color: colors.onSecondaryContainer, size: 20),
      ),
      title: Text(
        entry.recipeTitle,
        style: textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$time · ${entry.servingsCooked} ${_portionsLabel(entry.servingsCooked)}'
        '${entry.ingredients.isNotEmpty ? ' · ${entry.ingredients.length} продуктов' : ''}',
        style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
      trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
      onTap: () => _showDetail(context, entry),
    );
  }

  String _portionsLabel(int n) {
    if (n == 1) return 'порция';
    if (n >= 2 && n <= 4) return 'порции';
    return 'порций';
  }

  void _showDetail(BuildContext context, CookingHistoryEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _HistoryDetailSheet(entry: entry),
    );
  }
}

// ── Detail bottom sheet ───────────────────────────────────────────────────────

class _HistoryDetailSheet extends StatelessWidget {
  const _HistoryDetailSheet({required this.entry});

  final CookingHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateStr = DateFormat('d MMMM y, HH:mm', 'ru').format(entry.cookedAt);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scroll) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.recipeTitle,
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: colors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(dateStr,
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(width: 16),
                  Icon(Icons.people_outline,
                      size: 14, color: colors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${entry.servingsCooked} порц.',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant)),
                ]),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.all(20),
              children: [
                if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                  Text('Заметки',
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(entry.notes!),
                  const SizedBox(height: 20),
                ],
                if (entry.ingredients.isNotEmpty) ...[
                  Text(
                    'Использованные продукты',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: entry.ingredients.asMap().entries.map((e) {
                        final ing = e.value;
                        final isLast = e.key == entry.ingredients.length - 1;
                        return Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(ing.ingredientName),
                              trailing: Text(
                                QuantityCalculator.formatWithUnit(
                                    ing.quantityUsed, ing.unit),
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              leading: Icon(
                                ing.pantryItemId != null
                                    ? Icons.check_circle_outline
                                    : Icons.help_outline,
                                size: 18,
                                color: ing.pantryItemId != null
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                              ),
                            ),
                            if (!isLast) const Divider(height: 1),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // Link to recipe
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pushNamed(
                      RouteNames.recipeDetail,
                      pathParameters: {'id': entry.recipeId},
                    );
                  },
                  icon: const Icon(Icons.menu_book_outlined),
                  label: const Text('Открыть рецепт'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats tab ─────────────────────────────────────────────────────────────────

class _StatsTab extends ConsumerWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(cookingHistoryProvider);
    final popularAsync = ref.watch(popularRecipesProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (history) {
        if (history.isEmpty) {
          return const _EmptyHistory(isFiltered: false);
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SummaryCards(history: history),
            const SizedBox(height: 24),
            popularAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Ошибка статистики: $e'),
              data: (popular) => _PopularList(popular: popular),
            ),
          ],
        );
      },
    );
  }
}

// ── Summary cards row ─────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.history});

  final List<CookingHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    final uniqueRecipes = history.map((e) => e.recipeId).toSet().length;
    final totalServings = history.fold<int>(0, (s, e) => s + e.servingsCooked);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.restaurant_menu,
            value: '${history.length}',
            label: 'Всего готовок',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.library_books_outlined,
            value: '$uniqueRecipes',
            label: 'Рецептов',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.people_outline,
            value: '$totalServings',
            label: 'Порций',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: colors.primary, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: textTheme.labelSmall
                    ?.copyWith(color: colors.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Popular recipes list ──────────────────────────────────────────────────────

class _PopularList extends StatelessWidget {
  const _PopularList({required this.popular});

  final List<Map<String, dynamic>> popular;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    if (popular.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Популярные блюда',
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: popular.asMap().entries.map((e) {
              final item = e.value;
              final isLast = e.key == popular.length - 1;
              final recipeId = item['recipe_id'] as String;
              final title = item['recipe_title'] as String;
              final count = item['cook_count'] as int;
              final lastMs = item['last_cooked_at'] as int;
              final lastDate = DateFormat('d MMM y', 'ru')
                  .format(DateTime.fromMillisecondsSinceEpoch(lastMs));

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e.key == 0
                          ? colors.primaryContainer
                          : colors.surfaceContainerHighest,
                      child: Text(
                        '${e.key + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: e.key == 0
                              ? colors.onPrimaryContainer
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      'Последний раз: $lastDate',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    trailing: Chip(
                      label: Text(
                        '$count ${_timesLabel(count)}',
                        style: textTheme.labelSmall,
                      ),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: colors.secondaryContainer,
                    ),
                    onTap: () => context.pushNamed(
                      RouteNames.recipeDetail,
                      pathParameters: {'id': recipeId},
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _timesLabel(int n) {
    if (n == 1) return 'раз';
    if (n >= 2 && n <= 4) return 'раза';
    return 'раз';
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.isFiltered});

  final bool isFiltered;

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
            Icon(
              isFiltered ? Icons.search_off : Icons.history,
              size: 72,
              color: colors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              isFiltered
                  ? 'Ничего не найдено'
                  : 'История пуста',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Попробуйте другой запрос.'
                  : 'После приготовления блюда нажмите «Блюдо приготовлено» в режиме готовки.',
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
