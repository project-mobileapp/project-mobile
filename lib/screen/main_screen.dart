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

  @override
  Widget build(BuildContext context) {
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
                    title: Text(goals[index]['title']!),
                    subtitle: Text(
                      '${goals[index]['description']} \nTime: ${goals[index]['time']} hr',
                    ),
                    isThreeLine: true,
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