import 'package:timezone/timezone.dart' as tz;

class NotificationTimeCalculator {
  static tz.TZDateTime nextDaily(int hour, int minute) {
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

    return scheduled;
  }

  static tz.TZDateTime nextWeekly(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }

  static tz.TZDateTime nextMonthly(int day, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    int lastDay = DateTime(now.year, now.month + 1, 0).day;

    if (day > lastDay) {
      day = lastDay;
    }

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      final next = DateTime(now.year, now.month + 1, 1);

      int nextLastDay = DateTime(next.year, next.month + 1, 0).day;

      if (day > nextLastDay) {
        day = nextLastDay;
      }

      scheduled = tz.TZDateTime(
        tz.local,
        next.year,
        next.month,
        day,
        hour,
        minute,
      );
    }

    return scheduled;
  }
}
