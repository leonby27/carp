import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env.dart';
import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'l10n/app_localizations.dart';

class BaseApp extends ConsumerWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final overrideLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: Env.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // null → используется системная локаль, иначе пользовательский override.
      locale: overrideLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      // English как явный fallback — если системная локаль не поддерживается.
      localeListResolutionCallback: (deviceLocales, supported) {
        if (deviceLocales != null) {
          for (final locale in deviceLocales) {
            for (final supp in supported) {
              if (locale.languageCode == supp.languageCode) return supp;
            }
          }
        }
        return const Locale('en');
      },
      builder: (context, child) => DefaultTextStyle.merge(
        style: const TextStyle(letterSpacing: 0),
        child: child!,
      ),
    );
  }
}
