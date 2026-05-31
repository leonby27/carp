import '../../forecast/domain/bite_score.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';

/// Тип алёрта о клёве — определяет, какие дни недели мы вообще отбираем, и задаёт
/// формулировку текста. Пользователь включает их независимо (тумблер на каждую
/// пару тип×рыба), мастер-переключателя нет.
enum BiteAlertKind {
  /// Единственный лучший день в пределах недели (пик индекса по всем спотам).
  /// Максимум один пуш в неделю на вид рыбы.
  primeWeek,

  /// Каждый день, чей лучший спот дотягивает до уровня `excellent`.
  excellentDays,
}

/// Запланированный локальный алёрт о клёве: конкретная рыба, конкретный день и
/// лучший на этот день спот.
///
/// Это СТРУКТУРНЫЕ данные без локализованного текста: planner — чистый Dart, а
/// заголовок/тело собираются на момент планирования (когда известна локаль) в
/// слое форматирования. Так ядро остаётся тестируемым, а тексты — переводимыми.
class PlannedAlert {
  const PlannedAlert({
    required this.fish,
    required this.kind,
    required this.spotName,
    required this.fireAt,
    required this.forDay,
    required this.windowKind,
    required this.index,
    required this.level,
  });

  /// Вид рыбы, под который посчитан индекс этого дня.
  final Fish fish;

  /// Тип алёрта (прайм-день недели / отличный день).
  final BiteAlertKind kind;

  /// Имя лучшего на этот день спота (как у [GeoPoint.name]); может быть пустым
  /// для «текущего места» — тогда форматтер подставит запасной текст.
  final String spotName;

  /// Когда показать уведомление (локальное время) — вечер накануне.
  final DateTime fireAt;

  /// Дата дня клёва (полночь) — на какой день прогноз.
  final DateTime forDay;

  /// Тип лучшего окна дня (зорька/ночь/день) — для природной формулировки.
  /// null, если окон у дня нет.
  final BiteWindowKind? windowKind;

  /// Суточный индекс клёва (0..100).
  final int index;

  final BiteLevel level;

  /// Стабильный 31-битный id уведомления (рыба + день). На одну рыбу в один день
  /// приходится максимум один алёрт (прайм перекрывает «отличный»), поэтому день
  /// + рыбы достаточно для дедупликации между типами и видами.
  int get notificationId {
    final h = Object.hash(fish, forDay.year, forDay.month, forDay.day);
    return h & 0x7fffffff;
  }
}
