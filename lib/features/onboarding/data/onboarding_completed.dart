import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';

/// `true` если пользователь хотя бы раз прошёл welcome → quiz → paywall.
/// Влияет на роутер: при `true` старт сразу с `/`, иначе с `/welcome`.
class OnboardingCompletedNotifier extends Notifier<bool> {
  @override
  bool build() => sharedPrefs.getBool(PrefsKeys.onboardingCompleted) ?? false;

  void markCompleted() {
    state = true;
    sharedPrefs.setBool(PrefsKeys.onboardingCompleted, true);
  }

  void reset() {
    state = false;
    sharedPrefs.remove(PrefsKeys.onboardingCompleted);
  }
}

final onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
        OnboardingCompletedNotifier.new);
