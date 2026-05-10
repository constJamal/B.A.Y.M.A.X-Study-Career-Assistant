import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // This starts the 2-second timer as soon as the app opens
    Timer(const Duration(seconds: 2), () {
      // After 2 seconds, move to the Sign In screen
      Navigator.pushReplacementNamed(context, '/login'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D1B2A), // Use your theme's dark blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your B.A.Y.M.A.X. Logo or Icon
            Icon(Icons.bolt, size: 80, color: Colors.cyanAccent),
            SizedBox(height: 20),
            Text(
              "B.A.Y.M.A.X.",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}