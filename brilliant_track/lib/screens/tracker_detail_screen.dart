import 'package:brilliant_track/widgets/notification_toggle_button.dart';
import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';
import 'input_screen.dart';
import 'create_tracker_screen.dart';
import '../widgets/global_app_bar.dart';

class TrackerDetailScreen extends StatefulWidget {
  final Tracker tracker;

  const TrackerDetailScreen({super.key, required this.tracker});

  @override
  State<TrackerDetailScreen> createState() => _TrackerDetailScreenState();
}

class _TrackerDetailScreenState extends State<TrackerDetailScreen> {
  final _storage = StorageService();
  late Tracker tracker;
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    tracker = widget.tracker;
    _loadEntries();
  }

  void _loadEntries() {
    entries = _storage.getEntriesForTracker(tracker.id);
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = List<Entry>.from(entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: GlobalAppBar(
        showHomeButton: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: tracker.icon != null
                  ? Icon(tracker.icon, color: Colors.white, size: 18)
                  : const Icon(Icons.analytics, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tracker.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editTracker),
          NotificationToggleButton(
            tracker: tracker,
            storage: _storage,
            onChanged: () {
              setState(() {
                final updated = _storage.getTracker(tracker.id);
                if (updated != null) {
                  tracker = updated;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCard(),
          Expanded(
            child: sortedEntries.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: sortedEntries.length,
                    itemBuilder: (context, index) {
                      return _buildEntryCard(sortedEntries[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEntry,
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
      ),
    );
  }

  // -----------------------------
  // STATS CARD
  // -----------------------------

  Widget _buildStatsCard() {
    final totalEntries = entries.length;

    final lastEntry = entries.isNotEmpty
        ? entries.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b)
        : null;

    return Card(
      margin: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          children: [
            Center(
              child: Text(
                tracker.question,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.analytics,
                  label: 'Total',
                  value: totalEntries.toString(),
                ),
                _buildStatItem(
                  icon: Icons.calendar_today,
                  label: 'Last Entry',
                  value: lastEntry != null
                      ? _formatDate(lastEntry.timestamp)
                      : 'Never',
                ),
                _buildStatItem(
                  icon: Icons.repeat,
                  label: 'Frequency',
                  value: _getFrequencyText(tracker.schedule.frequency),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    );
  }

  // -----------------------------
  // EMPTY STATE
  // -----------------------------

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No entries yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the button below to add your first entry',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // ENTRY CARD
  // -----------------------------

  Widget _buildEntryCard(Entry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onLongPress: () => _showEntryOptions(entry),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          title: Text(
            _formatDateTime(entry.timestamp),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Text(
            _getEntrySummary(entry),
            style: const TextStyle(fontSize: 13),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => _editEntry(entry),
            tooltip: 'Edit Entry',
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                children: [
                  ...entry.values.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key),
                          Text(
                            e.value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // ENTRY OPTIONS
  // -----------------------------

  void _showEntryOptions(Entry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Entry'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEntry(entry);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editEntry(Entry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InputScreen(tracker: tracker, existingEntry: entry),
      ),
    ).then((_) => _reloadEntries());
  }

  Future<void> _deleteEntry(Entry entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _storage.deleteEntry(entry);
      _reloadEntries();
    }
  }

  // -----------------------------
  // HELPERS
  // -----------------------------

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  String _getEntrySummary(Entry entry) {
    if (entry.values.isEmpty) return 'No data';

    final first = entry.values.entries.first;

    if (entry.values.length == 1) {
      return '${first.key}: ${first.value}';
    }

    return '${first.key}: ${first.value} (+${entry.values.length - 1} more)';
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

  void _reloadEntries() {
    setState(() {
      _loadEntries();
    });
  }
  // -----------------------------
  // ACTIONS
  // -----------------------------

  void _addEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InputScreen(tracker: tracker)),
    ).then((_) => _reloadEntries());
  }

  void _editTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTrackerScreen(initialTracker: tracker),
      ),
    ).then((updated) {
      if (updated != null && updated is Tracker) {
        _storage.updateTracker(updated);
        setState(() => tracker = updated);
      }
    });
  }
}
