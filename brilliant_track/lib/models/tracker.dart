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

  Schedule({required this.frequency, required this.time, this.cronExpression});
}

class Tracker {
  final String id;
  final String name;
  final String question;
  final List<Field> fields;
  final Schedule schedule;

  Tracker({
    required this.id,
    required this.name,
    required this.question,
    required this.fields,
    required this.schedule,
  });
}
