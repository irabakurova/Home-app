// Platform-conditional export service.
// On native (Android, Windows): writes JSON file to app documents folder.
// On web (PWA): throws UnsupportedError — data persists via Firestore.
export 'export_service_native.dart'
    if (dart.library.html) 'export_service_web.dart';
