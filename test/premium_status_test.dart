import 'package:app/core/persistence/prefs_service.dart';
import 'package:app/features/paywall/data/premium_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await initPrefs();
  });

  setUp(() async {
    await sharedPrefs.remove(PrefsKeys.premiumExpiresAtMs);
  });

  group('PremiumStatus (value)', () {
    test('null expiry → неактивен, remaining == null', () {
      const s = PremiumStatus();
      expect(s.isActive, isFalse);
      expect(s.remaining, isNull);
    });

    test('будущий expiry → активен, remaining > 0', () {
      final s = PremiumStatus(expiresAt: DateTime.now().add(const Duration(hours: 1)));
      expect(s.isActive, isTrue);
      expect(s.remaining, isNotNull);
      expect(s.remaining!.inMinutes, greaterThan(0));
    });

    test('прошедший expiry → неактивен, remaining == null', () {
      final s = PremiumStatus(expiresAt: DateTime.now().subtract(const Duration(hours: 1)));
      expect(s.isActive, isFalse);
      expect(s.remaining, isNull);
    });
  });

  group('PremiumStatusNotifier', () {
    test('activateFor активирует и пишет в prefs', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(premiumStatusProvider.notifier).activateFor(const Duration(days: 1));
      expect(c.read(premiumStatusProvider).isActive, isTrue);
      expect(sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs), isNotNull);
    });

    test('activateFor НЕ укорачивает уже действующий более длинный срок', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(premiumStatusProvider.notifier);
      n.activateFor(const Duration(days: 365));
      final longExpiry = c.read(premiumStatusProvider).expiresAt;
      // Подарок на 1 день поверх годовой — срок не должен сократиться.
      n.activateFor(const Duration(days: 1));
      expect(c.read(premiumStatusProvider).expiresAt, longExpiry);
    });

    test('activateFor продлевает, если новый срок дальше текущего', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(premiumStatusProvider.notifier);
      n.activateFor(const Duration(days: 1));
      final shortExpiry = c.read(premiumStatusProvider).expiresAt!;
      n.activateFor(const Duration(days: 30));
      expect(c.read(premiumStatusProvider).expiresAt!.isAfter(shortExpiry), isTrue);
    });

    test('deactivate сбрасывает state и чистит prefs', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(premiumStatusProvider.notifier);
      n.activateFor(const Duration(days: 1));
      n.deactivate();
      expect(c.read(premiumStatusProvider).isActive, isFalse);
      expect(sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs), isNull);
    });

    test('старт с действующим premium из prefs → активен', () async {
      await sharedPrefs.setInt(
        PrefsKeys.premiumExpiresAtMs,
        DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch,
      );
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(premiumStatusProvider).isActive, isTrue);
    });

    test('старт с истёкшим premium из prefs → неактивен и prefs очищены', () async {
      await sharedPrefs.setInt(
        PrefsKeys.premiumExpiresAtMs,
        DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
      );
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(premiumStatusProvider).isActive, isFalse);
      expect(sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs), isNull);
    });

    test('по таймеру premium сам переходит в «истёк» и чистит prefs', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(premiumStatusProvider.notifier).activateFor(const Duration(milliseconds: 120));
      expect(c.read(premiumStatusProvider).isActive, isTrue);

      // Ждём чуть дольше срока — таймер истечения должен сработать сам.
      await Future<void>.delayed(const Duration(milliseconds: 240));

      expect(c.read(premiumStatusProvider).isActive, isFalse);
      expect(c.read(premiumStatusProvider).expiresAt, isNull);
      expect(sharedPrefs.getInt(PrefsKeys.premiumExpiresAtMs), isNull);
    });
  });
}
