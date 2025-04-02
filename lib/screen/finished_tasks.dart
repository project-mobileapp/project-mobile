import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinishedTasksScreen extends StatefulWidget {
  const FinishedTasksScreen({super.key});

  @override
  _FinishedTasksScreenState createState() => _FinishedTasksScreenState();
}

class _FinishedTasksScreenState extends State<FinishedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks ที่สำเร็จแล้ว ✅'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('finished_tasks') // ดึงจาก collection ที่เก็บ tasks ที่สำเร็จ
            .orderBy('finished_at', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ยังไม่มี Task ที่สำเร็จ! 🎉'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var task = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(task['title']),
                  subtitle: Text('${task['description']} \nเสร็จเมื่อ: ${task['finished_at']}'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
