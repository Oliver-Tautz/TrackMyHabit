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