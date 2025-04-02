import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project/model/profile.dart';
import 'package:project/screen/goal_tracking.dart';
import 'package:project/screen/welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = new Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAipqWr4OO_igXIAdqD0aw1fHS9tDbCqoo",
          authDomain: "projectmobile-17f39.firebaseapp.com",
          projectId: "projectmobile-17f39",
          storageBucket: "projectmobile-17f39.firebasestorage.app",
          messagingSenderId: "373773082859",
          appId: "1:373773082859:web:6894de3bde90aad5159eae",
          measurementId: "G-46KQMG13DH"));
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(child: Text('${snapshot.error}')),
            );

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: Colors.amber[50],
                appBar: AppBar(
                  title: Text('Login'),
                  backgroundColor: Colors.amber[700],
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
                body: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Image.asset(
                              'images/1.jpg', // แก้ไขพาธตามไฟล์ที่ใช้งาน
                              width: 350,
                              height: 350,
                            ),
                            SizedBox(height: 50),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(fontSize: 25),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                                EmailValidator(
                                    errorText: 'รูปแบบอีเมลไม่ถูกต้อง')
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (email) {
                                profile.email = email;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 25),
                                ),
                                obscureText: true,
                                validator: RequiredValidator(
                                    errorText: 'กรุณาป้อนรหัสผ่าน'),
                                onSaved: (password) {
                                  profile.password = password;
                                }),
                            SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: profile.email.toString(),
                                              password:
                                                  profile.password.toString())
                                          .then((value) {
                                        formKey.currentState!.reset();
                                        Fluttertoast.showToast(
                                            msg: 'Login สำเร็จ');
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MainScreen();
                                        }));
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      Fluttertoast.showToast(
                                          msg: e.message.toString());
                                    }
                                  }
                                },
                                icon: Icon(Icons.app_registration_rounded,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)), // ไอคอนสีขาว
                                label: Text('Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255))),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.amber[700], // กำหนดสีพื้นหลัง
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
