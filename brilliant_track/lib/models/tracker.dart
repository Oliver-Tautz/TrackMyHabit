import 'package:flutter/material.dart';
import 'field.dart';

enum Frequency {
  daily,
  weekly,
  monthly,
  custom, // For cron-like expressions
}

class Schedule {
  final Frequency frequency;
  final String time; // e.g., "08:00" for simple schedules
  final String? cronExpression; // Optional: for custom/advanced scheduling
  final int? weekday; // 1=Monday .. 7=Sunday for weekly schedules
  final int? dayOfMonth; // 1..31 for monthly schedules

  Schedule({
    required this.frequency,
    required this.time,
    this.cronExpression,
    this.weekday,
    this.dayOfMonth,
  });
}

class Tracker {
  final String id;
  final String name;
  final String question;
  final List<Field> fields;
  final Schedule schedule;
  final IconData? icon;
  final bool notificationsEnabled;
  final int notificationId;

  Tracker({
    required this.id,
    required this.name,
    required this.question,
    required this.fields,
    required this.schedule,
    int? notificationId,
    this.icon,
    this.notificationsEnabled = true,
  }) : notificationId = notificationId ?? id.hashCode & 0x7fffffff;

  Tracker copyWith({
    String? name,
    String? question,
    List<Field>? fields,
    Schedule? schedule,
    IconData? icon,
    bool? notificationsEnabled,
  }) {
    return Tracker(
      id: id,
      name: name ?? this.name,
      question: question ?? this.question,
      fields: fields ?? this.fields,
      schedule: schedule ?? this.schedule,
      icon: icon ?? this.icon,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationId: notificationId,
    );
  }
}
