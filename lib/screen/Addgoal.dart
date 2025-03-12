// Addgoal.dart
import 'package:flutter/material.dart';

class Addgoal extends StatelessWidget {
  final Function(String title, String description, String time) onSaveGoal;

  Addgoal({required this.onSaveGoal});

  final TextEditingController _goalTitleController = TextEditingController();
  final TextEditingController _goalDescriptionController = TextEditingController();
  String? _selectedHour = '12';
  String? _selectedMinute = '00';
  String? _selectedSecond = '00';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _goalTitleController,
            decoration: const InputDecoration(labelText: 'Goal Title'),
          ),
          TextField(
            controller: _goalDescriptionController,
            decoration: const InputDecoration(labelText: 'Goal Description'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _selectedHour,
                items: List.generate(24, (index) {
                  String hour = index < 10 ? '0$index' : '$index';
                  return DropdownMenuItem(
                    value: hour,
                    child: Text(hour),
                  );
                }),
                onChanged: (value) {
                  _selectedHour = value;
                },
                hint: const Text('Hour'),
              ),
              const Text('hr'),
              const Text(':'),
              DropdownButton<String>(
                value: _selectedMinute,
                items: List.generate(60, (index) {
                  String minute = index < 10 ? '0$index' : '$index';
                  return DropdownMenuItem(
                    value: minute,
                    child: Text(minute),
                  );
                }),
                onChanged: (value) {
                  _selectedMinute = value;
                },
                hint: const Text('Minute'),
              ),
              const Text('m'),
              const Text(':'),
              DropdownButton<String>(
                value: _selectedSecond,
                items: List.generate(60, (index) {
                  String second = index < 10 ? '0$index' : '$index';
                  return DropdownMenuItem(
                    value: second,
                    child: Text(second),
                  );
                }),
                onChanged: (value) {
                  _selectedSecond = value;
                },
                hint: const Text('Second'),
              ),
              const Text('s'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Save goal when Save button is clicked
            onSaveGoal(
              _goalTitleController.text,
              _goalDescriptionController.text,
              '$_selectedHour:$_selectedMinute:$_selectedSecond',
            );
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
