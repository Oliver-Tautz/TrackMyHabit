import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../models/tracker.dart';
import 'notification_scheduler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final NotificationScheduler _scheduler = NotificationScheduler();

  bool _initialized = false;

  static const _channelId = 'brilliant_channel';
  static const _channelName = 'Reminders';

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.defaultImportance,
      );

  static const NotificationDetails notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
    linux: LinuxNotificationDetails(),
  );

  bool get _supportedPlatform =>
      !kIsWeb &&
      (Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isMacOS ||
          Platform.isWindows ||
          Platform.isLinux);

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation((tzInfo as dynamic).identifier));
    } catch (_) {
      tz.setLocalLocation(tz.local);
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const linux = LinuxInitializationSettings(defaultActionName: 'Open');

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
      linux: linux,
    );

    await _plugin.initialize(settings: settings);

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        importance: Importance.defaultImportance,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    _scheduler.configure(_plugin, notificationDetails);

    _initialized = true;
  }

  Future<int?> scheduleForTracker(Tracker tracker) async {
    if (!_supportedPlatform) return null;
    if (!_initialized) await init();

    return _scheduler.schedule(tracker);
  }

  Future<void> cancelForTrackerId(String trackerId) async {
    if (kIsWeb) return;

    final id = trackerId.hashCode & 0x7fffffff;
    await _scheduler.cancel(id);
  }
}
