import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ExistingUsersScreen extends StatefulWidget {
  @override
  _ExistingUsersScreenState createState() => _ExistingUsersScreenState();
}

class _ExistingUsersScreenState extends State<ExistingUsersScreen> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/user_data.json');
      if (await file.exists()) {
        final data = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(data);
        setState(() {
          users = jsonData.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Existing Users')),
      body: users.isEmpty
          ? const Center(child: Text('No users found'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: user['imagePath'] != ''
                        ? Image.file(File(user['imagePath']))
                        : const Icon(Icons.person),
                    title: Text(user['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Email: ${user['email']}'),
                        Text('Phone: ${user['phoneNumber']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
