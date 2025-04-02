import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/screen/countdown_screen.dart';
import 'package:project/screen/finished_tasks.dart';
import 'package:project/screen/setting_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Addgoal.dart';
import 'package:project/popup/edit_goal.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  List<Map<String, String>> goals = []; // เก็บรายการเป้าหมาย
  int _convertTimeToSeconds(String time) {
    List<String> parts = time.split(':'); // แยกชั่วโมงและนาที (HH:mm)
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return (hours * 3600) + (minutes * 60);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _saveGoal(String title, String description, String time) {
    setState(() {
      goals.add({'title': title, 'description': description, 'time': time});
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Goal "$title" saved successfully at $time')),
    );
  }

  void _showQrCodeDialog(
      BuildContext context, String title, String description, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: SizedBox(
            width: 250.0, // กำหนดความกว้างของ QR Code
            height: 250.0, // กำหนดความสูงของ QR Code
            child: QrImageView(
              data:
                  'หัวข้อ: $title\nคำอธิบาย: $description\nเวลา: $time ชั่วโมง',
              version: QrVersions.auto,
              size: 200.0, // ขนาดของ QR Code
              backgroundColor: Colors.white, // พื้นหลังของ QR Code
              foregroundColor: Colors.white, // สีของ QR Code
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Tracking🏆'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('goals')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No goals added yet!'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var goal = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(goal['title']),
                  subtitle:
                      Text('${goal['description']} \nTime: ${goal['time']} hr'),
                  onTap: () {
                    int durationInSeconds = _convertTimeToSeconds(goal['time']);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CountdownScreen(
                          goalTitle: goal['title'],
                          goalDescription: goal['description'],
                          duration: durationInSeconds,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showQrCodeDialog(
                            context,
                            goal['title'],
                            goal['description'],
                            goal['time'],
                          );
                        },
                        icon: const Icon(Icons.qr_code),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditGoal(
                                goalId: goal.id,
                                currentTitle: goal['title'],
                                currentDescription: goal['description'],
                                currentTime: goal['time'],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded) ...[
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Addgoal(); // ✅ เรียกใช้งานโดยไม่ต้องส่ง onSaveGoal
                  },
                );
              },
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.add_task),
            ),
            const SizedBox(height: 10),
             FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>FinishedTasksScreen()),
                );
              },
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.task_alt),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.settings),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            heroTag: "toggle",
            onPressed: _toggleExpand,
            backgroundColor: Colors.amber[700],
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
//asdasd
