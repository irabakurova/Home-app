import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // create / update / delete
  TextColumn get payload => text()(); // JSON
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}
