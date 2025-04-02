import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screen/Addgoal.dart';
import 'package:project/screen/countdown_screen.dart';
import 'package:project/screen/setting_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:project/popup/edit_goal.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;

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
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showQrCodeDialog(
      BuildContext context, String title, String description, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: SizedBox(
            width: 250.0,
            height: 250.0,
            child: QrImageView(
              data:
                  'หัวข้อ: $title\nคำอธิบาย: $description\nเวลา: $time ชั่วโมง',
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
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
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Details'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('goals')
            .where('user_email', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No goals available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var goal = snapshot.data!.docs[index];

              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
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
                  title: Text(goal['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${goal['description']}'),
                      Text('Time: ${goal['time']} ชั่วโมง'),
                    ],
                  ),
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
          if (_isMenuOpen) ...[
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Addgoal();
                  },
                );
              },
              heroTag: "btn3",
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
              heroTag: "btn1",
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.settings),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
                if (_isMenuOpen) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
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
}
