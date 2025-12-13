import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextformField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final VoidCallback? onTap;
  const CustomTextformField(
    {super.key, 
  required this.labelText, 
  required this.hintText, 
  required this.icon, 
  required this.obscureText, 
  required this.keyboardType, 
  required this.controller, 
  required this.validator, 
  this.onTap}
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration : InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.white),
        
        suffixIcon: keyboardType == TextInputType.visiblePassword 
        ? IconButton(
          onPressed: onTap,
          icon: Icon(obscureText 
          ? Icons.visibility 
          : Icons.visibility_off, color: Colors.white),
        ) 
        
        : null,
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
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}