import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/enums.dart';
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/pantry_item.dart';
import '../providers/pantry_provider.dart';

class PantryItemTile extends ConsumerStatefulWidget {
  const PantryItemTile({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final PantryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  ConsumerState<PantryItemTile> createState() => _PantryItemTileState();
}

class _PantryItemTileState extends ConsumerState<PantryItemTile> {
  bool _editingQty = false;
  late TextEditingController _qtyCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(
        text: _formatQty(widget.item.quantity));
  }

  @override
  void didUpdateWidget(PantryItemTile old) {
    super.didUpdateWidget(old);
    if (!_editingQty && old.item.quantity != widget.item.quantity) {
      _qtyCtrl.text = _formatQty(widget.item.quantity);
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  String _formatQty(double q) =>
      q == q.truncateToDouble() ? q.toInt().toString() : q.toStringAsFixed(1);

  Future<void> _saveQty() async {
    final newQty = double.tryParse(_qtyCtrl.text.replaceAll(',', '.'));
    if (newQty == null) {
      _qtyCtrl.text = _formatQty(widget.item.quantity);
      setState(() => _editingQty = false);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(pantryRepositoryProvider)
          .updateQuantity(widget.item.id, newQty);
    } finally {
      if (mounted) setState(() { _editingQty = false; _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Resolve display name for category slug from DB
    final catsAsync = ref.watch(pantryCategoriesProvider);
    final categoryName = catsAsync.whenOrNull(
          data: (cats) => cats
              .where((c) => c.value == widget.item.category)
              .map((c) => c.name)
              .firstOrNull,
        ) ??
        widget.item.category;

    final isLow = widget.item.isLowStock;
    final isEmpty = widget.item.isEmpty;

    return Dismissible(
      key: ValueKey(widget.item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.error,
        child: Icon(Icons.delete_outline, color: colors.onError),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Удалить продукт?'),
            content: Text('«${widget.item.name}» будет удалён из кладовой.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Отмена')),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: colors.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Удалить'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => widget.onDelete(),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _StatusDot(isEmpty: isEmpty, isLow: isLow),
        title: Text(
          widget.item.name,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isEmpty ? colors.error : null,
          ),
        ),
        subtitle: Text(
          categoryName,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Inline quantity editor ─────────────────────────────────
            _editingQty
                ? SizedBox(
                    width: 72,
                    child: TextField(
                      controller: _qtyCtrl,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                      onSubmitted: (_) => _saveQty(),
                      onTapOutside: (_) => _saveQty(),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _qtyCtrl.text = _formatQty(widget.item.quantity);
                      setState(() => _editingQty = true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isLow || isEmpty
                            ? colors.errorContainer
                            : colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2))
                          : Text(
                              '${_formatQty(widget.item.quantity)} '
                              '${_unitLabel(widget.item.unit)}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: isLow || isEmpty
                                    ? colors.onErrorContainer
                                    : colors.onSecondaryContainer,
                              ),
                            ),
                    ),
                  ),
            const SizedBox(width: 4),
            // Edit button
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: widget.onEdit,
              tooltip: 'Изменить',
            ),
          ],
        ),
      ),
    );
  }

  String _unitLabel(String unitValue) {
    return MeasurementUnit.values
            .where((u) => u.value == unitValue)
            .map((u) => u.label)
            .firstOrNull ??
        unitValue;
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isEmpty, required this.isLow});

  final bool isEmpty;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color color;
    IconData icon;
    if (isEmpty) {
      color = colors.error;
      icon = Icons.remove_circle_outline;
    } else if (isLow) {
      color = colors.tertiary;
      icon = Icons.warning_amber_outlined;
    } else {
      color = colors.primary;
      icon = Icons.check_circle_outline;
    }
    return Icon(icon, color: color, size: 22);
  }
}
