import '../models/tracker.dart';
import 'notification/notification_service.dart';
import '../models/entry.dart';

/// Simple in-memory storage service for trackers and entries
/// TODO: Replace with persistent storage (SQLite, Hive, etc.)
class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // In-memory storage
  final List<Tracker> _trackers = [];
  final List<Entry> _entries = [];

  // Trackers
  List<Tracker> getAllTrackers() => List.unmodifiable(_trackers);

  Tracker? getTracker(String id) {
    try {
      return _trackers.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void addTracker(Tracker tracker) {
    _trackers.add(tracker);
    // schedule notification for this tracker if possible
    try {
      final ns = NotificationService();
      ns.scheduleForTracker(tracker);
    } catch (_) {}
  }

  void updateTracker(Tracker tracker) {
    final index = _trackers.indexWhere((t) => t.id == tracker.id);
    if (index != -1) {
      _trackers[index] = tracker;
      try {
        final ns = NotificationService();
        ns.cancelForTrackerId(tracker.id);
        ns.scheduleForTracker(tracker);
      } catch (_) {}
    }
  }

  void deleteTracker(String id) {
    _trackers.removeWhere((t) => t.id == id);
    // Also delete all entries for this tracker
    _entries.removeWhere((e) => e.trackerId == id);
    try {
      final ns = NotificationService();
      ns.cancelForTrackerId(id);
    } catch (_) {}
  }

  // Entries
  List<Entry> getAllEntries() => List.unmodifiable(_entries);

  List<Entry> getEntriesForTracker(String trackerId) {
    return _entries.where((e) => e.trackerId == trackerId).toList();
  }

  Entry? getEntry(String trackerId, DateTime timestamp) {
    try {
      return _entries.firstWhere(
        (e) => e.trackerId == trackerId && e.timestamp == timestamp,
      );
    } catch (e) {
      return null;
    }
  }

  void addEntry(Entry entry) {
    _entries.add(entry);
  }

  void updateEntry(Entry entry) {
    final index = _entries.indexWhere(
      (e) => e.trackerId == entry.trackerId && e.timestamp == entry.timestamp,
    );
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  void deleteEntry(Entry entry) {
    _entries.removeWhere(
      (e) => e.trackerId == entry.trackerId && e.timestamp == entry.timestamp,
    );
  }

  // Utility methods
  int getEntryCountForTracker(String trackerId) {
    return _entries.where((e) => e.trackerId == trackerId).length;
  }

  Entry? getLatestEntryForTracker(String trackerId) {
    final trackerEntries = getEntriesForTracker(trackerId);
    if (trackerEntries.isEmpty) return null;

    trackerEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return trackerEntries.first;
  }

  // Clear all data (useful for testing)
  void clearAll() {
    _trackers.clear();
    _entries.clear();
  }
}
