import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_category.dart';
import '../providers/categories_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление категориями'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Блюда'),
            Tab(text: 'Кухни'),
            Tab(text: 'Продукты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _CategoryTab(type: 'recipe',  label: 'категорию блюда'),
          _CategoryTab(type: 'cuisine', label: 'кухню'),
          _CategoryTab(type: 'pantry',  label: 'категорию продукта'),
        ],
      ),
    );
  }
}

// ── Single tab ────────────────────────────────────────────────────────────────

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab({required this.type, required this.label});

  final String type;
  final String label;

  StreamProvider<List<AppCategory>> get _provider {
    return switch (type) {
      'recipe'  => recipeCategoriesProvider,
      'cuisine' => cuisineCategoriesProvider,
      _         => pantryCategoriesProvider,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_provider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (categories) => Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) =>
                  _CategoryTile(category: categories[i]),
            ),
          ),
          _AddBar(type: type, label: label),
        ],
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category});

  final AppCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        category.isSystem ? Icons.lock_outline : Icons.label_outline,
        color: category.isSystem
            ? theme.colorScheme.outline
            : theme.colorScheme.primary,
      ),
      title: Text(category.name),
      subtitle: category.isSystem
          ? Text('Системная', style: theme.textTheme.bodySmall)
          : null,
      trailing: category.isSystem
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Переименовать',
                  onPressed: () => _showRenameDialog(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Удалить',
                  color: theme.colorScheme.error,
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: category.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Переименовать'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Название'),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (_) => Navigator.pop(ctx, true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отмена')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Сохранить')),
        ],
      ),
    );
    if (confirmed == true && ctrl.text.trim().isNotEmpty) {
      await ref
          .read(categoriesNotifierProvider.notifier)
          .renameCategory(category.id, ctrl.text);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить категорию?'),
        content: Text(
          'Рецепты и продукты с категорией "${category.name}" '
          'сохранятся, но категория не будет отображаться в списках.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отмена')),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Удалить')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(categoriesNotifierProvider.notifier)
          .deleteCategory(category.id);
    }
  }
}

// ── Add bar ───────────────────────────────────────────────────────────────────

class _AddBar extends ConsumerStatefulWidget {
  const _AddBar({required this.type, required this.label});

  final String type;
  final String label;

  @override
  ConsumerState<_AddBar> createState() => _AddBarState();
}

class _AddBarState extends ConsumerState<_AddBar> {
  final _ctrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _loading = true);
    try {
      await ref
          .read(categoriesNotifierProvider.notifier)
          .addCategory(type: widget.type, name: name);
      _ctrl.clear();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.outline)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Добавить ${widget.label}',
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton.filled(
                    icon: const Icon(Icons.add),
                    onPressed: _submit,
                    tooltip: 'Добавить',
                  ),
          ],
        ),
      ),
    );
  }
}
