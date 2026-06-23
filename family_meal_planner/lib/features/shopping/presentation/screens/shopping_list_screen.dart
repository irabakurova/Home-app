import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/utils/quantity_calculator.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../providers/shopping_provider.dart';
import '../../domain/entities/shopping_list.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(latestShoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
        actions: [
          listAsync.whenOrNull(
            data: (list) => list != null
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: 'Удалить список',
                    onPressed: () => _confirmDelete(context, ref, list.id),
                  )
                : null,
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (list) {
          if (list == null) {
            return _EmptyShoppingState(
              onGenerate: () => _generate(context, ref),
            );
          }
          return _ShoppingListBody(list: list);
        },
      ),
      floatingActionButton: _buildFab(context, ref, listAsync),
    );
  }

  Widget _buildFab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<ShoppingList?> listAsync,
  ) {
    return listAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list == null) {
          // No list yet — big generate button
          return FloatingActionButton.extended(
            onPressed: () => _generate(context, ref),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Сгенерировать'),
          );
        }
        // List exists — show two actions
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'fab_regen',
              onPressed: () => _generate(context, ref),
              tooltip: 'Пересчитать из планировщика',
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'fab_add',
              onPressed: () => _showAddManualItem(context, ref, list.id),
              tooltip: 'Добавить вручную',
              child: const Icon(Icons.add),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(shoppingNotifierProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await notifier.generate();
      messenger.showSnackBar(
        const SnackBar(content: Text('Список покупок обновлён')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String listId) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить список?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(shoppingNotifierProvider.notifier).deleteList(listId);
      }
    });
  }

  void _showAddManualItem(
      BuildContext context, WidgetRef ref, String listId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AddManualItemSheet(listId: listId),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyShoppingState extends StatelessWidget {
  const _EmptyShoppingState({required this.onGenerate});
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Список пуст',
      subtitle:
          'Составьте меню в планировщике и нажмите «Сгенерировать» — '
          'приложение само подсчитает, что купить.',
      action: onGenerate,
      actionLabel: 'Сгенерировать из планировщика',
    );
  }
}

// ── Main body ─────────────────────────────────────────────────────────────────

class _ShoppingListBody extends ConsumerWidget {
  const _ShoppingListBody({required this.list});
  final ShoppingList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final itemsByCategory = list.itemsByCategory;
    final covered = list.coveredItems;
    final checked = list.checkedCount;
    final total = list.toBuyItems.length;

    return CustomScrollView(
      slivers: [
        // ── Progress header ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.name,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      total == 0
                          ? 'Ничего покупать не нужно'
                          : '$checked из $total куплено',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    if (total > 0) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: total > 0 ? checked / total : 0,
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: Divider(height: 1)),

        // ── Items by category ────────────────────────────────────────────
        if (itemsByCategory.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Все продукты есть на складе!',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          )
        else
          for (final entry in itemsByCategory.entries) ...[
            // Category header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  entry.key,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Items
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ShoppingItemTile(
                  item: entry.value[i],
                  onToggle: (val) => ref
                      .read(shoppingNotifierProvider.notifier)
                      .toggle(entry.value[i].id, isChecked: val),
                  onDelete: () => ref
                      .read(shoppingNotifierProvider.notifier)
                      .deleteItem(entry.value[i].id),
                ),
                childCount: entry.value.length,
              ),
            ),
          ],

        // ── Covered by pantry (collapsed section) ────────────────────────
        if (covered.isNotEmpty)
          SliverToBoxAdapter(
            child: _CoveredSection(items: covered),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ── Shopping item tile ────────────────────────────────────────────────────────

class _ShoppingItemTile extends StatelessWidget {
  const _ShoppingItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final ShoppingItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final qtyStr = QuantityCalculator.formatWithUnit(
        item.quantityToBuy, item.unit);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.errorContainer,
        child: Icon(Icons.delete_outline, color: colors.onErrorContainer),
      ),
      onDismissed: (_) => onDelete(),
      child: CheckboxListTile(
        value: item.isChecked,
        onChanged: (v) => onToggle(v ?? false),
        title: Text(
          item.name,
          style: textTheme.bodyMedium?.copyWith(
            decoration:
                item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked ? colors.onSurfaceVariant : null,
          ),
        ),
        subtitle: item.quantityInPantry > 0
            ? Text(
                'Нужно: $qtyStr · Есть: ${QuantityCalculator.formatWithUnit(item.quantityInPantry, item.unit)}',
                style: textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              )
            : null,
        secondary: _quantityBadge(context, qtyStr),
        dense: true,
      ),
    );
  }

  Widget _quantityBadge(BuildContext context, String label) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minWidth: 56),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.isChecked
            ? colors.surfaceContainerHighest
            : colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: item.isChecked
                  ? colors.onSurfaceVariant
                  : colors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// ── Covered by pantry section ─────────────────────────────────────────────────

class _CoveredSection extends StatefulWidget {
  const _CoveredSection({required this.items});
  final List<ShoppingItem> items;

  @override
  State<_CoveredSection> createState() => _CoveredSectionState();
}

class _CoveredSectionState extends State<_CoveredSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: colors.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Покрыто из склада (${widget.items.length})',
                    style: textTheme.labelLarge
                        ?.copyWith(color: colors.tertiary),
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          for (final item in widget.items)
            ListTile(
              dense: true,
              leading: Icon(Icons.check,
                  size: 16, color: colors.tertiary),
              title: Text(
                item.name,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              trailing: Text(
                QuantityCalculator.formatWithUnit(
                    item.quantityInPantry, item.unit),
                style: textTheme.labelSmall
                    ?.copyWith(color: colors.tertiary),
              ),
            ),
      ],
    );
  }
}

// ── Add manual item sheet ─────────────────────────────────────────────────────

class _AddManualItemSheet extends ConsumerStatefulWidget {
  const _AddManualItemSheet({required this.listId});
  final String listId;

  @override
  ConsumerState<_AddManualItemSheet> createState() =>
      _AddManualItemSheetState();
}

class _AddManualItemSheetState
    extends ConsumerState<_AddManualItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _qtyCtr = TextEditingController(text: '1');
  MeasurementUnit _unit = MeasurementUnit.pcs;
  PantryCategory? _category;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtr.dispose();
    _qtyCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Добавить продукт',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtr,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Введите название' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _qtyCtr,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration:
                        const InputDecoration(labelText: 'Количество'),
                    validator: (v) {
                      final n = double.tryParse(v ?? '');
                      if (n == null || n <= 0) return 'Введите число > 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<MeasurementUnit>(
                    key: ValueKey(_unit),
                    initialValue: _unit,
                    decoration:
                        const InputDecoration(labelText: 'Единица'),
                    items: MeasurementUnit.values
                        .map((u) => DropdownMenuItem(
                              value: u,
                              child: Text(u.label),
                            ))
                        .toList(),
                    onChanged: (u) =>
                        setState(() => _unit = u ?? _unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PantryCategory?>(
              key: ValueKey(_category),
              initialValue: _category,
              decoration:
                  const InputDecoration(labelText: 'Категория (опционально)'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('— Не указана —')),
                ...PantryCategory.values.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.label),
                    )),
              ],
              onChanged: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Добавить'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(shoppingNotifierProvider.notifier).addManualItem(
            listId: widget.listId,
            name: _nameCtr.text.trim(),
            quantity: double.parse(_qtyCtr.text),
            unit: _unit,
            category: _category,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
