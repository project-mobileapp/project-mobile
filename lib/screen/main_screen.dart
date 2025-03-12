import 'package:flutter/material.dart';
import 'package:project/screen/setting_screen.dart';
import 'Addgoal.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

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

  // Callback function to save the goal
  void _saveGoal(String title, String description, String time) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Goal "$title" saved successfully at $time')),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Tracking🏆'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded) ...[
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                // Show the Addgoal dialog and pass the _saveGoal callback
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    void _showMessage(String message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }

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
              onPressed: () => _showMessage("View Progress"),
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
