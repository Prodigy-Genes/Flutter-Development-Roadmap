// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_profile/components/custom_radio.dart';
import 'package:user_profile/components/submit_button.dart';
import 'package:user_profile/components/textform_field.dart';
import 'package:user_profile/screens/userprofile_screen.dart';

class Formfields extends StatefulWidget {
  
  const Formfields({super.key});

  @override
  State<Formfields> createState() => _FormfieldsState();
}

class _FormfieldsState extends State<Formfields> {
  bool _isHidden = true; // Set a bool variable here to hold the state of  the view password icon
  bool _isHiddenC = true; // using another password variable to control each view icon individually
  bool _isLoading = false; // Variable controls the state of the button
  // Set a variable for the checkbox widget 
  bool _agreedtoterms = false;

  // A variable to control the radio widget
  String _gender = "M";

  // Form key is defined here to validate the form
  final _formKey = GlobalKey<FormState>();
   // Passed a password controller here as to hold the password a user types in a means to compare it against the confirm password field
  final TextEditingController _passwordController = TextEditingController();

  // An email and username controller to hold user details which will later be passed theough screens upon successful form validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  final TextEditingController _confirmPasswordController = TextEditingController();

 
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
            // Username field
          CustomTextformField(controller: _usernameController,
           labelText: "Username",
           hintText: "Enter your username",
           icon: Icons.person,
           obscureText: false,
           keyboardType: TextInputType.text,
           validator: (value){
            if(value == null || value.isEmpty){
              return "Please enter your username";
            }else{
              return null;
            }
           },
           ),
           SizedBox(height: 10,),

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
            // Email validation using regex, 
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
          SizedBox(height: 10,),

          //Confirm password field
          CustomTextformField(controller: _confirmPasswordController,
           labelText: "Confirm Password",
           hintText: "Confirm your password",
           icon: Icons.lock,
           obscureText: _isHiddenC,
           keyboardType: TextInputType.visiblePassword,
           validator: (value){
            if(value == null || value.isEmpty){
              return "Please confirm your password";
            }
            else if(value != _passwordController.text){
              return "Passwords do not match";
            }
            else{
              return null;
            }
           },
           onTap: (){
            setState(() {
              _isHiddenC = !_isHiddenC;
            });
           },
           ),
           SizedBox(height: 20,),

           //Gender field using a flutter widget 
           Row(
            children: [
              CustomRadio(
                label: "M", 
                selected: _gender == "M",
                onSelected: (bool selected){
                  setState(() {
                    _gender = "M";
                  });
                },
                ),
              SizedBox(width: 10,),
              CustomRadio(
                label: "F", 
                selected: _gender == "F",
                onSelected: (bool selected){
                  setState(() {
                    _gender = "F";
                  });
                },                
                ),
            ]
           ),
          SizedBox(height: 5,),
          Row(
            children: [
              Checkbox(
                value: _agreedtoterms, 
                onChanged: (bool? newvalue){
                setState(() {
                  _agreedtoterms = newvalue!;
                });
              },
              activeColor: const Color.fromARGB(255, 255, 222, 59),
              checkColor: Colors.black,
              ),
              
              Text("I agree to the terms and conditions",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              )
            ]
          )

          ],
        )
          
      ),),
      SizedBox(height: 30,),
      SubmitButton(
        isLoading : _isLoading,
        onPressed: () async{ // used the async here to simulate a 2 seconds wait on press
        FocusScope.of(context).unfocus(); // Removes the keyboard on press

        // Checks if agreed to terms is checked before loading begins
        if(!_agreedtoterms){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please agree to the terms and conditions",
            style: GoogleFonts.poppins(color: Colors.white),),
            backgroundColor: Colors.red,
            
            )
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });

        debugPrint("Submit pressed");
        // Check the current state of the form using the already defined formkey to validate it
        if(_formKey.currentState!.validate()){
          debugPrint("Form is valid");
          // Await a 2 seconds simulated delay
          await Future.delayed(const Duration(seconds: 2));
          // If screen is still around, set loading state to false 
          if(mounted){
            setState(() {
              _isLoading = false;
            });
            // Push replacement replaces the current screen with the next screen. 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserprofileScreen(
              // Passed user credentials to the next screen
              username: _usernameController.text,
              email: _emailController.text,
              gender: _gender,
              )));
          }

          
        }else{
          debugPrint("Form is invalid");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please check your entered details carefully",
            style: GoogleFonts.poppins(color: Colors.white),),
            backgroundColor: Colors.red,
            
            )
          );
          return
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