import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';

class AnswersStore extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    final raw = sharedPrefs.getString(PrefsKeys.answers);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  void set(String key, String value) {
    state = {...state, key: value};
    _persist();
  }

  String? get(String key) => state[key];

  void reset() {
    state = {};
    sharedPrefs.remove(PrefsKeys.answers);
  }

  void _persist() {
    sharedPrefs.setString(PrefsKeys.answers, jsonEncode(state));
  }
}

final answersProvider =
    NotifierProvider<AnswersStore, Map<String, String>>(AnswersStore.new);
