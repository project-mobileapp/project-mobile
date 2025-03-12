import 'package:flutter/material.dart';
import 'package:project/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'change_password_screen.dart'; // Import หน้าเปลี่ยนรหัสผ่าน

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // ✅ ส่วนของโปรไฟล์
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.amber[100],
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("eiei goalgoal",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("eieigoalgoal@example.com",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // ✅ เปลี่ยนชื่อ
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Change Name"),
            onTap: () {
              _showChangeNameDialog(context);
            },
          ),

          // ✅ เปลี่ยน username
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text("Change Username"),
            onTap: () {
              _showChangeUsernameDialog(context);
            },
          ),

          // ✅ เปลี่ยนรหัสผ่าน
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),

          // ✅ เกี่ยวกับเรา
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About Us"),
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          // ✅ ออกจากระบบ
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
    );
  }

  // ✅ ฟังก์ชัน Logout
  Future<void> _logout(BuildContext context) async {
    // 🔹 เคลียร์ข้อมูลผู้ใช้
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 🔹 พาผู้ใช้กลับไปหน้า OnboardingScreen และล้าง stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false,
    );
  }

  // ✅ แสดง Dialog เปลี่ยนชื่อ
  void _showChangeNameDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Name"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Name changed to: ${_nameController.text}")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ✅ แสดง Dialog เปลี่ยน username
  void _showChangeUsernameDialog(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Username"),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Username changed to: ${_usernameController.text}")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ✅ แสดง Dialog เกี่ยวกับเรา
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("About Us"),
          content: const Text("This is a Flutter App developed by eiei."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // ✅ แสดง Dialog ยืนยันออกจากระบบ
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Dialog
                _logout(context);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
