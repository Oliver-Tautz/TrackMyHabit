import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';

class CreateTrackerScreen extends StatefulWidget {
  const CreateTrackerScreen({super.key});

  @override
  State<CreateTrackerScreen> createState() => _CreateTrackerScreenState();
}

class _CreateTrackerScreenState extends State<CreateTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _questionController = TextEditingController();
  final List<FieldData> _fields = [];
  Frequency _selectedFrequency = Frequency.daily;
  final _timeController = TextEditingController(text: '08:00');

  @override
  void dispose() {
    _nameController.dispose();
    _questionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tracker name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tracker Name',
                  hintText: 'e.g., Weight Tracker',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tracker name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Question
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  hintText: 'e.g., What is your weight today?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.help_outline),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Fields section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fields', style: Theme.of(context).textTheme.titleLarge),
                  TextButton.icon(
                    onPressed: _addField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Field'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Fields list
              if (_fields.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No fields yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Add at least one field to track',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._fields.asMap().entries.map((entry) {
                  final index = entry.key;
                  final field = entry.value;
                  return _buildFieldCard(field, index);
                }),

              const SizedBox(height: 24),

              // Schedule section
              Text('Schedule', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),

              // Frequency dropdown
              DropdownButtonFormField<Frequency>(
                value: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                ),
                items: Frequency.values.map((freq) {
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(_getFrequencyText(freq)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Time input
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: '08:00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Create button
              ElevatedButton(
                onPressed: _createTracker,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Create Tracker',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard(FieldData fieldData, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Icon(_getFieldTypeIcon(fieldData.type))),
        title: Text(fieldData.name),
        subtitle: Text(_getFieldTypeText(fieldData.type)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeField(index),
        ),
      ),
    );
  }

  void _addField() {
    showDialog(
      context: context,
      builder: (context) => _AddFieldDialog(
        onAdd: (fieldData) {
          setState(() {
            _fields.add(fieldData);
          });
        },
      ),
    );
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  String _getFrequencyText(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.monthly:
        return 'Monthly';
      case Frequency.custom:
        return 'Custom';
    }
  }

  String _getFieldTypeText(FieldType type) {
    switch (type) {
      case FieldType.integer:
        return 'Integer';
      case FieldType.float:
        return 'Decimal';
      case FieldType.text:
        return 'Text';
      case FieldType.image:
        return 'Image';
    }
  }

  IconData _getFieldTypeIcon(FieldType type) {
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

  void _createTracker() {
    if (_formKey.currentState!.validate()) {
      if (_fields.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one field'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final tracker = Tracker(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        question: _questionController.text,
        fields: _fields
            .map((fd) => Field(name: fd.name, type: fd.type))
            .toList(),
        schedule: Schedule(
          frequency: _selectedFrequency,
          time: _timeController.text,
        ),
      );

      Navigator.pop(context, tracker);
    }
  }
}

// Helper class to store field data during creation
class FieldData {
  final String name;
  final FieldType type;

  FieldData({required this.name, required this.type});
}

// Dialog for adding a new field
class _AddFieldDialog extends StatefulWidget {
  final Function(FieldData) onAdd;

  const _AddFieldDialog({required this.onAdd});

  @override
  State<_AddFieldDialog> createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<_AddFieldDialog> {
  final _nameController = TextEditingController();
  FieldType _selectedType = FieldType.float;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Field'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Field Name',
              hintText: 'e.g., Weight',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<FieldType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Field Type',
              border: OutlineInputBorder(),
            ),
            items: FieldType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_getFieldTypeText(type)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(
                FieldData(name: _nameController.text, type: _selectedType),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  String _getFieldTypeText(FieldType type) {
    switch (type) {
      case FieldType.integer:
        return 'Integer';
      case FieldType.float:
        return 'Decimal';
      case FieldType.text:
        return 'Text';
      case FieldType.image:
        return 'Image';
    }
  }
}
