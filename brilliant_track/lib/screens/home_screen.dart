import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';
import 'input_screen.dart';
import 'create_tracker_screen.dart';
import 'tracker_detail_screen.dart';
import '../widgets/global_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Add sample tracker if storage is empty
    if (_storage.getAllTrackers().isEmpty) {
      final sampleTracker = Tracker(
        id: '1',
        name: 'Weight Tracker',
        question: 'What is your weight today?',
        fields: [
          Field(name: 'Weight', type: FieldType.float),
          Field(name: 'Body Fat %', type: FieldType.float),
        ],
        schedule: Schedule(frequency: Frequency.daily, time: '08:00'),
      );
      _storage.addTracker(sampleTracker);

      // Add some sample entries
      final now = DateTime.now();
      _storage.addEntry(
        Entry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          trackerId: '1',
          timestamp: now,
          values: {'Weight': 70.5, 'Body Fat %': 18.2},
        ),
      );
      _storage.addEntry(
        Entry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          trackerId: '1',
          timestamp: now.subtract(const Duration(days: 1)),
          values: {'Weight': 70.8, 'Body Fat %': 18.5},
        ),
      );
      _storage.addEntry(
        Entry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          trackerId: '1',
          timestamp: now.subtract(const Duration(days: 2)),
          values: {'Weight': 71.0, 'Body Fat %': 18.7},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackers = _storage.getAllTrackers();
    return Scaffold(
      appBar: GlobalAppBar(
        title: const Text('brilliant.track'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => Scaffold(
                    appBar: AppBar(title: const Text('Settings')),
                    body: const Center(child: Text('Settings (mock)')),
                  ),
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: trackers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trackers.length,
              itemBuilder: (context, index) {
                return _buildTrackerCard(trackers[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTracker,
        icon: const Icon(Icons.add),
        label: const Text('New Tracker'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.track_changes, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No trackers yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first tracker to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerCard(Tracker tracker) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: tracker.icon != null
              ? Icon(tracker.icon, color: Colors.white)
              : const Icon(Icons.analytics, color: Colors.white),
        ),
        title: Text(
          tracker.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(tracker.question),
            const SizedBox(height: 8),
            Text(
              _buildTrackerSubtitle(tracker),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _editTracker(tracker),
              tooltip: 'Edit Tracker',
            ),
            IconButton(
              icon: Icon(
                tracker.notificationsEnabled
                    ? Icons.notifications
                    : Icons.notifications_off,
              ),
              color: tracker.notificationsEnabled
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                final updated = tracker.copyWith(
                  notificationsEnabled: !tracker.notificationsEnabled,
                );

                _storage.updateTracker(updated);

                setState(() {});
              },
              tooltip: 'Toggle Notifications',
            ),
          ],
        ),
        onTap: () => _viewTrackerDetails(tracker),
      ),
    );
  }

  String _buildTrackerSubtitle(Tracker tracker) {
    final frequency = _getFrequencyText(tracker.schedule.frequency);

    if (!tracker.notificationsEnabled) {
      return '${tracker.fields.length} fields • $frequency';
    }

    final time = tracker.schedule.time;

    return '${tracker.fields.length} fields • $frequency at $time';
  }

  String _formatReminderTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  String _getFrequencyText(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.custom:
        return 'Custom';
    }
  }

  void _addEntry(Tracker tracker) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InputScreen(tracker: tracker)),
    ).then((_) {
      // Refresh the screen after adding entry
      setState(() {});
    });
  }

  void _viewTrackerDetails(Tracker tracker) {
    // Get real entries from storage

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackerDetailScreen(tracker: tracker),
      ),
    ).then((_) {
      // Refresh the screen when returning
      setState(() {});
    });
  }

  void _createNewTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTrackerScreen()),
    ).then((newTracker) {
      if (newTracker != null && newTracker is Tracker) {
        _storage.addTracker(newTracker);
        if (mounted) setState(() {});
      }
    });
  }

  void _editTracker(Tracker tracker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTrackerScreen(initialTracker: tracker),
      ),
    ).then((updatedTracker) {
      if (updatedTracker != null && updatedTracker is Tracker) {
        _storage.updateTracker(updatedTracker);
        if (mounted) {
          setState(() {});
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Tracker updated')));
        }
      }
    });
  }
}
