

import 'package:flutter/material.dart';
import 'package:project/screen/login.dart';
import 'package:project/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register & Login with Firebase'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
              'images/2.jpg', // แก้ไขพาธตามไฟล์ที่ใช้งาน
              width: 350,
              height: 350,
            ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    icon: Icon(Icons.login),
                    label: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterScreen();
                      }));
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
