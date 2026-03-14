enum FieldType { integer, float, text, image }

class Field {
  final String name;
  final FieldType type;

  Field({required this.name, required this.type});
}
