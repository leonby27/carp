import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/forecast/domain/weather_point.dart' show hpaToMmHg;
import '../../l10n/app_localizations.dart';
import '../persistence/prefs_service.dart';

/// Единицы измерения, выбранные пользователем. Данные и движок клёва всегда
/// хранятся в метрике (°C, м/с, гПа) — конверсия только на отображении.
enum TempUnit { celsius, fahrenheit }

enum WindUnit { ms, kmh }

enum PressureUnit { hpa, mmhg }

class Units {
  const Units({
    required this.temp,
    required this.wind,
    required this.pressure,
  });

  final TempUnit temp;
  final WindUnit wind;
  final PressureUnit pressure;

  /// Дефолт совпадает с тем, как прогноз отображался до настроек единиц —
  /// чтобы у текущих пользователей ничего не «прыгнуло».
  static const fallback = Units(
    temp: TempUnit.celsius,
    wind: WindUnit.ms,
    pressure: PressureUnit.hpa,
  );

  double tempValue(double celsius) =>
      temp == TempUnit.fahrenheit ? celsius * 9 / 5 + 32 : celsius;

  double windValue(double ms) => wind == WindUnit.kmh ? ms * 3.6 : ms;

  double pressureValue(double hpa) =>
      pressure == PressureUnit.mmhg ? hpaToMmHg(hpa) : hpa;

  Units copyWith({TempUnit? temp, WindUnit? wind, PressureUnit? pressure}) =>
      Units(
        temp: temp ?? this.temp,
        wind: wind ?? this.wind,
        pressure: pressure ?? this.pressure,
      );
}

class UnitsNotifier extends Notifier<Units> {
  @override
  Units build() {
    return Units(
      temp: _read(PrefsKeys.tempUnit, TempUnit.values, Units.fallback.temp),
      wind: _read(PrefsKeys.windUnit, WindUnit.values, Units.fallback.wind),
      pressure: _read(
        PrefsKeys.pressureUnit,
        PressureUnit.values,
        Units.fallback.pressure,
      ),
    );
  }

  void setTemp(TempUnit unit) {
    state = state.copyWith(temp: unit);
    sharedPrefs.setInt(PrefsKeys.tempUnit, unit.index);
  }

  void setWind(WindUnit unit) {
    state = state.copyWith(wind: unit);
    sharedPrefs.setInt(PrefsKeys.windUnit, unit.index);
  }

  void setPressure(PressureUnit unit) {
    state = state.copyWith(pressure: unit);
    sharedPrefs.setInt(PrefsKeys.pressureUnit, unit.index);
  }

  T _read<T>(String key, List<T> values, T fallback) {
    final idx = sharedPrefs.getInt(key);
    if (idx == null || idx < 0 || idx >= values.length) return fallback;
    return values[idx];
  }
}

final unitsProvider =
    NotifierProvider<UnitsNotifier, Units>(UnitsNotifier.new);

// ─── Короткие подписи единиц (для настроек и чипов) ──────────

String tempUnitLabel(TempUnit u) => u == TempUnit.fahrenheit ? '°F' : '°C';

String windUnitLabel(AppLocalizations l10n, WindUnit u) =>
    u == WindUnit.kmh ? l10n.fcUnitKmhSuffix : l10n.fcUnitMsSuffix;

String pressureUnitLabel(AppLocalizations l10n, PressureUnit u) =>
    u == PressureUnit.mmhg ? l10n.fcUnitMmHgSuffix : l10n.fcUnitHpaSuffix;
