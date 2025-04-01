import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/screen/goal_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDHxt6mOyBexwBluBBnWY-OEWiWcMcFkt8",
          authDomain: "gold-gold-3a89f.firebaseapp.com",
          projectId: "gold-gold-3a89f",
          storageBucket: "gold-gold-3a89f.firebasestorage.app",
          messagingSenderId: "64206464929",
          appId: "1:64206464929:web:0023767a9f197a27b1cde0",
          measurementId: "G-NZRL07K7B6"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home:
          const OnboardingScreen(), // เปลี่ยนจาก HomeScreen เป็น OnboardingScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
