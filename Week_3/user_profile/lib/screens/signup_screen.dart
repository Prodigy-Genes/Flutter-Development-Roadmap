import 'package:flutter/material.dart';
import 'package:user_profile/components/FormFields.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            SizedBox(
              height: 100,
              width: 250,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("WELCOME", 
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("SIGN UP",
                  style: TextStyle(color: Colors.grey, fontSize: 20, ),
                  )
                
                ]
              ),
            ),
            SizedBox(height: 100),
            Formfields(),
            
          ],
        )
      ),
      ) 
    );
  }
}