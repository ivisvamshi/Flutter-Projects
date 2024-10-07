import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'profile_display_screen.dart'; // Import the profile display screen
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormInputScreen extends StatefulWidget {
  @override
  _FormInputScreenState createState() => _FormInputScreenState();
}

class _FormInputScreenState extends State<FormInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNumber = '';
  File? _imageFile;
  // Add any other fields you need

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process the data or navigate to the next screen
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileDisplayScreen(
                name: name,
                email: email,
                phoneNumber: phoneNumber,
                // Pass other necessary data
              )));
    }
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
                      String patt = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
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
                      phoneNumber = value.countryCode + value.number;
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image = await _picker.pickImage(source: ImageSource.camera);
          setState(() {
            if (image != null) {
              _imageFile = File(image.path);
            }
            else{
              print('No image selected.');
            }
          });
          // Implement selfie capture functionality
        },
        tooltip: 'Take Selfie',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
