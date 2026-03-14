import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';
import 'input_screen.dart';
import 'create_tracker_screen.dart';
import 'tracker_detail_screen.dart';

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
          trackerId: '1',
          timestamp: now,
          values: {'Weight': 70.5, 'Body Fat %': 18.2},
        ),
      );
      _storage.addEntry(
        Entry(
          trackerId: '1',
          timestamp: now.subtract(const Duration(days: 1)),
          values: {'Weight': 70.8, 'Body Fat %': 18.5},
        ),
      );
      _storage.addEntry(
        Entry(
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
      appBar: AppBar(
        title: const Text('brilliant.track'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
          child: const Icon(Icons.analytics, color: Colors.white),
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
              '${tracker.fields.length} fields • ${_getFrequencyText(tracker.schedule.frequency)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => _addEntry(tracker),
        ),
        onTap: () => _viewTrackerDetails(tracker),
      ),
    );
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
    final entries = _storage.getEntriesForTracker(tracker.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrackerDetailScreen(tracker: tracker, entries: entries),
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
        setState(() {});
      }
    });
  }
}
