import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../models/tracker.dart';

/// NotificationService: schedules OS notifications where supported.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    // Initialize timezone data
    tz.initializeTimeZones();
    try {
      final String tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      tz.setLocalLocation(tz.local);
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    // new API uses named parameters
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  /// Schedule a notification for the given tracker.
  /// Returns the notification id used, or null if not scheduled on this platform.
  Future<int?> scheduleForTracker(Tracker tracker) async {
    if (kIsWeb) return null;
    if (!(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows)) {
      return null;
    }

    if (!_initialized) await init();

    final id = tracker.id.hashCode & 0x7fffffff;
    final parts = tracker.schedule.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (tracker.schedule.frequency == Frequency.daily) {
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id: id,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'brilliant_channel',
            'Reminders',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        title: tracker.name,
        body: tracker.question,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (tracker.schedule.frequency == Frequency.weekly &&
        tracker.schedule.weekday != null) {
      final now = tz.TZDateTime.now(tz.local);
      int target = tracker.schedule.weekday!; // 1..7
      tz.TZDateTime scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
      while (scheduled.weekday != target) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 7));
      }

      await _plugin.zonedSchedule(
        id: id,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'brilliant_channel',
            'Reminders',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        title: tracker.name,
        body: tracker.question,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } else if (tracker.schedule.frequency == Frequency.monthly &&
        tracker.schedule.dayOfMonth != null) {
      final now = tz.TZDateTime.now(tz.local);
      int day = tracker.schedule.dayOfMonth!;
      tz.TZDateTime scheduled;
      try {
        scheduled = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          day,
          hour,
          minute,
        );
      } catch (_) {
        final lastDay = DateTime(now.year, now.month + 1, 0).day;
        scheduled = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          lastDay,
          hour,
          minute,
        );
      }
      if (scheduled.isBefore(now)) {
        final next = DateTime(now.year, now.month + 1, 1);
        scheduled = tz.TZDateTime(
          tz.local,
          next.year,
          next.month,
          day,
          hour,
          minute,
        );
      }
      await _plugin.zonedSchedule(
        id: id,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'brilliant_channel',
            'Reminders',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        title: tracker.name,
        body: tracker.question,
      );
    }

    return id;
  }

  Future<void> cancelForTrackerId(String trackerId) async {
    if (kIsWeb) return;
    final id = trackerId.hashCode & 0x7fffffff;
    await _plugin.cancel(id: id);
  }
}
