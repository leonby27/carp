import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Одно уведомление к показу — простая запись без доменных типов, чтобы сервис
/// не зависел от слоя прогноза/алёртов. Текст уже локализован вызывающим.
typedef ScheduledNotification = ({
  int id,
  DateTime when,
  String title,
  String body,
});

/// Тонкая обёртка над flutter_local_notifications: инициализация, временная
/// зона, запрос разрешения и пере-синхронизация запланированных уведомлений.
/// Никакой доменной логики — «что и когда показывать» решает планировщик выше.
class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const _channelId = 'bite_alerts';
  static const _channelName = 'Bite alerts';
  static const _channelDescription =
      'Notifications about prime carp-fishing conditions at your spots';

  /// Готовит плагин и базу таймзон. Безопасно звать повторно.
  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final localZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localZone));
    } catch (_) {
      // Не смогли определить зону устройства — остаёмся на UTC. Алёрт всё равно
      // придёт, просто без идеальной привязки к локальному вечеру.
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        // Разрешение запрашиваем явно при включении тумблера, не на старте.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _ready = true;
  }

  /// Запрашивает разрешение на уведомления (iOS + Android 13+). Возвращает true,
  /// если разрешение есть. Вызывать при включении тумблера алёртов.
  Future<bool> requestPermission() async {
    await init();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted =
          await ios.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// Полная пере-синхронизация: снимает все ранее запланированные алёрты и ставит
  /// заново переданный набор. Так прогноз всегда отражает свежие данные, а старые
  /// (возможно устаревшие) уведомления не «висят».
  Future<void> syncAlerts(List<ScheduledNotification> alerts) async {
    await init();
    await _plugin.cancelAll();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    for (final a in alerts) {
      final when = tz.TZDateTime.from(a.when, tz.local);
      if (!when.isAfter(tz.TZDateTime.now(tz.local))) continue;
      try {
        await _plugin.zonedSchedule(
          a.id,
          a.title,
          a.body,
          when,
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // Вечерний алёрт не требует секундной точности → inexact-режим, чтобы
          // не запрашивать разрешение точных будильников (SCHEDULE_EXACT_ALARM).
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('NotificationService.syncAlerts failed for ${a.id}: $e');
      }
    }
  }

  /// Снять все запланированные алёрты (при выключении тумблера).
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
