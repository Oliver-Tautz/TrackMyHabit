import 'package:flutter/material.dart';
import '../models/tracker.dart';
import '../models/field.dart';

class CreateTrackerScreen extends StatefulWidget {
  // When provided, the screen operates in "edit" mode and will prefill values.
  final Tracker? initialTracker;

  const CreateTrackerScreen({super.key, this.initialTracker});

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
  void initState() {
    super.initState();
    final t = widget.initialTracker;
    if (t != null) {
      // Prefill form for edit
      _nameController.text = t.name;
      _questionController.text = t.question;
      _selectedFrequency = t.schedule.frequency;
      _timeController.text = t.schedule.time;
      _fields.clear();
      for (var f in t.fields) {
        _fields.add(FieldData(name: f.name, type: f.type));
      }
      _selectedIcon = t.icon;
    }
  }

  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTracker == null ? 'Create New Tracker' : 'Edit Tracker',
        ),
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
              const SizedBox(height: 16),

              // Icon picker
              Text('Icon', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _buildIconPicker(),

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
                initialValue: _selectedFrequency,
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
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Time'),
                subtitle: Text(_timeController.text),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(_timeController.text.split(':')[0]),
                      minute: int.parse(_timeController.text.split(':')[1]),
                    ),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _timeController.text =
                          '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
                    });
                  }
                },
              ),

              const SizedBox(height: 16),
              // Frequency-specific selectors
              if (_selectedFrequency == Frequency.weekly) ...[
                Text(
                  'Day of week',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildWeekdaySelector(),
                const SizedBox(height: 16),
              ] else if (_selectedFrequency == Frequency.monthly) ...[
                Text(
                  'Day of month',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildDayOfMonthSelector(),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 32),

              // Create/Save button
              ElevatedButton(
                onPressed: _createTracker,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.initialTracker == null
                      ? 'Create Tracker'
                      : 'Save Changes',
                  style: const TextStyle(fontSize: 18),
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

  Widget _buildIconPicker() {
    // Choose 10 material icons to present as options
    final icons = [
      Icons.insights,
      Icons.fitness_center,
      Icons.fastfood,
      Icons.nest_cam_wired_stand,
      Icons.self_improvement,
      Icons.water,
      Icons.nightlight_round,
      Icons.directions_run,
      Icons.bedtime,
      Icons.checkroom,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: icons.map((ic) {
        final selected = _selectedIcon == ic;
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = ic),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: selected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Icon(
              ic,
              size: 32,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekdaySelector() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int? selected = widget.initialTracker?.schedule.weekday;
    if (_selectedFrequency == Frequency.weekly && _selectedIcon != null) {
      // noop
    }

    return Wrap(
      spacing: 8,
      children: List.generate(7, (i) {
        final dayNumber = i + 1; // 1..7
        final isSelected =
            (widget.initialTracker?.schedule.weekday == dayNumber) || (false);
        return ChoiceChip(
          label: Text(days[i]),
          selected: _selectedWeekday == dayNumber,
          onSelected: (_) {
            setState(() {
              _selectedWeekday = dayNumber;
            });
          },
        );
      }),
    );
  }

  Widget _buildDayOfMonthSelector() {
    return DropdownButton<int>(
      value: _selectedDayOfMonth,
      items: List.generate(31, (i) => i + 1)
          .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
          .toList(),
      onChanged: (v) => setState(() => _selectedDayOfMonth = v),
      hint: const Text('Select day'),
    );
  }

  int? _selectedWeekday;
  int? _selectedDayOfMonth;

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

      final id =
          widget.initialTracker?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final tracker = Tracker(
        id: id,
        name: _nameController.text,
        question: _questionController.text,
        fields: _fields
            .map((fd) => Field(name: fd.name, type: fd.type))
            .toList(),
        schedule: Schedule(
          frequency: _selectedFrequency,
          time: _timeController.text,
          weekday: _selectedWeekday,
          dayOfMonth: _selectedDayOfMonth,
        ),
        icon: _selectedIcon,
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
            initialValue: _selectedType,
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
