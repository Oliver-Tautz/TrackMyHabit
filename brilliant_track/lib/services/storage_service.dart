import '../data/app_database.dart';
import 'notification/notification_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final AppDatabase _db = AppDatabase();

  /// TRACKERS

  Future<List<Tracker>> getAllTrackers() {
    return _db.getAllTrackers();
  }

  Future<Tracker?> getTracker(String id) {
    return _db.getTrackerById(id);
  }

  Future<void> addTracker(Tracker tracker) async {
    final trackers = await _db.getAllTrackers();

    final nextSortOrder = trackers.isEmpty
        ? 0
        : trackers.map((t) => t.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

    final trackerToInsert = tracker.copyWith(sortOrder: nextSortOrder);

    await _db.insertTracker(trackerToInsert);

    try {
      await NotificationService().scheduleForTracker(trackerToInsert);
    } catch (_) {}
  }

  Future<void> toggleNotifications(String trackerId) async {
    final tracker = await getTracker(trackerId);
    if (tracker == null) return;

    final updated = tracker.copyWith(
      notificationsEnabled: !tracker.notificationsEnabled,
    );

    await updateTracker(updated);
  }

  Future<void> updateTracker(Tracker tracker) async {
    await _db.updateTracker(tracker);

    try {
      final ns = NotificationService();

      await ns.cancelForNotificationID(tracker.notificationId);

      if (tracker.notificationsEnabled) {
        await ns.scheduleForTracker(tracker);
      }
    } catch (_) {}
  }

  Future<void> deleteTracker(String id) async {
    final tracker = await getTracker(id);
    if (tracker == null) return;

    await _db.deleteTracker(id);

    try {
      await NotificationService().cancelForNotificationID(
        tracker.notificationId,
      );
    } catch (_) {}
  }

  Future<void> reorderTrackers(int oldIndex, int newIndex) async {
    final trackers = await _db.getAllTrackers();

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedTracker = trackers.removeAt(oldIndex);
    trackers.insert(newIndex, movedTracker);

    for (int i = 0; i < trackers.length; i++) {
      final tracker = trackers[i];

      if (tracker.sortOrder != i) {
        await _db.updateTracker(tracker.copyWith(sortOrder: i));
      }
    }
  }

  /// ENTRIES

  Future<List<Entry>> getEntriesForTracker(String trackerId) {
    return _db.getEntriesForTracker(trackerId);
  }

  Future<void> addEntry(Entry entry) {
    return _db.insertEntry(entry);
  }

  Future<void> updateEntry(Entry entry) {
    return _db.updateEntry(entry);
  }

  Future<void> deleteEntry(String id) {
    return _db.deleteEntry(id);
  }

  Future<int> getEntryCountForTracker(String trackerId) async {
    final entries = await getEntriesForTracker(trackerId);
    return entries.length;
  }

  Future<Entry?> getLatestEntryForTracker(String trackerId) async {
    final entries = await getEntriesForTracker(trackerId);
    if (entries.isEmpty) return null;

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries.first;
  }
}
