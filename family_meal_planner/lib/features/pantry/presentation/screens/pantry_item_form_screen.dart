import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/pantry_item.dart';
import '../providers/pantry_provider.dart';

class PantryItemFormScreen extends ConsumerStatefulWidget {
  const PantryItemFormScreen({super.key, this.itemId});

  /// null = create new; non-null = edit existing
  final String? itemId;

  @override
  ConsumerState<PantryItemFormScreen> createState() =>
      _PantryItemFormScreenState();
}

class _PantryItemFormScreenState extends ConsumerState<PantryItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _quantityCtrl;
  late final TextEditingController _minQtyCtrl;

  String _unit = MeasurementUnit.g.value;
  String _category = 'vegetables'; // default slug

  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _quantityCtrl = TextEditingController(text: '0');
    _minQtyCtrl = TextEditingController(text: '0');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.itemId != null) {
      _initialized = true;
      _loadItem();
    } else {
      _initialized = true;
    }
  }

  Future<void> _loadItem() async {
    final item =
        await ref.read(pantryRepositoryProvider).getById(widget.itemId!);
    if (!mounted || item == null) return;
    setState(() {
      _nameCtrl.text = item.name;
      _quantityCtrl.text = _fmt(item.quantity);
      _minQtyCtrl.text = _fmt(item.minQuantity);
      _unit = item.unit;
      _category = item.category;
    });
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _minQtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final now = DateTime.now();
      final id = widget.itemId ?? UuidGenerator.generate();
      final item = PantryItem(
        id: id,
        familyId: 'default_family',
        name: _nameCtrl.text.trim(),
        quantity:
            double.tryParse(_quantityCtrl.text.replaceAll(',', '.')) ?? 0,
        unit: _unit,
        category: _category,
        minQuantity:
            double.tryParse(_minQtyCtrl.text.replaceAll(',', '.')) ?? 0,
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(pantryRepositoryProvider).save(item);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.itemId != null;
    final categoriesAsync = ref.watch(pantryCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать продукт' : 'Новый продукт'),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Сохранить'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Name ────────────────────────────────────────────────────
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Название продукта *',
                hintText: 'Например: Рис',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Укажите название'
                  : null,
            ),
            const SizedBox(height: 16),

            // ── Quantity + Unit ──────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _quantityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Количество',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      final n =
                          double.tryParse(v?.replaceAll(',', '.') ?? '');
                      return n == null || n < 0 ? 'Введите число ≥ 0' : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(labelText: 'Ед.изм.'),
                    items: MeasurementUnit.values
                        .map((u) => DropdownMenuItem(
                            value: u.value, child: Text(u.label)))
                        .toList(),
                    onChanged: (v) => setState(() => _unit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Category ─────────────────────────────────────────────────
            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
              data: (cats) {
                final validValue =
                    cats.any((c) => c.value == _category)
                        ? _category
                        : (cats.isNotEmpty ? cats.first.value : _category);
                if (validValue != _category) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => setState(() => _category = validValue));
                }
                return DropdownButtonFormField<String>(
                  key: ValueKey(validValue),
                  initialValue: validValue,
                  decoration:
                      const InputDecoration(labelText: 'Категория'),
                  items: cats
                      .map((c) => DropdownMenuItem(
                          value: c.value, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                );
              },
            ),
            const SizedBox(height: 16),

            // ── Minimum quantity ─────────────────────────────────────────
            TextFormField(
              controller: _minQtyCtrl,
              decoration: const InputDecoration(
                labelText: 'Минимальный остаток',
                helperText:
                    'Приложение предупредит, когда количество упадёт ниже этого значения. 0 = отключить.',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse(v?.replaceAll(',', '.') ?? '');
                return n == null || n < 0 ? 'Введите число ≥ 0' : null;
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
