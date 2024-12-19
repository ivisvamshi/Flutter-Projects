import 'package:digital_reception1/screens/profile_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For capturing selfie
import 'dart:io'; // For File type
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';

class FormInputScreen extends StatefulWidget {
  @override
  _FormInputScreenState createState() => _FormInputScreenState();
}

class _FormInputScreenState extends State<FormInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String name = '';
  String email = '';
  String phoneNumber = '';
  File? selfie; // To store the captured selfie


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String userId = DateTime.now().millisecondsSinceEpoch.toString();

      // Save the captured selfie if available
      String imagePath = '';
      if (selfie != null) {
        imagePath = await _saveImage(selfie!);
      }

      // Create a map to hold user details
      final userData = {
        'id': userId,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'imagePath': imagePath, // Store the image path
      };

      // Convert user data to JSON string
      final jsonData = jsonEncode(userData);

      // Save user data to a JSON file
      await _appendUserData(jsonData);

      // Navigate to the next screen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProfileDisplayScreen(
          userId: userId,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          selfie: selfie, // Pass the captured selfie
          // Pass other necessary data
        ),
      ));
    }
  }

  Future<String> _saveImage(File image) async {
    try {
      final directory = await getExternalStorageDirectory();
      final imageDirectory = Directory('${directory!.path}/images');
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newImage = await image.copy('${imageDirectory.path}/$fileName');
      print('Image saved at: ${newImage.path}');
      return newImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return ''; // Return empty string on error
    }
  }

  Future<String> _appendUserData(String jsonData) async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/user_data.json');
      if (await file.exists()) {
        final existingData = await file.readAsString();
        final List<dynamic> existingList = jsonDecode(existingData);
        existingList.add(jsonDecode(jsonData));
        await file.writeAsString(jsonEncode(existingList));
      } else {
        await file.writeAsString('[$jsonData]');
      }
      return file.path;
    } catch (e) {
      print('Error appending user data: $e');
      return ''; // Return empty string on error
    }
  }

  Future<void> _captureSelfie() async {
    var cameraStatus = await Permission.camera.status;

  // If permission is not granted, request it
  if (!cameraStatus.isGranted) {
    // This will trigger the system permission dialog again
    cameraStatus = await Permission.camera.request();

    // Check the status after requesting
    if (!cameraStatus.isGranted) {
      // If still not granted, provide more guidance
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Camera Permission Required'),
          content: Text('This app needs camera access to take selfies. Please go to app settings and grant camera permission.'),
          actions: <Widget>[
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }
  }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Capture with Camera'),
                  onTap: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        selfie = File(image.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Upload from Gallery'),
                  onTap: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        selfie = File(image.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
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
      appBar: AppBar(title: const Text('Fill your details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    else{
                      String patt = r'^[a-zA-Z ]+$';
                      RegExp regExp = new RegExp(patt);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid name';
                      }
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) => email = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    else{
                      String patt = r'^[\w-\.]+@([a-zA-Z]+\.)+[a-zA-Z]{2,4}$';
                      RegExp regExp = new RegExp(patt);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                ),
                IntlPhoneField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  onSaved: (value) {
                    if(value !=null){
                      phoneNumber = value.countryCode + " " + value.number;
                    }
                  },
                  validator: (value) {
                    if (value!=null) {
                      if (value.number.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      else{
                        String patt = r'^[0-9]{10}$';
                        RegExp regExp = new RegExp(patt);
                        if (!regExp.hasMatch(value.number)) {
                          return 'Please enter a valid phone number';
                        }
                      }
                    }
                    return null;
                  },
                ),
                // Add other fields as necessary

                const SizedBox(height: 20), // Adds a little spacing

                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: _submitForm,
                ),
                selfie != null
                    ? Image.file(selfie!)
                    : Container(), // Display the captured selfie
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureSelfie,
        tooltip: 'Take Selfie or Upload',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
