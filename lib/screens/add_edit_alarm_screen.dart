import 'package:flutter/material.dart';
import '../models/alarm.dart' as alarm_model;
import '../services/alarm_service.dart';

class AddEditAlarmScreen extends StatefulWidget {
  final alarm_model.Alarm? alarm;

  const AddEditAlarmScreen({super.key, this.alarm});

  @override
  State<AddEditAlarmScreen> createState() => _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends State<AddEditAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _alarmService = AlarmService();

  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);
  List<int> _selectedDays = [];
  bool _hasMathChallenge = false;
  bool _isVibrateEnabled = true;
  int _volume = 100;
  String? _ringtonePath;
  int? _ringtoneStartTime;

  final List<String> _dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      _titleController.text = widget.alarm!.title;
      _selectedTime = TimeOfDay(
        hour: widget.alarm!.time.hour,
        minute: widget.alarm!.time.minute,
      );
      _selectedDays = List.from(widget.alarm!.repeatDays);
      _hasMathChallenge = widget.alarm!.hasMathChallenge;
      _isVibrateEnabled = widget.alarm!.isVibrateEnabled;
      _volume = widget.alarm!.volume;
      _ringtonePath = widget.alarm!.ringtonePath;
      _ringtoneStartTime = widget.alarm!.ringtoneStartTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'Add Alarm' : 'Edit Alarm'),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Alarm Title',
                hintText: 'Enter alarm name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an alarm title';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Time picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Time'),
                subtitle: Text(_selectedTime.toString()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectTime,
              ),
            ),

            const SizedBox(height: 16),

            // Repeat days
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Repeat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        final isSelected = _selectedDays.contains(index);
                        return FilterChip(
                          label: Text(_dayNames[index].substring(0, 3)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedDays.add(index);
                              } else {
                                _selectedDays.remove(index);
                              }
                              _selectedDays.sort();
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Math Challenge toggle
            Card(
              child: SwitchListTile(
                title: const Text('Math Challenge'),
                subtitle: const Text('Solve math problems to stop alarm'),
                value: _hasMathChallenge,
                onChanged: (value) {
                  setState(() {
                    _hasMathChallenge = value;
                  });
                },
                secondary: const Icon(Icons.calculate),
              ),
            ),

            const SizedBox(height: 16),

            // Vibrate toggle
            Card(
              child: SwitchListTile(
                title: const Text('Vibrate'),
                subtitle: const Text('Vibrate when alarm rings'),
                value: _isVibrateEnabled,
                onChanged: (value) {
                  setState(() {
                    _isVibrateEnabled = value;
                  });
                },
                secondary: const Icon(Icons.vibration),
              ),
            ),

            const SizedBox(height: 16),

            // Volume slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.volume_up),
                        const SizedBox(width: 8),
                        Text(
                          'Volume: $_volume%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _volume.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _volume = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ringtone selection
            Card(
              child: ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Ringtone'),
                subtitle: Text(_ringtonePath ?? 'Default ringtone'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectRingtone,
              ),
            ),

            if (_ringtonePath != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringtone Start Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _ringtoneStartTime != null
                            ? '${_ringtoneStartTime! ~/ 60}:${(_ringtoneStartTime! % 60).toString().padLeft(2, '0')}'
                            : '0:00',
                      ),
                      Slider(
                        value: (_ringtoneStartTime ?? 0).toDouble(),
                        min: 0,
                        max: 300, // 5 minutes max
                        divisions: 30,
                        onChanged: (value) {
                          setState(() {
                            _ringtoneStartTime = value.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _selectRingtone() async {
    // For now, we'll use a simple dialog to select ringtone
    // In a real app, you would use file_picker to select audio files
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Ringtone'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Default Ringtone'),
              onTap: () => Navigator.pop(context, null),
            ),
            ListTile(
              title: const Text('Custom Ringtone'),
              subtitle: const Text('Select from device storage'),
              onTap: () => Navigator.pop(context, 'custom'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result == 'custom') {
          _ringtonePath = 'custom_ringtone.mp3';
          _ringtoneStartTime = 0;
        } else {
          _ringtonePath = null;
          _ringtoneStartTime = null;
        }
      });
    }
  }

  Future<void> _saveAlarm() async {
    if (!_formKey.currentState!.validate()) return;

    final alarm = alarm_model.Alarm(
      id: widget.alarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      time: alarm_model.TimeOfDay(
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
      ),
      repeatDays: _selectedDays,
      isEnabled: true,
      hasMathChallenge: _hasMathChallenge,
      ringtonePath: _ringtonePath,
      ringtoneStartTime: _ringtoneStartTime,
      isVibrateEnabled: _isVibrateEnabled,
      volume: _volume,
    );

    if (widget.alarm == null) {
      await _alarmService.addAlarm(alarm);
    } else {
      await _alarmService.updateAlarm(alarm);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
