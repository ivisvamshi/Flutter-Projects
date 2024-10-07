import 'package:flutter/material.dart';
import 'form_input_screen.dart'; // Import the form input screen

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child:Padding(
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
            ],
          ),
        ),
      )
    );
  }
}
