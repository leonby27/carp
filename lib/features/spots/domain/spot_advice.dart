import '../../forecast/domain/weather_point.dart' show WindCardinal;
import 'water_body.dart';

/// Пространственная подсказка по споту — где сегодня вероятнее активная рыба.
/// Это эвристика по ветру и температуре, НЕ точная инструкция: локальная
/// глубина, дно и подход к берегу здесь неизвестны.
enum SpotTip {
  /// Тёплый/нейтральный ветер гонит корм к подветренному (дальнему) берегу —
  /// рыба, вероятно, кормится там. [SpotAdvice.activeShore] задан.
  windwardBank,

  /// Ветер холоднее воды: рыба уходит с продуваемого берега в затишье.
  /// [SpotAdvice.activeShore] = защищённый (наветренный) берег.
  shelteredBank,

  /// Ветра практически нет — берегового сноса корма не будет, рыба
  /// распределена по структурам/глубинам, а не по берегу.
  noWind,

  /// Вода холодная: рыба у дна и в ямах, пассивна — ветер сейчас почти не
  /// двигает её по горизонтали.
  coldWater,

  /// Береговой подсказки нет (река/канал/неизвестный тип).
  none,
}

/// Результат разбора спота: что за водоём + где вероятнее рыба сегодня.
class SpotAdvice {
  const SpotAdvice({
    required this.body,
    required this.tip,
    this.activeShore,
    this.userShore,
  });

  final WaterBody body;
  final SpotTip tip;

  /// Сторона света рекомендованного берега (для [windwardBank]/[shelteredBank]).
  final WindCardinal? activeShore;

  /// На каком берегу относительно центра водоёма стоит спот пользователя.
  /// null, если спот по сути в центре (мелкий пруд) или берег не определить.
  final WindCardinal? userShore;

  bool get hasShoreHint => activeShore != null;

  /// Угловое расстояние между берегом спота и активным берегом в «румбах»
  /// (0..4, каждый = 45°). null, если какой-то из берегов не определён.
  /// Берём не точное равенство сторон света, а близость: спот чуть в стороне
  /// от активного берега — это всё ещё «тот самый» берег, а не другой.
  int? get _shoreDistance {
    final a = activeShore;
    final u = userShore;
    if (a == null || u == null) return null;
    final d = (a.index - u.index).abs() % 8;
    return d > 4 ? 8 - d : d;
  }

  /// Спот на «активном» берегу или вплотную к нему (в пределах ~45°) — подсказка
  /// превращается в подтверждение «ты в правильном месте», а не «перейди».
  bool get userOnActiveShore {
    final d = _shoreDistance;
    return d != null && d <= 1;
  }

  /// Спот примерно у противоположного берега (≥135° от активного) — есть смысл
  /// перейти. На перпендикулярном берегу (≈90°) ничего не утверждаем.
  bool get userOnOppositeShore {
    final d = _shoreDistance;
    return d != null && d >= 3;
  }
}
