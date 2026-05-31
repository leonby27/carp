import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../forecast/application/forecast_providers.dart';
import '../../forecast/data/forecast_builder.dart';
import '../../forecast/data/open_meteo_client.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';
import '../../forecast/domain/weather_point.dart';
import '../../location/domain/geo_point.dart';
import '../../spots/application/spots_providers.dart';
import '../data/notification_service.dart';
import '../domain/bite_alert_planner.dart';
import '../domain/planned_alert.dart';
import 'alert_format.dart';

/// Сколько спотов максимум проверяем за один проход. Каждый спот — отдельный
/// запрос к Open-Meteo; кап бережёт старт приложения и трафик.
const _maxSpots = 6;

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

/// Один тумблер уведомлений: тип алёрта × вид рыбы.
typedef AlertOption = (BiteAlertKind kind, Fish fish);

String _prefsKey(BiteAlertKind kind, Fish fish) => switch ((kind, fish)) {
      (BiteAlertKind.primeWeek, Fish.carp) => PrefsKeys.notifPrimeCarp,
      (BiteAlertKind.primeWeek, Fish.crucian) => PrefsKeys.notifPrimeCrucian,
      (BiteAlertKind.excellentDays, Fish.carp) => PrefsKeys.notifExcellentCarp,
      (BiteAlertKind.excellentDays, Fish.crucian) =>
        PrefsKeys.notifExcellentCrucian,
    };

/// Набор включённых уведомлений о клёве. Источник истины — prefs; каждый тумблер
/// независим, мастер-переключателя нет. Дефолт — всё выключено (просим разрешение
/// и планируем только по явному включению).
class BiteAlerts extends Notifier<Set<AlertOption>> {
  @override
  Set<AlertOption> build() {
    final out = <AlertOption>{};
    for (final kind in BiteAlertKind.values) {
      for (final fish in Fish.values) {
        if (sharedPrefs.getBool(_prefsKey(kind, fish)) ?? false) {
          out.add((kind, fish));
        }
      }
    }
    return out;
  }

  bool isOn(BiteAlertKind kind, Fish fish) => state.contains((kind, fish));

  Future<void> set(BiteAlertKind kind, Fish fish, bool value) async {
    final next = {...state};
    if (value) {
      next.add((kind, fish));
    } else {
      next.remove((kind, fish));
    }
    state = next;
    await sharedPrefs.setBool(_prefsKey(kind, fish), value);
  }
}

final biteAlertsProvider =
    NotifierProvider<BiteAlerts, Set<AlertOption>>(BiteAlerts.new);

final biteAlertSchedulerProvider =
    Provider<BiteAlertScheduler>(BiteAlertScheduler.new);

/// Пере-планирует локальные алёрты о клёве по всем сохранённым спотам.
///
/// Подход без сервера и без фонового fetch: Open-Meteo отдаёт прогноз на дни
/// вперёд, поэтому прайм-окна известны уже сейчас — мы планируем точные
/// локальные уведомления и пере-синхронизируем их при каждом заходе (свежий
/// прогноз вытесняет устаревшие алёрты).
class BiteAlertScheduler {
  BiteAlertScheduler(this.ref);

  final Ref ref;

  Future<void> reschedule(
      {required AppLocalizations l10n, DateTime? now}) async {
    final service = ref.read(notificationServiceProvider);

    final enabled = ref.read(biteAlertsProvider);
    if (enabled.isEmpty) {
      await service.cancelAll();
      return;
    }
    final spots = ref.read(savedSpotsProvider);
    if (spots.isEmpty) {
      await service.cancelAll();
      return;
    }

    // Какие типы алёртов нужны для каждого вида рыбы.
    final kindsByFish = <Fish, Set<BiteAlertKind>>{};
    for (final (kind, fish) in enabled) {
      (kindsByFish[fish] ??= <BiteAlertKind>{}).add(kind);
    }

    final client = ref.read(openMeteoClientProvider);
    final at = now ?? DateTime.now();
    const planner = BiteAlertPlanner();

    // По одному сетевому запросу на спот (погода от рыбы не зависит); прогноз
    // считаем под каждую нужную рыбу. Падение одного спота не роняет набор.
    final perSpot = await Future.wait(spots.take(_maxSpots).map((s) async {
      try {
        final points = await _seriesPoints(client, s);
        return (
          spotName: s.name,
          forecasts: <Fish, Forecast>{
            for (final fish in kindsByFish.keys)
              fish: buildForecast(s.name, points,
                  fish: fish, latitude: s.latitude),
          },
        );
      } catch (_) {
        return null;
      }
    }));

    final notifs = <ScheduledNotification>[];
    for (final fish in kindsByFish.keys) {
      final bySpot = <({String spotName, Forecast forecast})>[
        for (final r in perSpot)
          if (r != null && r.forecasts[fish] != null)
            (spotName: r.spotName, forecast: r.forecasts[fish]!),
      ];
      if (bySpot.isEmpty) continue;
      final planned = planner.plan(
        fish: fish,
        bySpot: bySpot,
        kinds: kindsByFish[fish]!,
        now: at,
      );
      for (final a in planned) {
        notifs.add(buildScheduledNotification(a, l10n));
      }
    }
    await service.syncAlerts(notifs);
  }

  /// Свежий погодный ряд по споту, обрезанный до «сегодня и далее» и с дельтой
  /// температуры воды (OSM-тип водоёма для алёртов не тянем — лишний запрос).
  Future<List<WeatherPoint>> _seriesPoints(
      OpenMeteoClient client, GeoPoint spot) async {
    final series = await client.fetchSeries(spot);
    final w = [for (final p in series.points) p.waterTempC];
    final full = [
      for (var i = 0; i < series.points.length; i++)
        series.points[i].copyWith(
          waterTrendC: w[i] - w[i < 48 ? 0 : i - 48],
        ),
    ];
    final skip = (series.pastDays * 24).clamp(0, full.length);
    return full.sublist(skip);
  }
}
