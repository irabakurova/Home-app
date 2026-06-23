import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/web_storage.dart';

/// Converts ThemeMode → storage string.
String themeModeToKey(ThemeMode mode) => switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'auto',
    };

/// Converts storage string → ThemeMode.
ThemeMode keyToThemeMode(String? key) => switch (key) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

/// Controls the app-wide theme mode.
/// On web the last choice is persisted to localStorage so that index.html
/// can set the correct body background before Flutter renders, preventing
/// a mismatched status-bar stripe when the app theme differs from the OS theme.
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => keyToThemeMode(loadThemeFromWeb()),
);
