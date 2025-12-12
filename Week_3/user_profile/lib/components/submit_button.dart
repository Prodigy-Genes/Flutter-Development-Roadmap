import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const SubmitButton({super.key, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
        
      },
      child: Container(
      padding: EdgeInsets.all(20),
      width: 150,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 88, 40),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Center(
        child: isLoading 
               ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 222, 59),
                ),
               )
               : Text("SUBMIT",
                 style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                 ),
                )
    )
    ) 
    );
  }
}