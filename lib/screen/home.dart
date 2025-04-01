import 'package:flutter/material.dart';
import 'package:project/screen/login.dart';
import 'package:project/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Tracker🏆'),
        backgroundColor: Colors.amber[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
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
                  icon: Icon(Icons.login, color: Colors.black), // ไอคอนสีขาว
                  label: Text("Login",
                      style: TextStyle(
                          fontSize: 20, color: Colors.black)), // ตัวหนังสือสีขาว
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700], // กำหนดสีพื้นหลัง
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                  icon: Icon(Icons.add, color: Colors.black), // ไอคอนสีขาว
                  label: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 20, color: Colors.black), // ตัวหนังสือสีขาว
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700], // กำหนดสีพื้นหลัง
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
