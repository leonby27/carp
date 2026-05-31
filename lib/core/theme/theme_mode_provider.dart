import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/prefs_service.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final idx = sharedPrefs.getInt(PrefsKeys.themeMode);
    if (idx == null || idx < 0 || idx >= ThemeMode.values.length) {
      return ThemeMode.system;
    }
    return ThemeMode.values[idx];
  }

  void setMode(ThemeMode mode) {
    state = mode;
    sharedPrefs.setInt(PrefsKeys.themeMode, mode.index);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
