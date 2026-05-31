import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';

@immutable
class PremiumStatus {
  const PremiumStatus({this.expiresAt});

  final DateTime? expiresAt;

  bool get isActive {
    final exp = expiresAt;
    if (exp == null) return false;
    return exp.isAfter(DateTime.now());
  }

  Duration? get remaining {
    final exp = expiresAt;
    if (exp == null) return null;
    final diff = exp.difference(DateTime.now());
    return diff.isNegative ? null : diff;
  }
}

class PremiumStatusNotifier extends Notifier<PremiumStatus> {
  @override
  PremiumStatus build() {
    final ms = sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs);
    if (ms == null) return const PremiumStatus();
    return PremiumStatus(expiresAt: DateTime.fromMillisecondsSinceEpoch(ms));
  }

  void activateFor(Duration period) {
    final newExpiry = DateTime.now().add(period);
    final current = state.expiresAt;
    final next = (current != null && current.isAfter(newExpiry))
        ? current
        : newExpiry;
    state = PremiumStatus(expiresAt: next);
    sharedPrefs.setInt(PrefsKeys.premiumExpiresAtMs, next.millisecondsSinceEpoch);
  }

  void deactivate() {
    state = const PremiumStatus();
    sharedPrefs.remove(PrefsKeys.premiumExpiresAtMs);
  }
}

final premiumStatusProvider =
    NotifierProvider<PremiumStatusNotifier, PremiumStatus>(
        PremiumStatusNotifier.new);
