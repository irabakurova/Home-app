// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

const _darkBg = '#141C19';
const _lightBg = '#FFFDF7';

/// Saves the selected theme to localStorage so index.html can read it
/// before Flutter renders, eliminating the status-bar colour mismatch.
void saveThemeToWeb(String mode) {
  try {
    html.window.localStorage['ek_theme'] = mode;
  } catch (_) {}
}

/// Returns the saved theme string ('light' | 'dark' | 'auto') or null.
String? loadThemeFromWeb() {
  try {
    return html.window.localStorage['ek_theme'];
  } catch (_) {
    return null;
  }
}

/// Immediately updates the HTML body background colour so the transparent
/// status bar shows the correct colour without requiring an app restart.
/// [isDark] is the *resolved* brightness (system preference already applied).
void setBodyBackground({required bool isDark}) {
  try {
    final color = isDark ? _darkBg : _lightBg;
    html.document.documentElement?.style.backgroundColor = color;
    html.document.body?.style.backgroundColor = color;
  } catch (_) {}
}
