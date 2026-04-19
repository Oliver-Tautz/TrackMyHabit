import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/widgets.dart' show IconData;

part 'app_database.g.dart';

/// --------------------
/// SUPPORTING TYPES
/// --------------------

enum Frequency {
  daily,
  weekly,
  monthly,
  custom, // For cron-like expressions
}

class Schedule {
  final Frequency frequency;
  final String time; // e.g. "08:00"
  final String? cronExpression;
  final int? weekday; // 1=Monday .. 7=Sunday
  final int? dayOfMonth; // 1..31

  const Schedule({
    required this.frequency,
    required this.time,
    this.cronExpression,
    this.weekday,
    this.dayOfMonth,
  });

  Map<String, dynamic> toJson() => {
    'frequency': frequency.name,
    'time': time,
    'cronExpression': cronExpression,
    'weekday': weekday,
    'dayOfMonth': dayOfMonth,
  };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      frequency: Frequency.values.firstWhere(
        (f) => f.name == json['frequency'],
      ),
      time: json['time'] as String,
      cronExpression: json['cronExpression'] as String?,
      weekday: json['weekday'] as int?,
      dayOfMonth: json['dayOfMonth'] as int?,
    );
  }
}

enum FieldType { integer, float, text, image }

class Field {
  final String name;
  final FieldType type;

  const Field({required this.name, required this.type});

  Map<String, dynamic> toJson() => {'name': name, 'type': type.name};

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      name: json['name'] as String,
      type: FieldType.values.firstWhere((t) => t.name == json['type']),
    );
  }
}

/// --------------------
/// CONVERTERS
/// --------------------

class FieldListConverter extends TypeConverter<List<Field>, String> {
  const FieldListConverter();

  @override
  List<Field> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb) as List<dynamic>;
    return decoded
        .map((e) => Field.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  String toSql(List<Field> value) {
    return jsonEncode(value.map((f) => f.toJson()).toList());
  }
}

class ScheduleConverter extends TypeConverter<Schedule, String> {
  const ScheduleConverter();

  @override
  Schedule fromSql(String fromDb) {
    return Schedule.fromJson(
      Map<String, dynamic>.from(jsonDecode(fromDb) as Map),
    );
  }

  @override
  String toSql(Schedule value) {
    return jsonEncode(value.toJson());
  }
}

class ValuesConverter extends TypeConverter<Map<String, dynamic>, String> {
  const ValuesConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return Map<String, dynamic>.from(jsonDecode(fromDb) as Map);
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}

/// --------------------
/// TABLES
/// --------------------

class Trackers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get question => text()();

  TextColumn get fields => text().map(const FieldListConverter())();
  TextColumn get schedule => text().map(const ScheduleConverter())();

  IntColumn get iconCodePoint => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get notificationId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Entries extends Table {
  TextColumn get id => text()();
  TextColumn get trackerId => text()();
  DateTimeColumn get timestamp => dateTime()();

  TextColumn get values => text().map(const ValuesConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// --------------------
/// DATABASE
/// --------------------

@DriftDatabase(tables: [Trackers, Entries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  /// --------------------
  /// TRACKERS
  /// --------------------

  Future<Tracker?> getTrackerById(String id) {
    return (select(trackers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Tracker>> getAllTrackers() {
    return (select(
      trackers,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  Future<void> insertTracker(Tracker tracker) {
    return into(trackers).insert(tracker);
  }

  Future<void> updateTracker(Tracker tracker) {
    return update(trackers).replace(tracker);
  }

  Future<void> deleteTracker(String id) async {
    await (delete(entries)..where((e) => e.trackerId.equals(id))).go();
    await (delete(trackers)..where((t) => t.id.equals(id))).go();
  }

  /// --------------------
  /// ENTRIES
  /// --------------------

  Future<List<Entry>> getEntriesForTracker(String trackerId) {
    return (select(entries)..where((e) => e.trackerId.equals(trackerId))).get();
  }

  Future<void> insertEntry(Entry entry) {
    return into(entries).insert(entry);
  }

  Future<void> updateEntry(Entry entry) {
    return update(entries).replace(entry);
  }

  Future<void> deleteEntry(String id) {
    return (delete(entries)..where((e) => e.id.equals(id))).go();
  }
}

/// --------------------
/// CONNECTION
/// --------------------

QueryExecutor _openConnection() {
  return driftDatabase(name: 'app.sqlite');
}

/// --------------------
/// HELPERS
/// --------------------

extension TrackerX on Tracker {
  IconData? get icon {
    final cp = iconCodePoint;
    if (cp == null) return null;
    return IconData(cp, fontFamily: 'MaterialIcons');
  }

  Tracker copyWith({
    String? id,
    String? name,
    String? question,
    List<Field>? fields,
    Schedule? schedule,
    int? iconCodePoint,
    int? sortOrder,
    bool? notificationsEnabled,
    int? notificationId,
  }) {
    return Tracker(
      id: id ?? this.id,
      name: name ?? this.name,
      question: question ?? this.question,
      fields: fields ?? this.fields,
      schedule: schedule ?? this.schedule,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      sortOrder: sortOrder ?? this.sortOrder,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
