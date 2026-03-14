import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';
import '../models/entry.dart';

class InputScreen extends StatefulWidget {
  final Tracker tracker;

  const InputScreen({super.key, required this.tracker});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Create a controller for each field
    for (var field in widget.tracker.fields) {
      _controllers[field.name] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tracker.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question card
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.tracker.question,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input fields
              ...widget.tracker.fields.map((field) => _buildFieldInput(field)),

              const SizedBox(height: 24),

              // Date/Time picker
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date & Time'),
                  subtitle: Text(
                    '${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')} '
                    '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: _selectDateTime,
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Entry', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldInput(Field field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers[field.name],
        decoration: InputDecoration(
          labelText: field.name,
          border: const OutlineInputBorder(),
          suffixIcon: Icon(_getFieldIcon(field.type)),
        ),
        keyboardType: _getKeyboardType(field.type),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${field.name}';
          }
          if (field.type == FieldType.integer ||
              field.type == FieldType.float) {
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
          }
          return null;
        },
      ),
    );
  }

  IconData _getFieldIcon(FieldType type) {
    switch (type) {
      case FieldType.integer:
      case FieldType.float:
        return Icons.numbers;
      case FieldType.text:
        return Icons.text_fields;
      case FieldType.image:
        return Icons.image;
    }
  }

  TextInputType _getKeyboardType(FieldType type) {
    switch (type) {
      case FieldType.integer:
        return TextInputType.number;
      case FieldType.float:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.text:
        return TextInputType.text;
      case FieldType.image:
        return TextInputType.text;
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      // Collect values from controllers
      final Map<String, dynamic> values = {};
      for (var field in widget.tracker.fields) {
        final value = _controllers[field.name]!.text;
        // Convert to appropriate type
        if (field.type == FieldType.integer) {
          values[field.name] = int.parse(value);
        } else if (field.type == FieldType.float) {
          values[field.name] = double.parse(value);
        } else {
          values[field.name] = value;
        }
      }

      // Create entry
      final entry = Entry(
        trackerId: widget.tracker.id,
        timestamp: _selectedDateTime,
        values: values,
      );

      // TODO: Save to storage service
      print('Entry saved: ${entry.values}');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back to home screen
      Navigator.pop(context);
    }
  }
}
