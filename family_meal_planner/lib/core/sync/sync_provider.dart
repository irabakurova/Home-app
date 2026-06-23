import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import '../../features/recipes/presentation/providers/recipes_provider.dart'
    show kDefaultFamilyId;
import 'firestore_sync_service.dart';

// ── Service provider ──────────────────────────────────────────────────────────

final syncServiceProvider = Provider<FirestoreSyncService>((ref) {
  return FirestoreSyncService(FirebaseFirestore.instance);
});

// ── Sync state ────────────────────────────────────────────────────────────────

class SyncState {
  const SyncState({
    this.isSyncing = false,
    this.lastSyncAt,
    this.error,
  });

  final bool isSyncing;
  final DateTime? lastSyncAt;
  final String? error;

  SyncState copyWith({
    bool? isSyncing,
    DateTime? lastSyncAt,
    String? error,
    bool clearError = false,
  }) =>
      SyncState(
        isSyncing: isSyncing ?? this.isSyncing,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
        error: clearError ? null : (error ?? this.error),
      );
}

// ── Sync notifier ─────────────────────────────────────────────────────────────

class SyncNotifier extends AsyncNotifier<SyncState> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;

  @override
  Future<SyncState> build() async {
    // Watch connectivity changes to auto-sync when coming back online
    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      (results) => _onConnectivityChanged(results),
    );

    ref.onDispose(() {
      _connectivitySub?.cancel();
    });

    // Initial sync on app start
    await _doSync();
    return const SyncState();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (_wasOffline && isOnline) {
      // Came back online — trigger sync
      syncNow();
    }
    _wasOffline = !isOnline;
  }

  /// Pull all data from Firestore into local SQLite.
  Future<void> syncNow() async {
    await _doSync();
  }

  Future<void> _doSync() async {
    final currentState = state.valueOrNull ?? const SyncState();
    if (currentState.isSyncing) return; // already syncing

    state = AsyncData(currentState.copyWith(isSyncing: true, clearError: true));

    try {
      const familyId = kDefaultFamilyId;

      final db = ref.read(appDatabaseProvider);
      final syncSvc = ref.read(syncServiceProvider);

      // Push local → remote first (so our deletions reach Firestore)
      await syncSvc.pushAll(familyId, db);
      // Then pull remote → local (get other device's changes)
      await syncSvc.pullAll(familyId, db);

      state = AsyncData(SyncState(lastSyncAt: DateTime.now()));
    } catch (e) {
      state = AsyncData(
        (state.valueOrNull ?? const SyncState()).copyWith(
          isSyncing: false,
          error: e.toString(),
        ),
      );
    }
  }
}

final syncNotifierProvider =
    AsyncNotifierProvider<SyncNotifier, SyncState>(SyncNotifier.new);

// ── Convenience providers ──────────────────────────────────────────────────────

/// true while a sync operation is in progress.
final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(syncNotifierProvider).valueOrNull?.isSyncing ?? false;
});

/// The last successful sync timestamp, or null if never synced.
final lastSyncAtProvider = Provider<DateTime?>((ref) {
  return ref.watch(syncNotifierProvider).valueOrNull?.lastSyncAt;
});

/// The last sync error message, or null if no error.
final syncErrorProvider = Provider<String?>((ref) {
  return ref.watch(syncNotifierProvider).valueOrNull?.error;
});
