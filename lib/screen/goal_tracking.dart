import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          content: Container(
            width: 250.0, // กำหนดความกว้างของ QR Code
            height: 250.0, // กำหนดความสูงของ QR Code
            child: QrImageView(
              data:
                  '{"title": "$title", "description": "$description", "time": "$time"}',
              version: QrVersions.auto,
              size: 200.0, // ขนาดของ QR Code
              backgroundColor: Colors.white, // พื้นหลังของ QR Code
              foregroundColor: Colors.black, // สีของ QR Code
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
      body: goals.isEmpty
          ? const Center(child: Text('No goals added yet!'))
          : ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      goals[index]['title']!,
                    ),
                    subtitle: Text(
                      '${goals[index]['description']} \nTime: ${goals[index]['time']} hr',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditGoal(onSaveGoal: _saveGoal);
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            // เรียกใช้ฟังก์ชันแสดง QR Code ที่นี่
                            _showQrCodeDialog(
                              context,
                              goals[index]['title']!,
                              goals[index]['description']!,
                              goals[index]['time']!,
                            );
                          },
                          icon: Icon(Icons.qr_code), // ใช้ไอคอน QR Code
                        ),
                      ],
                    ),
                  ),
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
                    return Addgoal(onSaveGoal: _saveGoal);
                  },
                );
              },
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.playlist_add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {},
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.bar_chart),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
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
//
