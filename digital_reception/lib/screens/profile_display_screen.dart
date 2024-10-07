import 'dart:io';

import 'package:flutter/material.dart';

class ProfileDisplayScreen extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final File? imageFile;
  
  const ProfileDisplayScreen({this.name, this.email, this.phoneNumber, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitor\'s Details')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child:Center( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             CircleAvatar(
                                  radius: 50,
                                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                                  child: imageFile == null ? Icon(Icons.image, size: 50, color: Colors.white) : null,
                                ),
              const SizedBox(height: 20),
              Text('Name: ${name ?? "Not provided"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${email ?? "Not provided"}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Phone: ${phoneNumber ?? "Not provided"}', style: const TextStyle(fontSize: 16)),
              // Add other details if necessary
            ],
          ),
        )
      ),
    );
  }
}
