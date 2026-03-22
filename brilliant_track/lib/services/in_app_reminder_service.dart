import 'dart:async';

import 'package:flutter/material.dart';

import '../models/tracker.dart';
import 'storage_service.dart';
import 'notification/notification_service.dart';

/// In-app reminder service: checks trackers every minute and shows a dialog
/// when a reminder is due. This is a fallback for platforms without OS
/// notification support (Linux / Web).
class InAppReminderService {
  static final InAppReminderService _instance =
      InAppReminderService._internal();
  factory InAppReminderService() => _instance;
  InAppReminderService._internal();

  Timer? _timer;
  GlobalKey<NavigatorState>? _navigatorKey;

  void start(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkDue());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _navigatorKey = null;
  }

  void _checkDue() {
    final now = DateTime.now();
    final storage = StorageService();
    for (var t in storage.getAllTrackers()) {
      if (!t.notificationsEnabled) continue;
      final sched = t.schedule;
      final parts = sched.time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (sched.frequency == Frequency.daily) {
        if (now.hour == hour && now.minute == minute) _showReminder(t);
      } else if (sched.frequency == Frequency.weekly && sched.weekday != null) {
        if (now.weekday == sched.weekday &&
            now.hour == hour &&
            now.minute == minute) {
          _showReminder(t);
        }
      } else if (sched.frequency == Frequency.monthly &&
          sched.dayOfMonth != null) {
        if (now.day == sched.dayOfMonth &&
            now.hour == hour &&
            now.minute == minute) {
          _showReminder(t);
        }
      }
    }
  }

  void _showReminder(Tracker tracker) {
    if (_navigatorKey == null) return;
    final ctx = _navigatorKey!.currentState?.overlay?.context;
    if (ctx == null) return;

    // Try to use OS notifications when available. If that fails or the
    // platform doesn't support notifications, fall back to an in-app dialog.
    try {
      // showNowForTracker will initialize the NotificationService if needed
      // and show a system notification (appears in the tray).
      NotificationService().showNowForTracker(tracker);
      return;
    } catch (_) {
      // ignore and fall through to dialog fallback
    }

    showDialog(
      context: ctx,
      builder: (c) => AlertDialog(
        title: Text('Reminder: ${tracker.name}'),
        content: Text(tracker.question),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
