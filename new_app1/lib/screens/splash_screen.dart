import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_app1/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement( //pushReplacement-avoid navigation back to splash screen
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Navaratri Day 1')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash screen icon or logo
            Icon(
              Icons.accessibility_new, // You can replace this with your own logo
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Splash screen text
            const Text(
              'Welcome to Incrementor App',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
