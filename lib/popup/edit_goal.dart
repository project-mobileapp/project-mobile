import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditGoal extends StatefulWidget {
  final Function(String title, String description, String time) onSaveGoal;

  const EditGoal({super.key, required this.onSaveGoal});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final TextEditingController _goalTitleController = TextEditingController();
  final TextEditingController _goalDescriptionController =
      TextEditingController();
  TimeOfDay? _selectedTime = TimeOfDay(hour: 0, minute: 0); // ค่าเริ่มต้น 00:00

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (context) {
        TimeOfDay tempPickedTime = _selectedTime!;
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Delete',
                        style: TextStyle(fontFamily: 'Dana')),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Save',
                        style: TextStyle(fontFamily: 'Dana')),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedTime);
                    },
                  ),
                ],
              ),
              const Divider(height: 0, thickness: 1),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm, // เลือกแค่ ชั่วโมง:นาที
                  initialTimerDuration: Duration(
                    hours: _selectedTime!.hour,
                    minutes: _selectedTime!.minute,
                  ),
                  onTimerDurationChanged: (Duration newDuration) {
                    tempPickedTime = TimeOfDay(
                      hour: newDuration.inHours,
                      minute: newDuration.inMinutes % 60,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  /// แปลงเวลาให้เป็นรูปแบบ HH:mm (ตัด AM/PM)
  String _formatTime() {
    String hour = _selectedTime!.hour.toString().padLeft(2, '0');
    String minute = _selectedTime!.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    // เช็คเงื่อนไขว่ากรอกครบหรือยัง
    bool isFormValid = _goalTitleController.text.isNotEmpty &&
        _goalDescriptionController.text.isNotEmpty &&
        _selectedTime != null;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Goal'),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Selected Time: "),
              FloatingActionButton(
                onPressed: _pickTime,
                child: Text(_formatTime()),
              ),
              const Text("hr")
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
//
