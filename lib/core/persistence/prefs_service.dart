import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Глобальная инициализированная инстанция SharedPreferences.
///
/// Инициализируется ровно один раз в `main()` ДО `runApp()`, после чего
/// доступна синхронно из любого Notifier'а. Это позволяет в Notifier.build()
/// сразу вернуть значение из storage, не делая async-инициализацию.
late final SharedPreferences sharedPrefs;

/// Абсолютный путь к documents-папке приложения. Храним файлы заметок (фото)
/// здесь; в самих заметках держим только ИМЯ файла и собираем путь на лету —
/// на iOS абсолютный путь контейнера меняется между обновлениями.
late final String appDocsPath;

/// Ключи под все persistable значения. Держим в одном месте, чтобы не было
/// рассинхрона между записью и чтением.
class PrefsKeys {
  PrefsKeys._();

  static const localeCode = 'locale_code';
  static const themeMode = 'theme_mode';
  static const onboardingCompleted = 'onboarding_completed';
  static const answers = 'quiz_answers'; // JSON-encoded Map<String, String>
  static const premiumExpiresAtMs = 'premium_expires_at_ms';
  static const notifAll = 'notif_all_enabled';
  static const notifReminders = 'notif_reminders';
  static const notifNews = 'notif_news';
  // Алёрты о клёве: отдельный bool на каждую пару тип×рыба (мастера нет).
  static const notifPrimeCarp = 'notif_prime_carp';
  static const notifPrimeCrucian = 'notif_prime_crucian';
  static const notifExcellentCarp = 'notif_excellent_carp';
  static const notifExcellentCrucian = 'notif_excellent_crucian';
  static const activeLocation = 'active_location'; // JSON-encoded GeoPoint
  static const savedSpots = 'saved_spots'; // JSON-encoded List<GeoPoint>
  static const tempUnit = 'temp_unit'; // TempUnit.index
  static const windUnit = 'wind_unit'; // WindUnit.index
  static const pressureUnit = 'pressure_unit'; // PressureUnit.index
  static const notes = 'notes'; // JSON-encoded List<Note>
  // Офлайн-кэш последнего успешного ответа погоды: сырой JSON + координаты (для
  // проверки, что кэш относится к текущей локации) + момент загрузки.
  static const cachedWeatherJson = 'cached_weather_json';
  static const cachedWeatherLat = 'cached_weather_lat';
  static const cachedWeatherLon = 'cached_weather_lon';
  static const cachedWeatherAtMs = 'cached_weather_at_ms';
}

Future<void> initPrefs() async {
  sharedPrefs = await SharedPreferences.getInstance();
  try {
    appDocsPath = (await getApplicationDocumentsDirectory()).path;
  } catch (_) {
    // В тестах канал path_provider не замокан — фото-функции там не нужны.
    appDocsPath = '';
  }
}
