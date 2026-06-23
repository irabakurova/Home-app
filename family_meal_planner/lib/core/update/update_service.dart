import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'update_info.dart';

/// URL файла с информацией о текущей версии на Firebase Hosting.
const _versionUrl =
    'https://family-meal-planner-67475.web.app/version.json';

/// Результат проверки обновления.
sealed class UpdateCheckResult {}

class UpdateAvailable extends UpdateCheckResult {
  UpdateAvailable(this.info);
  final UpdateInfo info;
}

class UpdateNotAvailable extends UpdateCheckResult {}

class UpdateCheckError extends UpdateCheckResult {
  UpdateCheckError(this.message);
  final String message;
}

/// Прогресс загрузки обновления (0.0 – 1.0).
typedef DownloadProgressCallback = void Function(double progress);

class UpdateService {
  UpdateService._();
  static final instance = UpdateService._();

  // ── Проверка версии ─────────────────────────────────────────────────────

  Future<UpdateCheckResult> checkForUpdate() async {
    // На web обновления автоматические — проверка не нужна.
    if (kIsWeb) return UpdateNotAvailable();
    // Только Android и Windows поддерживают ручное обновление.
    if (!Platform.isAndroid && !Platform.isWindows) return UpdateNotAvailable();

    try {
      final response = await http
          .get(Uri.parse(_versionUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return UpdateCheckError('Сервер вернул ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final remote = UpdateInfo.fromJson(json);

      final info = await PackageInfo.fromPlatform();
      final localBuild = int.tryParse(info.buildNumber) ?? 0;

      if (remote.buildNumber > localBuild) {
        return UpdateAvailable(remote);
      }
      return UpdateNotAvailable();
    } on SocketException {
      return UpdateCheckError('Нет подключения к интернету');
    } catch (e) {
      return UpdateCheckError(e.toString());
    }
  }

  // ── Загрузка и установка (Windows) ──────────────────────────────────────

  /// Скачивает EXE-установщик с прогрессом и запускает его.
  /// Возвращает null при успехе или строку с ошибкой.
  Future<String?> downloadAndInstallWindows(
    UpdateInfo info,
    DownloadProgressCallback onProgress,
  ) async {
    assert(Platform.isWindows);
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(info.windowsUrl));
      final response = await client.send(request);

      final total = response.contentLength ?? 0;
      int downloaded = 0;
      final bytes = <int>[];

      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        downloaded += chunk.length;
        if (total > 0) onProgress(downloaded / total);
      }
      client.close();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}\\EasilyKitchen-setup.exe');
      await file.writeAsBytes(bytes);

      // Запускаем установщик — он сам закроет текущую версию если нужно.
      await Process.start(
        file.path,
        [],
        mode: ProcessStartMode.detached,
        runInShell: false,
      );
      return null; // успех
    } catch (e) {
      return e.toString();
    }
  }

  // ── Текущая версия ──────────────────────────────────────────────────────

  Future<String> currentVersion() async {
    if (kIsWeb) return '';
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return '';
    }
  }
}
