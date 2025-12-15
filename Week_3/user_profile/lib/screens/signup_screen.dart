import 'package:flutter/material.dart';
import 'package:user_profile/components/FormFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_profile/components/google_button.dart';
import 'package:user_profile/screens/signin_screen.dart';

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
      // Set up a Scroll view to enable scrolling on the screen 
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
                  Text("WELCOME TO SPOTLIGHT", 
                  // Using google font here 
                  style: GoogleFonts.baloo2(color: const Color.fromARGB(255, 255, 222, 59), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("CREATE AN ACCOUNT",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, ),
                  )
                
                ]
              ),
            ),
            SizedBox(height: 20),
            Formfields(),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                style: GoogleFonts.poppins(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(width: 1),
                TextButton(onPressed: (){
                  debugPrint("Login pressed");
                  // Navigate to Login screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                }, 
                child: Text("Login",
                style: GoogleFonts.baloo2(
                  color: const Color.fromARGB(255, 255, 222, 59),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),))
              ],
            ),
            SizedBox(height: 10,),
            Divider(
              indent: 50,
              endIndent: 50,
              color: Colors.grey,

            ),
            SizedBox(height: 10,),
            GoogleButton(onPressed: () => debugPrint("Google button pressed"))
          ],
        )
      ),
      ) 
    );
  }
}