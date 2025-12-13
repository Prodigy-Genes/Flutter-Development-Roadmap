// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:user_profile/components/submit_button.dart';
import 'package:user_profile/components/textform_field.dart';
import 'package:user_profile/screens/userprofile_screen.dart';

class SigninFormfields extends StatefulWidget {
  const SigninFormfields({super.key});

  @override
  State<SigninFormfields> createState() => _SigninFormfieldsState();
}

class _SigninFormfieldsState extends State<SigninFormfields> {
  bool _isHidden = true; // Set a bool variable here to hold the state of  the view password icon
  bool _isLoading = false; // Variable controls the state of the button

  // Form key is defined here to validate the form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();


 
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 28, 88, 40),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        
        child: Form(
          key: _formKey, 
          child: Column(
          children: [
          
           //Email field
           CustomTextformField(
            controller: _emailController,
           labelText: "Email",
           hintText: "Enter your email",
           icon: Icons.email,
           obscureText: false,
           keyboardType: TextInputType.emailAddress,
           validator: (value){
            if(value == null || value.isEmpty){
              return "Please enter your email";
            }
            // Email validation using regex 
            else if( RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,10}$').hasMatch(value) == false){
              return "Please enter a valid email";
            }
            
            else{
              return null;
            }
           },
           ),
          SizedBox(height: 10),

          //Password field
          CustomTextformField(
           controller: _passwordController,
           labelText: "Password",
           hintText: "Enter your password",
           icon: Icons.lock,
           obscureText: _isHidden,
           keyboardType: TextInputType.visiblePassword,
           validator: (value){
            if(value == null || value.isEmpty){
              return "Please enter your password";
            }
            else if(value.length < 4){
              return "Password must be at least 4 characters";
            }
            else{
              return null;
            }
           },
           onTap: (){
            setState(() {
              _isHidden = !_isHidden;
            });
           },
           ),

          ],
        )
          
      ),),
      SizedBox(height: 30,),
      SubmitButton(
        isLoading : _isLoading,
        onPressed: () async{ // used the async here to simulate a 2 seconds wait on press
        FocusScope.of(context).unfocus(); // Removes the keyboard on press

        setState(() {
          _isLoading = true;
        });

        debugPrint("Submit pressed");
        if(_formKey.currentState!.validate()){
          debugPrint("Form is valid");
          await Future.delayed(const Duration(seconds: 2));
          if(mounted){
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserprofileScreen(
              username: _usernameController.text.isEmpty
              ? "Undefined"
              : _usernameController.text,
              email: _emailController.text,
              )));
          }
        }else{
          debugPrint("Form is invalid");
          setState(() {
            _isLoading = false;
          });
        }
      },
      
      )
      
      ]


    );
  }
}