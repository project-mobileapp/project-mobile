import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CountdownScreen extends StatefulWidget {
  final String goalTitle;
  final String goalDescription;
  final int duration; // ระยะเวลานับถอยหลัง (วินาที)

  const CountdownScreen({
    super.key,
    required this.goalTitle,
    required this.goalDescription,
    required this.duration,
  });

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isFinished = false;
  bool _showRating = false;
  bool _isStarted = false; // ตัวแปรควบคุมการเริ่มต้น
  bool _isPaused = false;  // ตัวแปรควบคุมการหยุดพัก
  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ฟังก์ชันเริ่มนับถอยหลัง
  void _startCountdown() {
    setState(() {
      _isStarted = true; // เริ่มต้นนับถอยหลัง
      _isPaused = false; // ลบการหยุดพัก
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isFinished = true;
        });
        _timer?.cancel();
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showRating = true; // แสดงการให้คะแนน
          });
        });
      }
    });
  }

  // ฟังก์ชันหยุดนับถอยหลัง
  void _pauseCountdown() {
    setState(() {
      _isPaused = true; // หยุดพัก
      _timer?.cancel(); // หยุด Timer
    });
  }

  // ฟังก์ชันนับต่อ
  void _resumeCountdown() {
    setState(() {
      _isPaused = false;
      _startCountdown(); // เริ่มนับถอยหลังต่อ
    });
  }

  // ฟังก์ชันแปลงเวลาเป็นรูปแบบ "mm:ss"
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _submitRating() {
    setState(() {
      _showRating = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ขอบคุณที่พยายามอย่างหนัก!"),
          content: const Text("คุณจะพัฒนาต่อไปแน่นอน!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Dialog
                Navigator.pop(context); // กลับไปที่หน้าก่อนหน้า (AddGoal)
              },
              child: const Text("ปิด"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalTitle),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isFinished
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animation/firework.json',
                      width: 200, height: 200),
                  const SizedBox(height: 20),
                  const Text(
                    "ยินดีด้วย คุณทำสำเร็จแล้ว!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (_showRating)
                    Column(
                      children: [
                        const Text(
                          "ให้คะแนนตัวเอง:",
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1.0;
                                });
                              },
                            );
                          }),
                        ),
                        ElevatedButton(
                          onPressed: _rating > 0
                              ? _submitRating
                              : null, // ปิดปุ่มถ้าไม่ได้ให้คะแนน
                          child: const Text("ยืนยันการให้คะแนน"),
                        ),
                      ],
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // ใช้ Column สำหรับการจัดเรียงในแนวตั้ง
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "ชื่อ: ${widget.goalTitle}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "อธิบาย: ${widget.goalDescription}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _isStarted
                              ? (_remainingSeconds / widget.duration)
                              : 0,
                          strokeWidth: 10,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 164, 46)),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      _isStarted
                          ? Text(
                              _formatTime(_remainingSeconds),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            )
                          : ElevatedButton(
                              onPressed: _startCountdown,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20),
                                shape: const CircleBorder(),
                              ),
                              child: const Text(
                                "เริ่ม",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isStarted
                        ? (_isPaused ? _resumeCountdown : _pauseCountdown)
                        : null, // ปุ่มนี้จะทำงานเมื่อเริ่มนับถอยหลัง
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isPaused ? "นับต่อ" : "หยุดพัก",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
