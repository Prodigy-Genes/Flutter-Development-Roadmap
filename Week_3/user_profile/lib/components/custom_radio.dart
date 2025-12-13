import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadio extends StatelessWidget {
  final String text;
  final String value;
  final String groupValue;
  final ValueChanged<String> onTap;
 
  const CustomRadio({super.key, required this.text, required this.value, required this.groupValue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(value),  
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: value == groupValue ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            
            color: value == groupValue ? const Color.fromARGB(255, 28, 88, 40) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}