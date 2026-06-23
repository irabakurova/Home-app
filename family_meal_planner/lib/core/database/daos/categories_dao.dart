import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  // ── Watch ──────────────────────────────────────────────────────────────────

  Stream<List<CategoriesTableData>> watchByType(
          String familyId, String type) =>
      (select(categoriesTable)
            ..where((t) =>
                t.familyId.equals(familyId) & t.type.equals(type))
            ..orderBy([
              (t) => OrderingTerm.asc(t.isSystem),   // system first
              (t) => OrderingTerm.asc(t.sortOrder),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .watch();

  Future<List<CategoriesTableData>> getByType(
          String familyId, String type) =>
      (select(categoriesTable)
            ..where((t) =>
                t.familyId.equals(familyId) & t.type.equals(type))
            ..orderBy([
              (t) => OrderingTerm.asc(t.isSystem),
              (t) => OrderingTerm.asc(t.sortOrder),
              (t) => OrderingTerm.asc(t.name),
            ]))
          .get();

  // ── Upsert / Add ──────────────────────────────────────────────────────────

  Future<void> upsert(CategoriesTableCompanion entry) =>
      into(categoriesTable).insertOnConflictUpdate(entry);

  // ── Delete (custom only) ──────────────────────────────────────────────────

  Future<int> deleteCustom(String id) =>
      (delete(categoriesTable)
            ..where((t) => t.id.equals(id) & t.isSystem.equals(false)))
          .go();

  // ── Rename ────────────────────────────────────────────────────────────────

  Future<void> rename(String id, String newName) =>
      (update(categoriesTable)..where((t) => t.id.equals(id))).write(
        CategoriesTableCompanion(name: Value(newName)),
      );

  // ── Sync helpers ──────────────────────────────────────────────────────────

  /// Returns all categories (all types) for a family — used by sync push.
  Future<List<CategoriesTableData>> getAll(String familyId) =>
      (select(categoriesTable)
            ..where((t) => t.familyId.equals(familyId)))
          .get();

  // ── Check existence by value ──────────────────────────────────────────────

  Future<bool> valueExists(
      String familyId, String type, String value) async {
    final row = await (select(categoriesTable)
          ..where((t) =>
              t.familyId.equals(familyId) &
              t.type.equals(type) &
              t.value.equals(value)))
        .getSingleOrNull();
    return row != null;
  }
}
