import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/export/export_provider.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/sync/sync_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/update/update_provider.dart';
import '../../../../core/utils/web_storage.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          // ── Categories ──────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Управление категориями'),
            subtitle: const Text('Категории блюд, кухни и продукты'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(RouteNames.categories),
          ),
          const Divider(),

          // ── Sync ────────────────────────────────────────────────────────
          _SyncSection(),
          const Divider(),

          // ── Export / Import ─────────────────────────────────────────────
          _ExportImportSection(),
          const Divider(),

          // ── Theme ───────────────────────────────────────────────────────
          _ThemeSection(),
          const Divider(),

          // ── App update ──────────────────────────────────────────────────
          _UpdateSection(),
        ],
      ),
    );
  }
}

// ── Sync section widget ───────────────────────────────────────────────────────

class _SyncSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = ref.watch(isSyncingProvider);
    final lastSyncAt = ref.watch(lastSyncAtProvider);
    final syncError = ref.watch(syncErrorProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String subtitle;
    if (isSyncing) {
      subtitle = 'Синхронизация…';
    } else if (syncError != null) {
      subtitle = 'Ошибка синхронизации';
    } else if (lastSyncAt != null) {
      final fmt = DateFormat('d MMM, HH:mm', 'ru');
      subtitle = 'Последняя синхронизация: ${fmt.format(lastSyncAt)}';
    } else {
      subtitle = 'Ещё не синхронизировано';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: isSyncing
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.primary,
                  ),
                )
              : Icon(
                  syncError != null
                      ? Icons.sync_problem_outlined
                      : Icons.sync_outlined,
                  color: syncError != null
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
          title: const Text('Синхронизация'),
          subtitle: Text(subtitle),
          trailing: isSyncing
              ? null
              : TextButton(
                  onPressed: () =>
                      ref.read(syncNotifierProvider.notifier).syncNow(),
                  child: const Text('Синхронизировать'),
                ),
        ),

        // Error detail card
        if (syncError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline,
                        color: colorScheme.onErrorContainer, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        syncError,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Info about sync behaviour
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Данные синхронизируются через Firebase Firestore. '
            'Изменения на любом устройстве станут доступны после синхронизации.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Export / Import section ───────────────────────────────────────────────────

class _ExportImportSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportImportProvider);
    final notifier = ref.read(exportImportProvider.notifier);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isLoading = state.status == ExportImportStatus.loading;

    // Show snackbar on success or error after each state change
    ref.listen(exportImportProvider, (prev, next) {
      if (next.status == ExportImportStatus.success && next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'ОК',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                notifier.reset();
              },
            ),
          ),
        );
        notifier.reset();
      } else if (next.status == ExportImportStatus.error &&
          next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${next.error}'),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'ОК',
              textColor: colorScheme.onError,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                notifier.reset();
              },
            ),
          ),
        );
        notifier.reset();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Export ───────────────────────────────────────────────────────
        ListTile(
          leading: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.primary,
                  ),
                )
              : Icon(Icons.upload_file_outlined,
                  color: colorScheme.onSurfaceVariant),
          title: const Text('Экспорт данных'),
          subtitle: const Text('Сохранить резервную копию в JSON'),
          trailing: isLoading
              ? null
              : TextButton(
                  onPressed: notifier.export,
                  child: const Text('Экспорт'),
                ),
        ),

        // ── Import ───────────────────────────────────────────────────────
        ListTile(
          leading: isLoading
              ? const SizedBox(width: 24, height: 24)
              : Icon(Icons.download_for_offline_outlined,
                  color: colorScheme.onSurfaceVariant),
          title: const Text('Импорт данных'),
          subtitle: const Text('Восстановить из резервной копии'),
          trailing: isLoading
              ? null
              : TextButton(
                  onPressed: () => _confirmImport(context, notifier),
                  child: const Text('Импорт'),
                ),
        ),

        // ── Info ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Экспорт сохраняет все рецепты, кладовую, меню, покупки и историю '
            'в файл JSON. При импорте существующие записи с совпадающим ID '
            'будут обновлены.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmImport(
    BuildContext context, ExportImportNotifier notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Импорт данных'),
        content: const Text(
          'Выберите JSON-файл резервной копии.\n\n'
          'Существующие записи с совпадающим ID будут обновлены. '
          'Остальные данные останутся без изменений.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Выбрать файл'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.import();
    }
  }
}

// ── Theme section widget ──────────────────────────────────────────────────────

class _ThemeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            mode == ThemeMode.dark
                ? Icons.dark_mode_outlined
                : mode == ThemeMode.light
                    ? Icons.light_mode_outlined
                    : Icons.brightness_auto_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
          title: const Text('Тема оформления'),
          subtitle: Text(_modeLabel(mode)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined, size: 18),
                label: Text('Светлая'),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined, size: 18),
                label: Text('Авто'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined, size: 18),
                label: Text('Тёмная'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selected) {
              final newMode = selected.first;
              ref.read(themeModeProvider.notifier).state = newMode;
              // Persist choice for next launch.
              saveThemeToWeb(themeModeToKey(newMode));
              // Update the HTML body background AFTER Flutter's frame so we
              // don't trigger a browser reflow mid-animation (which caused
              // the visible "hang with bar" glitch).
              final sysDark =
                  MediaQuery.platformBrightnessOf(context) == Brightness.dark;
              final isDark = newMode == ThemeMode.dark ||
                  (newMode == ThemeMode.system && sysDark);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setBodyBackground(isDark: isDark);
              });
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _modeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Светлая тема',
        ThemeMode.dark => 'Тёмная тема',
        ThemeMode.system => 'По настройкам системы',
      };
}

// ── Update section widget ─────────────────────────────────────────────────────

/// Секция обновления видна только на Android и Windows.
/// На web/iOS обновления происходят автоматически — секция скрыта.
class _UpdateSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PWA / iOS — обновления автоматические, секция не нужна.
    if (kIsWeb) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final versionAsync = ref.watch(currentVersionProvider);
    final checkAsync = ref.watch(updateCheckProvider);
    final downloadState = ref.watch(downloadProvider);

    final currentVersion = versionAsync.valueOrNull ?? '…';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Заголовок с текущей версией ─────────────────────────────────
        ListTile(
          leading: Icon(Icons.system_update_outlined,
              color: colorScheme.onSurfaceVariant),
          title: const Text('Версия приложения'),
          subtitle: Text('Установлена: $currentVersion'),
        ),

        // ── Статус проверки / кнопка обновления ─────────────────────────
        checkAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Проверяю обновления…',
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
            child: Text(
              'Не удалось проверить обновления',
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          data: (result) {
            if (result is UpdateNotAvailable) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text('Актуальная версия',
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              );
            }

            if (result is UpdateCheckError) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
                child: Text(
                  (result).message,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.error),
                ),
              );
            }

            // UpdateAvailable
            final info = (result as UpdateAvailable).info;
            return _UpdateAvailableCard(info: info);
          },
        ),

        // ── Прогресс загрузки (Windows) ─────────────────────────────────
        if (downloadState.isDownloading)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Скачиваю обновление… ${(downloadState.progress * 100).toStringAsFixed(0)}%',
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: downloadState.progress,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

        if (downloadState.error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Ошибка загрузки: ${downloadState.error}',
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),

        if (downloadState.done)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Установщик запущен. Следуйте инструкциям.',
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),

        // ── Кнопка повторной проверки ────────────────────────────────────
        if (!downloadState.isDownloading && !downloadState.done)
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 16, 16),
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Проверить снова'),
              onPressed: () => ref.invalidate(updateCheckProvider),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: textTheme.labelMedium,
              ),
            ),
          ),
      ],
    );
  }
}

/// Карточка с информацией о доступном обновлении + кнопка.
class _UpdateAvailableCard extends ConsumerWidget {
  const _UpdateAvailableCard({required this.info});
  final UpdateInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final downloadState = ref.watch(downloadProvider);

    final bool isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final bool isWindows =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Card(
        color: colorScheme.primaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.new_releases_outlined,
                      color: colorScheme.onPrimaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Доступно обновление ${info.version}',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (info.releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  info.releaseNotes,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: isWindows
                      ? const Text('Скачать и установить')
                      : const Text('Обновить'),
                  onPressed: downloadState.isDownloading
                      ? null
                      : () => _onUpdate(context, ref, isAndroid, isWindows),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.onPrimaryContainer,
                    foregroundColor: colorScheme.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    BuildContext context,
    WidgetRef ref,
    bool isAndroid,
    bool isWindows,
  ) async {
    if (isAndroid) {
      // Открываем ссылку в браузере — браузер скачает APK и предложит установку.
      final uri = Uri.parse(info.androidUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    } else if (isWindows) {
      await ref.read(downloadProvider.notifier).startDownload(info);
    }
  }
}
