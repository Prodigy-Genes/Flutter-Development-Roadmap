// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_profile/components/submit_button.dart';
import 'package:user_profile/main.dart';

class Formfields extends StatefulWidget {
  const Formfields({super.key});

  @override
  State<Formfields> createState() => _FormfieldsState();
}

class _FormfieldsState extends State<Formfields> {
  bool _isHidden = true; // Set a bool variable here to hold the state of  the view password icon
  bool _isLoading = false; // Variable controls the state of the button
  bool _agreedtoterms = false;

  // Form key is defined here to validate the form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(); 
 
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
            TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              labelStyle: GoogleFonts.poppins(color: Colors.white),
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
              ),
              fillColor: Colors.black,
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)
              )
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty){
                return "Please enter your email";
              } else if( !value.contains('@') || !value.contains('.')  ){
                return "Please enter a valid email";
              }
              
              else{
                return null;
              }
            },
          ),
          SizedBox(height: 20),

          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              labelStyle: GoogleFonts.poppins(color: Colors.white),
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  _isHidden = !_isHidden;
                });
              }, icon: Icon(_isHidden? Icons.visibility: Icons.visibility_off, color: Colors.grey)),

              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)
              ),
              fillColor: Colors.black,
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red
                ),
                borderRadius: BorderRadius.circular(10)
              )
            ),
            obscureText: _isHidden,
            keyboardType: TextInputType.visiblePassword,
            validator: (value){
              if(value == null || value.isEmpty){
                return "Please enter your password";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height: 20,),

          TextFormField(
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Confirm your password",
              labelStyle: GoogleFonts.poppins(color: Colors.white),
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  _isHidden =! _isHidden;
                });
              }, icon: Icon(_isHidden? Icons.visibility: Icons.visibility_off, color: Colors.grey)),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none
              ),
              fillColor: Colors.black,
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red)
              )
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _isHidden,
            validator: (value){
              if(value == null || value.isEmpty){
                return "Please confirm your password";
              }else if( value != _passwordController.text ){
                return "Passwords do not match";
              }
              else{
                return null;
              }
            },
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Checkbox(value: _agreedtoterms, onChanged: (bool? newvalue){
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
        if(_formKey.currentState!.validate()){
          debugPrint("Form is valid");
          await Future.delayed(const Duration(seconds: 2));
          if(mounted){
            setState(() {
              _isLoading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
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