// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TrackersTable extends Trackers with TableInfo<$TrackersTable, Tracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Field>, String> fields =
      GeneratedColumn<String>(
        'fields',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Field>>($TrackersTable.$converterfields);
  @override
  late final GeneratedColumnWithTypeConverter<Schedule, String> schedule =
      GeneratedColumn<String>(
        'schedule',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Schedule>($TrackersTable.$converterschedule);
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    question,
    fields,
    schedule,
    iconCodePoint,
    sortOrder,
    notificationsEnabled,
    notificationId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trackers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tracker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tracker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      fields: $TrackersTable.$converterfields.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fields'],
        )!,
      ),
      schedule: $TrackersTable.$converterschedule.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}schedule'],
        )!,
      ),
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
    );
  }

  @override
  $TrackersTable createAlias(String alias) {
    return $TrackersTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Field>, String> $converterfields =
      const FieldListConverter();
  static TypeConverter<Schedule, String> $converterschedule =
      const ScheduleConverter();
}

class Tracker extends DataClass implements Insertable<Tracker> {
  final String id;
  final String name;
  final String question;
  final List<Field> fields;
  final Schedule schedule;
  final int? iconCodePoint;
  final int sortOrder;
  final bool notificationsEnabled;
  final int notificationId;
  const Tracker({
    required this.id,
    required this.name,
    required this.question,
    required this.fields,
    required this.schedule,
    this.iconCodePoint,
    required this.sortOrder,
    required this.notificationsEnabled,
    required this.notificationId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['question'] = Variable<String>(question);
    {
      map['fields'] = Variable<String>(
        $TrackersTable.$converterfields.toSql(fields),
      );
    }
    {
      map['schedule'] = Variable<String>(
        $TrackersTable.$converterschedule.toSql(schedule),
      );
    }
    if (!nullToAbsent || iconCodePoint != null) {
      map['icon_code_point'] = Variable<int>(iconCodePoint);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['notification_id'] = Variable<int>(notificationId);
    return map;
  }

  TrackersCompanion toCompanion(bool nullToAbsent) {
    return TrackersCompanion(
      id: Value(id),
      name: Value(name),
      question: Value(question),
      fields: Value(fields),
      schedule: Value(schedule),
      iconCodePoint: iconCodePoint == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCodePoint),
      sortOrder: Value(sortOrder),
      notificationsEnabled: Value(notificationsEnabled),
      notificationId: Value(notificationId),
    );
  }

  factory Tracker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tracker(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      question: serializer.fromJson<String>(json['question']),
      fields: serializer.fromJson<List<Field>>(json['fields']),
      schedule: serializer.fromJson<Schedule>(json['schedule']),
      iconCodePoint: serializer.fromJson<int?>(json['iconCodePoint']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      notificationId: serializer.fromJson<int>(json['notificationId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'question': serializer.toJson<String>(question),
      'fields': serializer.toJson<List<Field>>(fields),
      'schedule': serializer.toJson<Schedule>(schedule),
      'iconCodePoint': serializer.toJson<int?>(iconCodePoint),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'notificationId': serializer.toJson<int>(notificationId),
    };
  }

  Tracker copyWith({
    String? id,
    String? name,
    String? question,
    List<Field>? fields,
    Schedule? schedule,
    Value<int?> iconCodePoint = const Value.absent(),
    int? sortOrder,
    bool? notificationsEnabled,
    int? notificationId,
  }) => Tracker(
    id: id ?? this.id,
    name: name ?? this.name,
    question: question ?? this.question,
    fields: fields ?? this.fields,
    schedule: schedule ?? this.schedule,
    iconCodePoint: iconCodePoint.present
        ? iconCodePoint.value
        : this.iconCodePoint,
    sortOrder: sortOrder ?? this.sortOrder,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    notificationId: notificationId ?? this.notificationId,
  );
  Tracker copyWithCompanion(TrackersCompanion data) {
    return Tracker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      question: data.question.present ? data.question.value : this.question,
      fields: data.fields.present ? data.fields.value : this.fields,
      schedule: data.schedule.present ? data.schedule.value : this.schedule,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tracker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('question: $question, ')
          ..write('fields: $fields, ')
          ..write('schedule: $schedule, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('notificationId: $notificationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    question,
    fields,
    schedule,
    iconCodePoint,
    sortOrder,
    notificationsEnabled,
    notificationId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tracker &&
          other.id == this.id &&
          other.name == this.name &&
          other.question == this.question &&
          other.fields == this.fields &&
          other.schedule == this.schedule &&
          other.iconCodePoint == this.iconCodePoint &&
          other.sortOrder == this.sortOrder &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.notificationId == this.notificationId);
}

class TrackersCompanion extends UpdateCompanion<Tracker> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> question;
  final Value<List<Field>> fields;
  final Value<Schedule> schedule;
  final Value<int?> iconCodePoint;
  final Value<int> sortOrder;
  final Value<bool> notificationsEnabled;
  final Value<int> notificationId;
  final Value<int> rowid;
  const TrackersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.question = const Value.absent(),
    this.fields = const Value.absent(),
    this.schedule = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackersCompanion.insert({
    required String id,
    required String name,
    required String question,
    required List<Field> fields,
    required Schedule schedule,
    this.iconCodePoint = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    required int notificationId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       question = Value(question),
       fields = Value(fields),
       schedule = Value(schedule),
       notificationId = Value(notificationId);
  static Insertable<Tracker> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? question,
    Expression<String>? fields,
    Expression<String>? schedule,
    Expression<int>? iconCodePoint,
    Expression<int>? sortOrder,
    Expression<bool>? notificationsEnabled,
    Expression<int>? notificationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (question != null) 'question': question,
      if (fields != null) 'fields': fields,
      if (schedule != null) 'schedule': schedule,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (notificationId != null) 'notification_id': notificationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? question,
    Value<List<Field>>? fields,
    Value<Schedule>? schedule,
    Value<int?>? iconCodePoint,
    Value<int>? sortOrder,
    Value<bool>? notificationsEnabled,
    Value<int>? notificationId,
    Value<int>? rowid,
  }) {
    return TrackersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      question: question ?? this.question,
      fields: fields ?? this.fields,
      schedule: schedule ?? this.schedule,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      sortOrder: sortOrder ?? this.sortOrder,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationId: notificationId ?? this.notificationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (fields.present) {
      map['fields'] = Variable<String>(
        $TrackersTable.$converterfields.toSql(fields.value),
      );
    }
    if (schedule.present) {
      map['schedule'] = Variable<String>(
        $TrackersTable.$converterschedule.toSql(schedule.value),
      );
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('question: $question, ')
          ..write('fields: $fields, ')
          ..write('schedule: $schedule, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('notificationId: $notificationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  values = GeneratedColumn<String>(
    'values',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($EntriesTable.$convertervalues);
  @override
  List<GeneratedColumn> get $columns => [id, trackerId, timestamp, values];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      values: $EntriesTable.$convertervalues.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}values'],
        )!,
      ),
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertervalues =
      const ValuesConverter();
}

class Entry extends DataClass implements Insertable<Entry> {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final Map<String, dynamic> values;
  const Entry({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    required this.values,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    {
      map['values'] = Variable<String>(
        $EntriesTable.$convertervalues.toSql(values),
      );
    }
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      timestamp: Value(timestamp),
      values: Value(values),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      values: serializer.fromJson<Map<String, dynamic>>(json['values']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'values': serializer.toJson<Map<String, dynamic>>(values),
    };
  }

  Entry copyWith({
    String? id,
    String? trackerId,
    DateTime? timestamp,
    Map<String, dynamic>? values,
  }) => Entry(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    timestamp: timestamp ?? this.timestamp,
    values: values ?? this.values,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      values: data.values.present ? data.values.value : this.values,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('values: $values')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, timestamp, values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.timestamp == this.timestamp &&
          other.values == this.values);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<DateTime> timestamp;
  final Value<Map<String, dynamic>> values;
  final Value<int> rowid;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.values = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required String id,
    required String trackerId,
    required DateTime timestamp,
    required Map<String, dynamic> values,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       timestamp = Value(timestamp),
       values = Value(values);
  static Insertable<Entry> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<DateTime>? timestamp,
    Expression<String>? values,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (timestamp != null) 'timestamp': timestamp,
      if (values != null) 'values': values,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<DateTime>? timestamp,
    Value<Map<String, dynamic>>? values,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      timestamp: timestamp ?? this.timestamp,
      values: values ?? this.values,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (values.present) {
      map['values'] = Variable<String>(
        $EntriesTable.$convertervalues.toSql(values.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('values: $values, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrackersTable trackers = $TrackersTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [trackers, entries];
}

typedef $$TrackersTableCreateCompanionBuilder =
    TrackersCompanion Function({
      required String id,
      required String name,
      required String question,
      required List<Field> fields,
      required Schedule schedule,
      Value<int?> iconCodePoint,
      Value<int> sortOrder,
      Value<bool> notificationsEnabled,
      required int notificationId,
      Value<int> rowid,
    });
typedef $$TrackersTableUpdateCompanionBuilder =
    TrackersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> question,
      Value<List<Field>> fields,
      Value<Schedule> schedule,
      Value<int?> iconCodePoint,
      Value<int> sortOrder,
      Value<bool> notificationsEnabled,
      Value<int> notificationId,
      Value<int> rowid,
    });

class $$TrackersTableFilterComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Field>, List<Field>, String> get fields =>
      $composableBuilder(
        column: $table.fields,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Schedule, Schedule, String> get schedule =>
      $composableBuilder(
        column: $table.schedule,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fields => $composableBuilder(
    column: $table.fields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schedule => $composableBuilder(
    column: $table.schedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Field>, String> get fields =>
      $composableBuilder(column: $table.fields, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Schedule, String> get schedule =>
      $composableBuilder(column: $table.schedule, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );
}

class $$TrackersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackersTable,
          Tracker,
          $$TrackersTableFilterComposer,
          $$TrackersTableOrderingComposer,
          $$TrackersTableAnnotationComposer,
          $$TrackersTableCreateCompanionBuilder,
          $$TrackersTableUpdateCompanionBuilder,
          (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
          Tracker,
          PrefetchHooks Function()
        > {
  $$TrackersTableTableManager(_$AppDatabase db, $TrackersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<List<Field>> fields = const Value.absent(),
                Value<Schedule> schedule = const Value.absent(),
                Value<int?> iconCodePoint = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion(
                id: id,
                name: name,
                question: question,
                fields: fields,
                schedule: schedule,
                iconCodePoint: iconCodePoint,
                sortOrder: sortOrder,
                notificationsEnabled: notificationsEnabled,
                notificationId: notificationId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String question,
                required List<Field> fields,
                required Schedule schedule,
                Value<int?> iconCodePoint = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                required int notificationId,
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion.insert(
                id: id,
                name: name,
                question: question,
                fields: fields,
                schedule: schedule,
                iconCodePoint: iconCodePoint,
                sortOrder: sortOrder,
                notificationsEnabled: notificationsEnabled,
                notificationId: notificationId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackersTable,
      Tracker,
      $$TrackersTableFilterComposer,
      $$TrackersTableOrderingComposer,
      $$TrackersTableAnnotationComposer,
      $$TrackersTableCreateCompanionBuilder,
      $$TrackersTableUpdateCompanionBuilder,
      (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
      Tracker,
      PrefetchHooks Function()
    >;
typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      required String id,
      required String trackerId,
      required DateTime timestamp,
      required Map<String, dynamic> values,
      Value<int> rowid,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<DateTime> timestamp,
      Value<Map<String, dynamic>> values,
      Value<int> rowid,
    });

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get values => $composableBuilder(
    column: $table.values,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get values => $composableBuilder(
    column: $table.values,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get values =>
      $composableBuilder(column: $table.values, builder: (column) => column);
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          Entry,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
          Entry,
          PrefetchHooks Function()
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<Map<String, dynamic>> values = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                values: values,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required DateTime timestamp,
                required Map<String, dynamic> values,
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                values: values,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      Entry,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
      Entry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrackersTableTableManager get trackers =>
      $$TrackersTableTableManager(_db, _db.trackers);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
}
