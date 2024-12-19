import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(DigitalReceptionApp());
}

class DigitalReceptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Reception',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
      // Define routes for navigation
    );
  }
}
