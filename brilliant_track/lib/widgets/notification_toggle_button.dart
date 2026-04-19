import 'package:brilliant_track/data/app_database.dart';
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class NotificationToggleButton extends StatelessWidget {
  final Tracker tracker;
  final StorageService storage;
  final VoidCallback onChanged;

  const NotificationToggleButton({
    super.key,
    required this.tracker,
    required this.storage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        tracker.notificationsEnabled
            ? Icons.notifications
            : Icons.notifications_off,
      ),
      color: tracker.notificationsEnabled
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.primary,
      tooltip: 'Toggle Notifications',
      onPressed: () async {
        await storage.toggleNotifications(tracker.id);
        onChanged();
      },
    );
  }
}
