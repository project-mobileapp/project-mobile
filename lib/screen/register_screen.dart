import 'package:flutter/material.dart';
import 'package:project/screen/goal_tracking.dart';
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
            Image.asset(
              'images/2.jpg', // Update with your actual image path
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 30),
            const CustomTextField(
              labelText: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 30),
            const CustomTextField(
              labelText: "Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress, validator: _emailValidator),
            const SizedBox(height: 30),
            const CustomTextField(
              labelText: "Password",
              icon: Icons.lock,
              obscureText: true, // Hide password input
            ),
            const SizedBox(height: 24),
            AnimatedProgressButton(
              text: "Register",
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Email validator function
  static String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final emailRegex = RegExp(emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
