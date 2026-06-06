import 'dart:async';

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
  /// Срабатывает ровно в момент истечения, чтобы перевести state в «неактивно»
  /// и заставить слушателей (карточка подписки и т.п.) перестроиться сами —
  /// без этого UI «зависал» бы на «активно», т.к. expiresAt не меняется.
  Timer? _expiryTimer;

  @override
  PremiumStatus build() {
    ref.onDispose(() => _expiryTimer?.cancel());

    final ms = sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs);
    if (ms == null) return const PremiumStatus();

    final expiry = DateTime.fromMillisecondsSinceEpoch(ms);
    // Срок уже истёк (например, между сессиями) — чистим хвост в prefs и
    // стартуем как неактивный, а не тащим протухший timestamp.
    if (!expiry.isAfter(DateTime.now())) {
      sharedPrefs.remove(PrefsKeys.premiumExpiresAtMs);
      return const PremiumStatus();
    }

    _scheduleExpiry(expiry);
    return PremiumStatus(expiresAt: expiry);
  }

  /// Активировать/продлить Pro на [period]. Никогда не укорачиваем уже
  /// действующий срок (важно для стэка промо + win-back подарка).
  void activateFor(Duration period) {
    final newExpiry = DateTime.now().add(period);
    final current = state.expiresAt;
    final next = (current != null && current.isAfter(newExpiry))
        ? current
        : newExpiry;
    state = PremiumStatus(expiresAt: next);
    sharedPrefs.setInt(PrefsKeys.premiumExpiresAtMs, next.millisecondsSinceEpoch);
    _scheduleExpiry(next);
  }

  void deactivate() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
    state = const PremiumStatus();
    sharedPrefs.remove(PrefsKeys.premiumExpiresAtMs);
  }

  void _scheduleExpiry(DateTime expiry) {
    _expiryTimer?.cancel();
    final delay = expiry.difference(DateTime.now());
    if (delay.isNegative || delay == Duration.zero) {
      _expireNow();
      return;
    }
    _expiryTimer = Timer(delay, _expireNow);
  }

  void _expireNow() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
    state = const PremiumStatus();
    sharedPrefs.remove(PrefsKeys.premiumExpiresAtMs);
  }
}

final premiumStatusProvider =
    NotifierProvider<PremiumStatusNotifier, PremiumStatus>(
        PremiumStatusNotifier.new);
