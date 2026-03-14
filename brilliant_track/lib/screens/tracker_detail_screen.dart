import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/entry.dart';
import '../services/storage_service.dart';
import 'input_screen.dart';

class TrackerDetailScreen extends StatefulWidget {
  final Tracker tracker;
  final List<Entry> entries;

  const TrackerDetailScreen({
    super.key,
    required this.tracker,
    required this.entries,
  });

  @override
  State<TrackerDetailScreen> createState() => _TrackerDetailScreenState();
}

class _TrackerDetailScreenState extends State<TrackerDetailScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    // Sort entries by date (newest first)
    final sortedEntries = List<Entry>.from(widget.entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tracker.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editTracker,
            tooltip: 'Edit Tracker',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats card
          _buildStatsCard(),

          // Entries list
          Expanded(
            child: sortedEntries.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
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

  Widget _buildStatsCard() {
    final totalEntries = widget.entries.length;
    final lastEntry = widget.entries.isNotEmpty
        ? widget.entries.reduce(
            (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
          )
        : null;

    return Card(
      margin: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tracker.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.analytics,
                  label: 'Total Entries',
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
                  value: _getFrequencyText(widget.tracker.schedule.frequency),
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
        Icon(icon, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No entries yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first entry',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(Entry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.check, color: Colors.white),
        ),
        title: Text(
          _formatDateTime(entry.timestamp),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _getEntrySummary(entry),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...entry.values.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.key,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          e.value.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _editEntry(entry),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => _deleteEntry(entry),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  String _getEntrySummary(Entry entry) {
    if (entry.values.isEmpty) return 'No data';
    final firstValue = entry.values.entries.first;
    if (entry.values.length == 1) {
      return '${firstValue.key}: ${firstValue.value}';
    } else {
      return '${firstValue.key}: ${firstValue.value} (+${entry.values.length - 1} more)';
    }
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

  void _addEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputScreen(tracker: widget.tracker),
      ),
    ).then((value) {
      // TODO: Refresh entries from storage
      setState(() {});
    });
  }

  void _editEntry(Entry entry) {
    // TODO: Implement edit entry
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit entry: ${_formatDateTime(entry.timestamp)}'),
      ),
    );
  }

  void _deleteEntry(Entry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text('Delete entry from ${_formatDateTime(entry.timestamp)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete from storage
              _storage.deleteEntry(entry);
              widget.entries.remove(entry);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Entry deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editTracker() {
    // TODO: Implement edit tracker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit tracker (coming soon)')));
  }
}
