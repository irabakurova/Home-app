import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/sync/sync_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Warm up the SyncNotifier after the first frame so it
    // calls build() → sets up connectivity listener → runs initial sync.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(syncNotifierProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Re-trigger sync whenever the user signs in (prev=null → current=user).
    ref.listen(authStateProvider, (prev, next) {
      final user = next.valueOrNull;
      final prevUser = prev?.valueOrNull;
      if (user != null && prevUser == null) {
        ref.read(syncNotifierProvider.notifier).syncNow();
      }
    });

    return MaterialApp.router(
      title: 'Easily Kitchen',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),

      // Router
      routerConfig: appRouter,

      // Localizations (Russian dates, etc.)
      locale: const Locale('ru', 'RU'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
    );
  }
}
