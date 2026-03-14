import 'dart:io';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../models/tracker.dart';
import 'notification_time_calculator.dart';

class NotificationScheduler {
  late FlutterLocalNotificationsPlugin _plugin;
  late NotificationDetails _details;

  final Map<int, Timer> _linuxTimers = {};

  void configure(
    FlutterLocalNotificationsPlugin plugin,
    NotificationDetails details,
  ) {
    _plugin = plugin;
    _details = details;
  }

  Future<int> schedule(Tracker tracker) async {
    final id = tracker.id.hashCode & 0x7fffffff;

    final parts = tracker.schedule.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    tz.TZDateTime scheduled;
    DateTimeComponents? repeat;

    switch (tracker.schedule.frequency) {
      case Frequency.daily:
        scheduled = NotificationTimeCalculator.nextDaily(hour, minute);
        repeat = DateTimeComponents.time;
        break;
      case Frequency.weekly:
        scheduled = NotificationTimeCalculator.nextWeekly(
          tracker.schedule.weekday!,
          hour,
          minute,
        );
        repeat = DateTimeComponents.dayOfWeekAndTime;
        break;
      case Frequency.monthly:
        scheduled = NotificationTimeCalculator.nextMonthly(
          tracker.schedule.dayOfMonth!,
          hour,
          minute,
        );
        break;
      default:
        // Unknown/custom frequency: no scheduling
        return id;
    }

    if (Platform.isLinux) {
      final delay = scheduled.toLocal().difference(DateTime.now());

      _linuxTimers[id]?.cancel();

      _linuxTimers[id] = Timer(
        delay.isNegative ? Duration.zero : delay,
        () async {
          await _plugin.show(
            id: id,
            title: tracker.name,
            body: tracker.question,
            notificationDetails: _details,
          );
        },
      );
    } else {
      await _plugin.zonedSchedule(
        id: id,
        title: tracker.name,
        body: tracker.question,
        scheduledDate: scheduled,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: repeat,
      );
    }

    return id;
  }

  Future<void> cancel(int id) async {
    _linuxTimers.remove(id)?.cancel();
    await _plugin.cancel(id: id);
  }
}
