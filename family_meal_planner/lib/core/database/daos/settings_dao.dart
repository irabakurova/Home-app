import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sync_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable, SyncQueueTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  // ── App Settings ──────────────────────────────────────────────────────────

  Future<String?> getValue(String key) async {
    final row = await (select(appSettingsTable)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setValue(String key, String value) =>
      into(appSettingsTable).insertOnConflictUpdate(
        AppSettingsTableCompanion(
          key: Value(key),
          value: Value(value),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  // ── Sync Queue ────────────────────────────────────────────────────────────

  Future<List<SyncQueueTableData>> getPendingSync() =>
      (select(syncQueueTable)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<int> enqueueSyncItem(SyncQueueTableCompanion item) =>
      into(syncQueueTable).insert(item);

  Future<int> deleteSyncItem(String id) =>
      (delete(syncQueueTable)..where((t) => t.id.equals(id))).go();

  Future<void> incrementRetry(String id) async {
    await customUpdate(
      'UPDATE sync_queue SET retry_count = retry_count + 1 WHERE id = ?',
      variables: [Variable.withString(id)],
      updates: {syncQueueTable},
    );
  }
}
