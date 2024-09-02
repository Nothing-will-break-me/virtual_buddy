import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../settings/settings_controller.dart';
import '../activity_list/activity_model.dart';
import 'activity_add_service.dart';


class ActivityAddForm extends StatefulWidget {
  const ActivityAddForm({super.key, required this.controller});
  final SettingsController controller;

  @override
  State<ActivityAddForm> createState() => _ActivityAddFormState();
  
}

class _ActivityAddFormState extends State<ActivityAddForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime? _startDate;
  DateTime? _endDate;
  ActivityType? _eventType;

  void _submitForm(context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission logic here
      addActivity(_title, _description, _startDate!, _endDate!, _eventType!)
      .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successful activity addition!')),
        );
      })
      .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }

  void _pickDate(bool isStart) async {
    final pickedDate = await _selectDate();
    if (pickedDate == null) return;

    final pickedTime = await _selectTime();
    if (pickedTime == null) return;

    setState(() {
      final dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isStart) {
        _startDate = dateTime;
      } else {
        _endDate = dateTime;
      }
    });
  }

  Future<DateTime?> _selectDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _selectTime() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  String? _validateDates() {
    if (_startDate == null) {
      return 'Please select a start date and time';
    }
    if (_endDate == null) {
      return 'Please select an end date and time';
    }
    if (_endDate!.isBefore(_startDate!)) {
      return 'End date must be after start date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                    'Start Date: ${_startDate != null ? DateFormat('yyyy-MM-dd – kk:mm').format(_startDate!) : 'Not selected'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(true),
              ),
              ListTile(
                title: Text(
                    'End Date: ${_endDate != null ? DateFormat('yyyy-MM-dd – kk:mm').format(_endDate!) : 'Not selected'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(false),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _validateDates() ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              DropdownButtonFormField<ActivityType>(
                decoration: const InputDecoration(labelText: 'Event Type'),
                value: _eventType,
                items: ActivityType.values.map((ActivityType type) {
                  return DropdownMenuItem<ActivityType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (ActivityType? newValue) {
                  setState(() {
                    _eventType = newValue!;
                  });
                },
                onSaved: (value) {
                  _eventType = value!;
                },
                validator: (value) => value == null ? 'Please select a type' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final dateError = _validateDates();
                  if (_formKey.currentState!.validate() && dateError == null) {
                    _submitForm(context);
                  } else if (dateError != null) {
                    setState(() {});
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
