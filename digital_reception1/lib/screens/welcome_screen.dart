import 'package:digital_reception1/screens/ExistingUsersScreen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'form_input_screen.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<Permission> _requiredPermissions = [
    Permission.camera,
    Permission.storage,
  ];
  
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

    Future<void> _checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await _requiredPermissions.request();
    
    bool allGranted = statuses.values.every((status) => status.isGranted);
    
    if (allGranted) {
      // Navigate to Welcome Screen if all permissions are granted
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen())
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Welcome to our Digital Reception', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              ElevatedButton(
                child: const Text('Get Started', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormInputScreen()));
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('View Existing Users', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExistingUsersScreen()));
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
