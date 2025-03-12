import 'package:flutter/material.dart';
import 'package:project/screen/main_screen.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomTextField(labelText: "Full Name", icon: Icons.person),
            const SizedBox(height: 30),
            const CustomTextField(labelText: "Email", icon: Icons.email),
            const SizedBox(height: 30),
            const CustomTextField(labelText: "Password", icon: Icons.lock, obscureText: true),
            const SizedBox(height: 24),
            AnimatedProgressButton(text: "Register",
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1)); // จำลองการโหลดข้อมูล
                if (context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MainScreen()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
