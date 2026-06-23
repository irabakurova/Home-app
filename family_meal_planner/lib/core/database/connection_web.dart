// ignore: deprecated_member_use
import 'package:drift/web.dart';
import 'package:drift/drift.dart';

/// Returns an IndexedDB-backed SQLite database for Flutter Web (PWA).
/// Data persists across sessions in the browser's IndexedDB.
/// All persistent data is synced from Firebase Firestore on first launch.
// ignore: deprecated_member_use
QueryExecutor openDatabaseConnection() {
  // ignore: deprecated_member_use
  return WebDatabase.withStorage(
    // ignore: deprecated_member_use, experimental_member_use
    DriftWebStorage.indexedDb('family_meal_planner'),
  );
}
