// Platform-conditional import service.
// On native (Android, Windows): reads JSON file from disk via file picker.
// On web (PWA): throws UnsupportedError — data persists via Firestore.
export 'import_service_native.dart'
    if (dart.library.html) 'import_service_web.dart';
