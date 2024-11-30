import 'package:flutter/material.dart';
import 'dart:async';

import 'package:test_map/screens/contatcs_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    // Replace with your navigation logic
    Timer(
      const Duration(seconds: 3),
      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactListScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E57C2), // Deep Purple Shade
              Color(0xFF673AB7), // Slightly Darker Purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image in the center
              Image.asset(
                'assets/logo.png', // Replace with your image path
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'My best locations ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
