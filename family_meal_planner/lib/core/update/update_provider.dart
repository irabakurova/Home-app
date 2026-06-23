import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_info.dart';
import 'update_service.dart';

export 'update_info.dart';
export 'update_service.dart';

// ── Текущая версия ─────────────────────────────────────────────────────────

final currentVersionProvider = FutureProvider<String>((ref) async {
  return UpdateService.instance.currentVersion();
});

// ── Результат проверки обновления ──────────────────────────────────────────

final updateCheckProvider = FutureProvider<UpdateCheckResult>((ref) async {
  return UpdateService.instance.checkForUpdate();
});

// ── Состояние загрузки обновления (только Windows) ─────────────────────────

class DownloadState {
  const DownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.error,
    this.done = false,
  });

  final bool isDownloading;
  final double progress;
  final String? error;
  final bool done;

  DownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    bool? done,
  }) =>
      DownloadState(
        isDownloading: isDownloading ?? this.isDownloading,
        progress: progress ?? this.progress,
        error: error,
        done: done ?? this.done,
      );
}

class DownloadNotifier extends Notifier<DownloadState> {
  @override
  DownloadState build() => const DownloadState();

  Future<void> startDownload(UpdateInfo info) async {
    state = const DownloadState(isDownloading: true, progress: 0);

    final error = await UpdateService.instance.downloadAndInstallWindows(
      info,
      (p) => state = state.copyWith(progress: p),
    );

    if (error != null) {
      state = DownloadState(error: error);
    } else {
      state = const DownloadState(done: true);
    }
  }

  void reset() => state = const DownloadState();
}

final downloadProvider = NotifierProvider<DownloadNotifier, DownloadState>(
  DownloadNotifier.new,
);
