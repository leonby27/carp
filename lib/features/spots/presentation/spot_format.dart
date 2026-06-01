import '../../../l10n/app_localizations.dart';
import '../../forecast/domain/weather_point.dart' show WindCardinal;
import '../../forecast/presentation/forecast_format.dart' show windCardinalLabel;
import '../domain/spot_advice.dart';
import '../domain/water_body.dart';

/// Путь к иллюстрации спота: база по типу воды (канал берёт картинку реки,
/// водохранилище — озера), суффикс по активному берегу или `none`, если берег
/// сегодня не выражен. В тёмной теме — вариант из dark/ с размытыми краями.
String spotIllustrationAsset(SpotAdvice a, {required bool dark}) {
  final base = switch (a.body.type) {
    WaterBodyType.pond => 'pond',
    WaterBodyType.river || WaterBodyType.canal => 'river',
    WaterBodyType.lake ||
    WaterBodyType.reservoir ||
    WaterBodyType.other =>
      'lake',
  };
  final dir = switch (a.activeShore) {
    null => 'none',
    WindCardinal.n => 'n',
    WindCardinal.ne => 'ne',
    WindCardinal.e => 'e',
    WindCardinal.se => 'se',
    WindCardinal.s => 's',
    WindCardinal.sw => 'sw',
    WindCardinal.w => 'w',
    WindCardinal.nw => 'nw',
  };
  final folder = dark ? 'assets/images/spots/dark' : 'assets/images/spots';
  return '$folder/spot_${base}_$dir.webp';
}

/// Локализованное название типа водоёма.
String spotTypeLabel(AppLocalizations l10n, WaterBodyType type) => switch (type) {
      WaterBodyType.lake => l10n.spotTypeLake,
      WaterBodyType.pond => l10n.spotTypePond,
      WaterBodyType.reservoir => l10n.spotTypeReservoir,
      WaterBodyType.river => l10n.spotTypeRiver,
      WaterBodyType.canal => l10n.spotTypeCanal,
      WaterBodyType.other => l10n.spotTypeWater,
    };

/// Размер водоёма: до 100 га — в гектарах, крупнее — в км². null, если площадь
/// неизвестна (реки/каналы/сложная геометрия) — тогда подпись не показываем.
String? spotSizeLabel(AppLocalizations l10n, double? areaHa) {
  if (areaHa == null) return null;
  if (areaHa >= 100) {
    final km2 = areaHa / 100;
    return l10n.spotSizeKm2(km2 < 10 ? km2.toStringAsFixed(1) : '${km2.round()}');
  }
  final ha = areaHa < 1 ? areaHa.toStringAsFixed(1) : '${areaHa.round()}';
  return l10n.spotSizeHa(ha);
}

/// Динамическая ветровая подсказка (зависит от погоды). null — для рек/каналов
/// и «other», где берегового сноса нет; их закрывает [spotWhereText].
String? spotTipText(AppLocalizations l10n, SpotAdvice a) => switch (a.tip) {
      SpotTip.windwardBank =>
        l10n.spotTipWindward(windCardinalLabel(l10n, a.activeShore!)),
      SpotTip.shelteredBank =>
        l10n.spotTipSheltered(windCardinalLabel(l10n, a.activeShore!)),
      SpotTip.noWind => l10n.spotTipNoWind,
      SpotTip.coldWater => l10n.spotTipColdWater,
      SpotTip.none => null,
    };

/// Статичная подсказка «где искать»: для рек/каналов — по типу, для стоячей
/// воды — по размеру (он надёжнее типа из OSM). Это общая для типа воды
/// эвристика, а не привязка к конкретному дну/глубине — поэтому в UI идёт с
/// источником «по типу водоёма». null — для неизвестного типа.
String? spotWhereText(AppLocalizations l10n, SpotAdvice a) {
  switch (a.body.type) {
    case WaterBodyType.river:
      return l10n.spotWhereRiver;
    case WaterBodyType.canal:
      return l10n.spotWhereCanal;
    case WaterBodyType.lake:
    case WaterBodyType.pond:
    case WaterBodyType.reservoir:
      final ha = a.body.areaHa;
      if (ha == null) return l10n.spotWhereUnknown;
      if (ha < 5) return l10n.spotWherePondSmall;
      if (ha < 50) return l10n.spotWhereMid;
      return l10n.spotWhereLarge;
    case WaterBodyType.other:
      return null;
  }
}

/// Структурные подсказки, вычитанные из карты рядом со спотом (приток, тростник,
/// плотина, острова). Это честные «что есть на карте» признаки, не зависящие от
/// погоды; показываем отдельным блоком от ветровых подсказок. Пустой список —
/// структур рядом не размечено.
List<String> spotStructureHints(AppLocalizations l10n, WaterBody body) => [
      if (body.inflowNearSpot) l10n.spotStructInflow,
      if (body.reedsNearSpot) l10n.spotStructReeds,
      if (body.damNearSpot) l10n.spotStructDam,
      if (body.islandCount > 0) l10n.spotStructIslands(body.islandCount),
    ];

/// Заметка про спот пользователя относительно активного берега. null, если
/// берег пользователя не определён или активного берега нет.
String? spotUserNote(AppLocalizations l10n, SpotAdvice a) {
  if (a.userOnActiveShore) return l10n.spotUserHere;
  if (a.userOnOppositeShore) return l10n.spotUserOpposite;
  // Перпендикулярный берег (≈90°) — честно молчим: ни «там же», ни «напротив».
  return null;
}
