import 'package:brilliant_track/widgets/notification_toggle_button.dart';
import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';

import 'create_tracker_screen.dart';
import 'tracker_detail_screen.dart';
import '../widgets/global_app_bar.dart';
import 'package:flutter/foundation.dart';

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
    if (kDebugMode) {
      _initializeSampleData();
    }
  }

  void _initializeSampleData() {
    if (_storage.getAllTrackers().isEmpty) {
      final now = DateTime.now();

      // ------------------------
      // First tracker (existing)
      // ------------------------
      final sampleTracker = Tracker(
        id: '1',
        name: 'Weight Tracker',
        question: 'What is your weight today?',
        fields: [
          Field(name: 'Weight', type: FieldType.float),
          Field(name: 'Body Fat %', type: FieldType.float),
        ],
        schedule: Schedule(
          frequency: Frequency.daily,
          time:
              '${now.hour.toString().padLeft(2, '0')}:${now.add(Duration(minutes: 1)).minute.toString().padLeft(2, '0')}',
        ),
      );

      _storage.addTracker(sampleTracker);

      _storage.addEntry(
        Entry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          trackerId: '1',
          timestamp: now,
          values: {'Weight': 70.5, 'Body Fat %': 18.2},
        ),
      );

      // ------------------------
      // Second tracker (NEW)
      // ------------------------
      final later = now.add(const Duration(minutes: 2));

      final hydrationTracker = Tracker(
        id: '2',
        name: 'Hydration Check',
        question: 'Did you drink enough water?',
        fields: [Field(name: 'Glasses', type: FieldType.integer)],
        schedule: Schedule(
          frequency: Frequency.daily,
          time:
              '${later.hour.toString().padLeft(2, '0')}:${later.minute.toString().padLeft(2, '0')}',
        ),
      );

      _storage.addTracker(hydrationTracker);

      _storage.addEntry(
        Entry(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          trackerId: '2',
          timestamp: now,
          values: {'Glasses': 5},
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
          : ReorderableListView.builder(
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) {
                return Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity, // 👈 FORCE full width
                    child: child,
                  ),
                );
              },
              padding: const EdgeInsets.all(16),
              itemCount: trackers.length,
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final tracker = trackers[index];
                return _buildTrackerCard(
                  tracker,
                  index: index,
                  key: ValueKey(tracker.id),
                );
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

  Widget _buildTrackerCard(
    Tracker tracker, {
    required int index,
    required Key key,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
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

        // 👇 FIXED TRAILING
        trailing: SizedBox(
          height: 48, // ensures consistent tap area
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconWrapper(
                child: NotificationToggleButton(
                  tracker: tracker,
                  storage: _storage,
                  onChanged: () => setState(() {}),
                ),
              ),
              _buildIconWrapper(
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  color: colorScheme.primary,
                  onPressed: () => _editTracker(tracker),
                ),
              ),
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.drag_handle),
                ),
              ),
            ],
          ),
        ),

        onTap: () => _viewTrackerDetails(tracker),
      ),
    );
  }

  /// 👇 Helper to normalize size & padding
  Widget _buildIconWrapper({required Widget child}) {
    return SizedBox(width: 40, height: 40, child: Center(child: child));
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _storage.reorderTrackers(oldIndex, newIndex);
    });
  }

  String _buildTrackerSubtitle(Tracker tracker) {
    final frequency = _getFrequencyText(tracker.schedule.frequency);

    final time = tracker.schedule.time;

    return '${tracker.fields.length} fields • $frequency at $time';
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

  void _showTrackerOptions(Tracker tracker) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Tracker'),
                onTap: () {
                  Navigator.pop(context);
                  _editTracker(tracker);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Tracker'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteTracker(tracker);
                },
              ),
            ],
          ),
        );
      },
    );
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

  void _deleteTracker(Tracker tracker) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Tracker'),
          content: Text(
            'This will delete "${tracker.name}" and all its entries. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (confirmed != true) return;

    _storage.deleteTracker(tracker.id);

    setState(() {});

    // Optional: feedback
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${tracker.name} deleted')));
  }
}
