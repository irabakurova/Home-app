import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../settings/presentation/providers/categories_provider.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../providers/recipes_provider.dart';

// ── Helper class for ingredient form state ────────────────────────────────────

class _IngredientDraft {
  _IngredientDraft({
    String? id,
    String name = '',
    String quantityText = '0',
    this.unit = MeasurementUnit.g,
    this.category,
  })  : id = id ?? UuidGenerator.generate(),
        nameCtrl = TextEditingController(text: name),
        quantityCtrl = TextEditingController(text: quantityText);

  final String id;
  final TextEditingController nameCtrl;
  final TextEditingController quantityCtrl;
  MeasurementUnit unit;
  PantryCategory? category;

  void dispose() {
    nameCtrl.dispose();
    quantityCtrl.dispose();
  }
}

// ── Form Screen ───────────────────────────────────────────────────────────────

class RecipeFormScreen extends ConsumerStatefulWidget {
  const RecipeFormScreen({super.key, this.recipeId});

  /// null = create new recipe; non-null = edit existing
  final String? recipeId;

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic fields
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _cookTimeCtrl;

  // Category & cuisine stored as value slugs (matched to CategoriesTable.value)
  String _category = 'hot_dish';
  String _cuisine = 'russian';
  int _defaultServings = AppConstants.defaultServings;

  // Dynamic lists
  final List<_IngredientDraft> _ingredients = [];
  final List<TextEditingController> _instructionCtrlList = [];

  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
    _cookTimeCtrl = TextEditingController(text: '30');
    _addIngredient();
    _addInstruction();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.recipeId != null) {
      _initialized = true;
      _loadRecipe();
    } else {
      _initialized = true;
    }
  }

  Future<void> _loadRecipe() async {
    final repo = ref.read(recipeRepositoryProvider);
    final recipe = await repo.getById(widget.recipeId!);
    final ingredients = await repo.getIngredients(widget.recipeId!);
    if (!mounted || recipe == null) return;

    setState(() {
      _titleCtrl.text = recipe.title;
      _descriptionCtrl.text = recipe.description ?? '';
      _cookTimeCtrl.text = recipe.cookTimeMinutes.toString();
      _category = recipe.category;
      _cuisine = recipe.cuisine;
      _defaultServings = recipe.defaultServings;

      for (final d in _ingredients) {
        d.dispose();
      }
      _ingredients.clear();
      for (final ctrl in _instructionCtrlList) {
        ctrl.dispose();
      }
      _instructionCtrlList.clear();

      for (final ing in ingredients) {
        _ingredients.add(_IngredientDraft(
          id: ing.id,
          name: ing.name,
          quantityText: ing.quantity.toString(),
          unit: ing.unit,
          category: ing.category,
        ));
      }
      if (_ingredients.isEmpty) _addIngredient();

      for (final step in recipe.instructions) {
        _instructionCtrlList.add(TextEditingController(text: step));
      }
      if (_instructionCtrlList.isEmpty) _addInstruction();
    });
  }

  void _addIngredient() {
    setState(() => _ingredients.add(_IngredientDraft()));
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index].dispose();
      _ingredients.removeAt(index);
    });
  }

  void _addInstruction() {
    setState(() => _instructionCtrlList.add(TextEditingController()));
  }

  void _removeInstruction(int index) {
    setState(() {
      _instructionCtrlList[index].dispose();
      _instructionCtrlList.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _cookTimeCtrl.dispose();
    for (final d in _ingredients) {
      d.dispose();
    }
    for (final c in _instructionCtrlList) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final now = DateTime.now();
      final id = widget.recipeId ?? UuidGenerator.generate();

      final recipe = Recipe(
        id: id,
        familyId: kDefaultFamilyId,
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
        photoUrl: null,
        category: _category,
        cuisine: _cuisine,
        cookTimeMinutes: int.tryParse(_cookTimeCtrl.text) ?? 30,
        defaultServings: _defaultServings,
        instructions: _instructionCtrlList
            .map((c) => c.text.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        isFavorite: false,
        createdBy: kDefaultUserId,
        createdAt: now,
        updatedAt: now,
      );

      final ingredients = _ingredients.asMap().entries.map((e) {
        final draft = e.value;
        return Ingredient(
          id: draft.id,
          recipeId: id,
          name: draft.nameCtrl.text.trim(),
          quantity: double.tryParse(draft.quantityCtrl.text) ?? 0,
          unit: draft.unit,
          category: draft.category,
          sortOrder: e.key,
        );
      }).where((i) => i.name.isNotEmpty).toList();

      await ref.read(recipeRepositoryProvider).save(recipe, ingredients);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.recipeId != null;

    // Watch DB categories for dropdowns
    final recipeCatsAsync = ref.watch(recipeCategoriesProvider);
    final cuisineCatsAsync = ref.watch(cuisineCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать рецепт' : 'Новый рецепт'),
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
            // ── Basic info ──────────────────────────────────────────────────
            const _SectionHeader(label: 'Основное'),
            const SizedBox(height: 8),

            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Название *',
                hintText: 'Например: Борщ со сметаной',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Укажите название' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Описание',
                hintText: 'Короткое описание блюда…',
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),

            // ── Category & Cuisine from DB ──────────────────────────────────
            Row(
              children: [
                // Category dropdown
                Expanded(
                  child: recipeCatsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (cats) {
                      // Ensure current value is in list, fallback to first
                      final validValue = cats.any((c) => c.value == _category)
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
                ),
                const SizedBox(width: 12),
                // Cuisine dropdown
                Expanded(
                  child: cuisineCatsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (cats) {
                      final validValue = cats.any((c) => c.value == _cuisine)
                          ? _cuisine
                          : (cats.isNotEmpty ? cats.first.value : _cuisine);
                      if (validValue != _cuisine) {
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => setState(() => _cuisine = validValue));
                      }
                      return DropdownButtonFormField<String>(
                        key: ValueKey(validValue),
                        initialValue: validValue,
                        decoration:
                            const InputDecoration(labelText: 'Кухня'),
                        items: cats
                            .map((c) => DropdownMenuItem(
                                value: c.value, child: Text(c.name)))
                            .toList(),
                        onChanged: (v) => setState(() => _cuisine = v!),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Cook time & servings ────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: time field — label above + field below (no floating label)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Время (мин)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cookTimeCtrl,
                        decoration: const InputDecoration(
                          hintText: '30',
                          suffixText: 'мин',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          return n == null || n <= 0
                              ? 'Введите число больше 0'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Right: servings — same label-above layout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Порций по умолчанию',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _defaultServings >
                                    AppConstants.minServings
                                ? () => setState(() => _defaultServings--)
                                : null,
                          ),
                          Text(
                            '$_defaultServings',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _defaultServings <
                                    AppConstants.maxServings
                                ? () => setState(() => _defaultServings++)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Ingredients ─────────────────────────────────────────────────
            const _SectionHeader(label: 'Ингредиенты'),
            const SizedBox(height: 8),

            ..._ingredients.asMap().entries.map(
                  (e) => _IngredientRow(
                    key: ValueKey(e.value.id),
                    draft: e.value,
                    onRemove: _ingredients.length > 1
                        ? () => _removeIngredient(e.key)
                        : null,
                    onChanged: () => setState(() {}),
                  ),
                ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add),
              label: const Text('Добавить ингредиент'),
            ),

            const SizedBox(height: 24),

            // ── Instructions ────────────────────────────────────────────────
            const _SectionHeader(label: 'Шаги приготовления'),
            const SizedBox(height: 8),

            ..._instructionCtrlList.asMap().entries.map(
                  (e) => _InstructionRow(
                    key: ValueKey(e.key),
                    step: e.key + 1,
                    controller: e.value,
                    onRemove: _instructionCtrlList.length > 1
                        ? () => _removeInstruction(e.key)
                        : null,
                  ),
                ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addInstruction,
              icon: const Icon(Icons.add),
              label: const Text('Добавить шаг'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Ingredient row ────────────────────────────────────────────────────────────

class _IngredientRow extends StatefulWidget {
  const _IngredientRow({
    super.key,
    required this.draft,
    required this.onRemove,
    required this.onChanged,
  });

  final _IngredientDraft draft;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  @override
  State<_IngredientRow> createState() => _IngredientRowState();
}

class _IngredientRowState extends State<_IngredientRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Name
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: widget.draft.nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Название',
                isDense: true,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),

          // Quantity
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: widget.draft.quantityCtrl,
              decoration: const InputDecoration(
                hintText: '0',
                isDense: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(width: 8),

          // Unit dropdown
          DropdownButton<MeasurementUnit>(
            value: widget.draft.unit,
            isDense: true,
            underline: const SizedBox(),
            items: MeasurementUnit.values
                .map((u) =>
                    DropdownMenuItem(value: u, child: Text(u.label)))
                .toList(),
            onChanged: (v) => setState(() => widget.draft.unit = v!),
          ),

          // Remove
          if (widget.onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: widget.onRemove,
              visualDensity: VisualDensity.compact,
            )
          else
            const SizedBox(width: 32),
        ],
      ),
    );
  }
}

// ── Instruction row ───────────────────────────────────────────────────────────

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({
    super.key,
    required this.step,
    required this.controller,
    required this.onRemove,
  });

  final int step;
  final TextEditingController controller;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Опишите шаг $step…',
              ),
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          if (onRemove != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
