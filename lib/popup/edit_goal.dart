import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditGoal extends StatefulWidget {
  final String goalId;
  final String currentTitle;
  final String currentDescription;
  final String currentTime;

  const EditGoal({
    Key? key,
    required this.goalId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentTime,
  }) : super(key: key);

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  late TextEditingController _goalTitleController;
  late TextEditingController _goalDescriptionController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _goalTitleController = TextEditingController(text: widget.currentTitle);
    _goalDescriptionController =
        TextEditingController(text: widget.currentDescription);
    _selectedTime =
        _parseTime(widget.currentTime); // แปลงเวลาจาก String เป็น TimeOfDay
  }

  @override
  void dispose() {
    _goalTitleController.dispose();
    _goalDescriptionController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  String _formatTime() {
    String hour = _selectedTime.hour.toString().padLeft(2, '0');
    String minute = _selectedTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Future<void> _updateGoalToFirebase() async {
    String title = _goalTitleController.text.trim();
    String description = _goalDescriptionController.text.trim();
    String time = _formatTime();

    if (title.isEmpty || description.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('goals')
          .doc(widget.goalId)
          .update({
        'title': title,
        'description': description,
        'time': time,
        'updated_at': FieldValue.serverTimestamp(), // อัปเดตเวลาที่แก้ไข
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteGoalFromFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('goals')
          .doc(widget.goalId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal deleted successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Goal'),
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
              OutlinedButton(
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _updateGoalToFirebase,
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: _deleteGoalFromFirebase,
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
