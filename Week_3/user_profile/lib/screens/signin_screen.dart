import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_profile/components/google_button.dart';
import 'package:user_profile/components/signin_formfields.dart';
import 'package:user_profile/screens/signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
              width: 250,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/applogo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("WELCOME BACK TO SPOTLIGHT", 
                  style: GoogleFonts.baloo2(color: const Color.fromARGB(255, 255, 222, 59), fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("SIGN INTO YOUR ACCOUNT",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, ),
                  )
                
                ]
              ),
            ),
            SizedBox(height: 20),
            SigninFormfields(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",
                style: GoogleFonts.poppins(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(width: 1),
                TextButton(onPressed: (){
                  debugPrint("Register pressed");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                }, 
                child: Text("Register",
                style: GoogleFonts.baloo2(
                  color: const Color.fromARGB(255, 255, 222, 59),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),))
              ],
            ),
            SizedBox(height: 5,),
            Divider(
              indent: 50,
              endIndent: 50,
              color: Colors.grey,

            ),
            SizedBox(height: 20,),
            GoogleButton(onPressed: () => debugPrint("Google button pressed"))
          ],
        )
      ),
      ),

    );
  }
}