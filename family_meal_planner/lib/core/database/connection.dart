// Platform-conditional database connection.
// On native (Android, Windows): NativeDatabase via dart:io + dart:ffi.
// On web (PWA/Safari): WebDatabase backed by IndexedDB via sql.js.
export 'connection_native.dart' if (dart.library.html) 'connection_web.dart';
