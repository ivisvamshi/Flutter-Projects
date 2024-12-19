import 'package:flutter/material.dart';
import 'dart:io'; // For File type
import 'welcome_screen.dart'; // Ensure this is correctly imported

class ProfileDisplayScreen extends StatelessWidget {
  final String userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final File? selfie;

  const ProfileDisplayScreen({
    required this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.selfie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor\'s Details')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              selfie != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(selfie!),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
              const SizedBox(height: 20),
              Text('ID: $userId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Name: ${name ?? "Not provided"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${email ?? "Not provided"}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Phone: ${phoneNumber ?? "Not provided"}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20), // Add spacing before the button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Back to Welcome Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
