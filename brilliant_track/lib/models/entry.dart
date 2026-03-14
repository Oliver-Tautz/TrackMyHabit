class Entry {
  final String trackerId;
  final DateTime timestamp;
  final Map<String, dynamic> values;

  Entry({
    required this.trackerId,
    required this.timestamp,
    required this.values,
  });
}