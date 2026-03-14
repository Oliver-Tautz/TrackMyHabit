class Entry {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final Map<String, dynamic> values;

  Entry({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    required this.values,
  });
}
