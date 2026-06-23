import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/categories_dao.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/sync/sync_provider.dart';
import '../../../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import '../../domain/entities/app_category.dart';

// ── Mapper ───────────────────────────────────────────────────────────────────

AppCategory _fromDb(CategoriesTableData d) => AppCategory(
      id: d.id,
      familyId: d.familyId,
      type: d.type,
      name: d.name,
      value: d.value,
      isSystem: d.isSystem,
      sortOrder: d.sortOrder,
      createdAt: DateTime.fromMillisecondsSinceEpoch(d.createdAt),
    );

// ── Providers ─────────────────────────────────────────────────────────────────

/// Watches all recipe categories (type='recipe') for the default family.
final recipeCategoriesProvider = StreamProvider<List<AppCategory>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoriesDao
      .watchByType(kDefaultFamilyId, 'recipe')
      .map((rows) => rows.map(_fromDb).toList());
});

/// Watches all cuisine categories (type='cuisine').
final cuisineCategoriesProvider = StreamProvider<List<AppCategory>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoriesDao
      .watchByType(kDefaultFamilyId, 'cuisine')
      .map((rows) => rows.map(_fromDb).toList());
});

/// Watches all pantry categories (type='pantry').
final pantryCategoriesProvider = StreamProvider<List<AppCategory>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoriesDao
      .watchByType(kDefaultFamilyId, 'pantry')
      .map((rows) => rows.map(_fromDb).toList());
});

// ── Notifier ─────────────────────────────────────────────────────────────────

class CategoriesNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  CategoriesDao get _dao => ref.read(appDatabaseProvider).categoriesDao;

  Future<void> addCategory({
    required String type,
    required String name,
  }) async {
    const uuid = Uuid();
    final value = '${type}_${uuid.v4().substring(0, 8)}';
    final now = DateTime.now().millisecondsSinceEpoch;

    await _dao.upsert(
      CategoriesTableCompanion(
        id: Value(uuid.v4()),
        familyId: const Value(kDefaultFamilyId),
        type: Value(type),
        name: Value(name.trim()),
        value: Value(value),
        isSystem: const Value(false),
        sortOrder: const Value(9999),
        createdAt: Value(now),
      ),
    );
  }

  Future<void> renameCategory(String id, String newName) async {
    await _dao.rename(id, newName.trim());
  }

  /// Deletes only custom (non-system) categories.
  /// Returns true if deleted, false if it was a system category.
  Future<bool> deleteCategory(String id) async {
    final deleted = await _dao.deleteCustom(id);
    if (deleted > 0) {
      // Propagate deletion to Firestore + write tombstone so other devices
      // delete this category on their next pull.
      await ref
          .read(syncServiceProvider)
          .deleteRemoteCategory(kDefaultFamilyId, id);
    }
    return deleted > 0;
  }
}

final categoriesNotifierProvider =
    AsyncNotifierProvider<CategoriesNotifier, void>(CategoriesNotifier.new);
