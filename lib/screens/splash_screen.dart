import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  delayScreen() async {
    var duration = const Duration(seconds: 5);
    Timer(
      duration,
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              width: 242,
            ),
            const SizedBox(height: 20),
            const Text(
              'Record Moments',
              style: TextStyle(
                fontSize: 36, // H1 size
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D4C7D),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              child: const Text(
                'Let This Notebook Let You Not Forget Every Important Momments.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4D4C7D),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4D4C7D), // Button color
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
