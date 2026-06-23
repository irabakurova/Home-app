// Conditional export: dart:html implementation on web, stub elsewhere.
export 'web_storage_stub.dart'
    if (dart.library.html) 'web_storage_web.dart';
