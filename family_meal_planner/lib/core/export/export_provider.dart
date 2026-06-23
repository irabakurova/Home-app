import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import 'export_service.dart';
import 'import_service.dart';

// ── Service providers ─────────────────────────────────────────────────────────

final exportServiceProvider = Provider<ExportService>(
  (_) => const ExportService(),
);

final importServiceProvider = Provider<ImportService>(
  (_) => const ImportService(),
);

// ── State ─────────────────────────────────────────────────────────────────────

enum ExportImportStatus { idle, loading, success, error }

class ExportImportState {
  const ExportImportState({
    this.status = ExportImportStatus.idle,
    this.message,
    this.error,
  });

  final ExportImportStatus status;

  /// Human-readable success message (file path or import summary).
  final String? message;

  /// Error message on failure.
  final String? error;

  ExportImportState copyWith({
    ExportImportStatus? status,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) =>
      ExportImportState(
        status: status ?? this.status,
        message: clearMessage ? null : (message ?? this.message),
        error: clearError ? null : (error ?? this.error),
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ExportImportNotifier extends AutoDisposeNotifier<ExportImportState> {
  @override
  ExportImportState build() => const ExportImportState();

  Future<void> export() async {
    if (state.status == ExportImportStatus.loading) return;
    state = const ExportImportState(status: ExportImportStatus.loading);

    try {
      final db = ref.read(appDatabaseProvider);
      final svc = ref.read(exportServiceProvider);
      final result = await svc.exportToFile(db);

      state = ExportImportState(
        status: ExportImportStatus.success,
        message: 'Сохранено: ${result.filePath}\n${result.stats.summary}',
      );
    } catch (e) {
      state = ExportImportState(
        status: ExportImportStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> import() async {
    if (state.status == ExportImportStatus.loading) return;
    state = const ExportImportState(status: ExportImportStatus.loading);

    try {
      final db = ref.read(appDatabaseProvider);
      final svc = ref.read(importServiceProvider);
      final result = await svc.importFromFile(db);

      if (result == null) {
        // User cancelled the file picker
        state = const ExportImportState();
        return;
      }

      state = ExportImportState(
        status: ExportImportStatus.success,
        message: 'Импортировано. ${result.summary}',
      );
    } catch (e) {
      state = ExportImportState(
        status: ExportImportStatus.error,
        error: e.toString(),
      );
    }
  }

  void reset() => state = const ExportImportState();
}

// ── Provider ──────────────────────────────────────────────────────────────────

final exportImportProvider =
    AutoDisposeNotifierProvider<ExportImportNotifier, ExportImportState>(
  ExportImportNotifier.new,
);
