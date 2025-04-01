

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screen/home.dart';

class WelcomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'อีเมลของคุณคือ ' + auth.currentUser!.email.toString(),
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
                  },
                  child: Text('ออกจากระบบ'))
            ],
          ),
        ),
      ),
    );
  }
}
