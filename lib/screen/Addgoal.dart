import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Addgoal extends StatefulWidget {
  const Addgoal({super.key});

  @override
  _AddgoalState createState() => _AddgoalState();
}

class _AddgoalState extends State<Addgoal> {
  final TextEditingController _goalTitleController = TextEditingController();
  final TextEditingController _goalDescriptionController =
      TextEditingController();
  TimeOfDay? _selectedTime = TimeOfDay(hour: 0, minute: 0);

  // Pick time using Cupertino Modal Popup
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
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedTime);
                    },
                  ),
                ],
              ),
              const Divider(height: 0, thickness: 1),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
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

  // Format the time to "hh:mm"
  String _formatTime() {
    String hour = _selectedTime!.hour.toString().padLeft(2, '0');
    String minute = _selectedTime!.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  // Save goal data to Firestore
  Future<void> _saveGoalToFirebase() async {
    String title = _goalTitleController.text.trim();
    String description = _goalDescriptionController.text.trim();
    String time = _formatTime();

    if (title.isEmpty || description.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Check if user is logged in
      if (FirebaseAuth.instance.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is logged in')),
        );
        return;
      }

      // Save to Firestore
      await FirebaseFirestore.instance.collection('goals').add({
        'title': title,
        'description': description,
        'time': time,
        'user_email':
            FirebaseAuth.instance.currentUser?.email, // store the email
        'created_at': FieldValue.serverTimestamp(), // store creation timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal saved successfully!')),
      );

      // Close the dialog after saving
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
          onPressed: _saveGoalToFirebase, // Save data to Firebase
          child: const Text('Save'),
        ),
      ],
    );
  }
}
