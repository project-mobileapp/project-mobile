import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50], 
      appBar: AppBar(
        title: const Text('Goal Tracker🏆'),
        centerTitle: true,
        backgroundColor: Colors.amber[700], 
        foregroundColor: Colors.white, 
        elevation: 0, // ทำให้ AppBar ดูเรียบ
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildOnboardingPage(
                    icon: Icons.flag,
                    title: 'Track Your Goals',
                    description:
                        'Stay motivated and organized by tracking your goals efficiently.',
                  ),
                  _buildOnboardingPage(
                    icon: Icons.check_circle_outline,
                    title: 'Set Milestones',
                    description:
                        'Break down your goals into smaller milestones for better progress tracking.',
                  ),
                  _buildOnboardingPage(
                    icon: Icons.trending_up,
                    title: 'Achieve More',
                    description:
                        'Keep track of your progress and achieve more with effective goal management.',
                    isLastPage: true,
                  ),
                ],
              ),
            ),
            // ปุ่มแสดงตำแหน่งหน้าปัจจุบันเป็นจุด
            SmoothPageIndicator(
              controller: _pageController,
              count: 3, // จำนวนหน้าทั้งหมด
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.amber,
                dotColor: Colors.white,
                spacing: 10,
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required IconData icon,
    required String title,
    required String description,
    bool isLastPage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.amber[700],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (isLastPage)
            ElevatedButton(
              onPressed: () {
                // เมื่อผู้ใช้ไปถึงหน้าสุดท้าย ให้ไปที่ LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700], 
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                    color: Colors.white), 
              ),
            )
        ],
      ),
    );
  }
}
