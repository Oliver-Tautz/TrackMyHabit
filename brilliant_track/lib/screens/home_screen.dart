import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';
import '../models/entry.dart';
import 'input_screen.dart';
import 'create_tracker_screen.dart';
import 'tracker_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data - in real app, this would come from storage
  List<Tracker> trackers = [
    Tracker(
      id: '1',
      name: 'Weight Tracker',
      question: 'What is your weight today?',
      fields: [
        Field(name: 'Weight', type: FieldType.float),
        Field(name: 'Body Fat %', type: FieldType.float),
      ],
      schedule: Schedule(frequency: Frequency.daily, time: '08:00'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
    );
  }

  void _viewTrackerDetails(Tracker tracker) {
    // Generate sample entries for demo
    final sampleEntries = _getSampleEntries(tracker);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrackerDetailScreen(tracker: tracker, entries: sampleEntries),
      ),
    );
  }

  List<Entry> _getSampleEntries(Tracker tracker) {
    // Create some sample entries for demonstration
    final now = DateTime.now();
    return [
      Entry(
        trackerId: tracker.id,
        timestamp: now,
        values: {'Weight': 70.5, 'Body Fat %': 18.2},
      ),
      Entry(
        trackerId: tracker.id,
        timestamp: now.subtract(const Duration(days: 1)),
        values: {'Weight': 70.8, 'Body Fat %': 18.5},
      ),
      Entry(
        trackerId: tracker.id,
        timestamp: now.subtract(const Duration(days: 2)),
        values: {'Weight': 71.0, 'Body Fat %': 18.7},
      ),
      Entry(
        trackerId: tracker.id,
        timestamp: now.subtract(const Duration(days: 3)),
        values: {'Weight': 71.2, 'Body Fat %': 19.0},
      ),
      Entry(
        trackerId: tracker.id,
        timestamp: now.subtract(const Duration(days: 7)),
        values: {'Weight': 72.0, 'Body Fat %': 19.5},
      ),
    ];
  }

  void _createNewTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTrackerScreen()),
    ).then((newTracker) {
      if (newTracker != null && newTracker is Tracker) {
        setState(() {
          trackers.add(newTracker);
        });
      }
    });
  }
}
