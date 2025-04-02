import 'package:flutter/material.dart';
import 'package:project/screen/login.dart';
import 'package:project/screen/register.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggingIn = false;
  bool _isRegistering = false;

  void _login() {
    setState(() {
      _isLoggingIn = true;
    });
    // Simulating a login process with a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoggingIn = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  void _register() {
    setState(() {
      _isRegistering = true;
    });
    // Simulating a registration process with a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isRegistering = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Goal Tracker🏆'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
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
                'images/2.jpg', // Update the image path as needed
                width: 350,
                height: 350,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoggingIn ? null : _login,
                  icon: _isLoggingIn
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Icon(Icons.login, color: Colors.white),
                  label: Text(
                    _isLoggingIn ? 'Logging In...' : 'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isRegistering ? null : _register,
                  icon: _isRegistering
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Icon(Icons.person_add, color: Colors.white),
                  label: Text(
                    _isRegistering ? 'Registering...' : 'Register',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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