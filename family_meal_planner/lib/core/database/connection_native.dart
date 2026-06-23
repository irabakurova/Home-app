import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Returns a persistent SQLite database on native platforms (Android, Windows).
QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'family_meal_planner.db'));
    return NativeDatabase.createInBackground(file);
  });
}
