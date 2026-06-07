import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/prefs_service.dart';

const kSupportedLocales = [
  Locale('en'),
  Locale('ru'),
  Locale('de'),
  Locale('es'),
  Locale('fr'),
  Locale('pl'),
];

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = sharedPrefs.getString(PrefsKeys.localeCode);
    return code != null ? Locale(code) : null;
  }

  void setLocale(Locale locale) {
    state = locale;
    sharedPrefs.setString(PrefsKeys.localeCode, locale.languageCode);
  }

  void resetToSystem() {
    state = null;
    sharedPrefs.remove(PrefsKeys.localeCode);
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);
