import 'package:flutter/material.dart';
import 'package:project/screen/goal_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Added import for Firebase initialization

class SettingScreen extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure Firebase is initialized
    Firebase.initializeApp();
  }

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
                SizedBox(width: 16),
                Text(
                  (widget.auth.currentUser?.email ?? 'User not logged in'),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              _showChangePasswordDialog(context);
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
    try {
      // 🔹 เคลียร์ข้อมูลผู้ใช้
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 🔹 พาผู้ใช้กลับไปหน้า OnboardingScreen และล้าง stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Enter new password",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: "Confirm password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updatePassword(_passwordController.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Password changed successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No user logged in")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

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
