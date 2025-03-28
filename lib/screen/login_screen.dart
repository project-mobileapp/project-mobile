import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project/screen/goal_tracking.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/2.jpg', // แก้ไขพาธตามไฟล์ที่ใช้งาน
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 1),
            const CustomTextField(labelText: "Email", icon: Icons.email),
            const SizedBox(height: 20),
            const CustomTextField(
              labelText: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            AnimatedProgressButton(
              text: "Login",
              icon: Icons.login,
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: "New customer? ",
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: "Create new account",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
