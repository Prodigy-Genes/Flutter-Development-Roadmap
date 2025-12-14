import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadio extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const CustomRadio({super.key, required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      labelStyle: GoogleFonts.poppins(
        color: selected ? Colors.white : Colors.black,
        fontSize: 16
      ), 
      selected: selected,
      onSelected: onSelected,
      selectedColor: const Color.fromARGB(255, 18, 67, 29),
      backgroundColor: label == "M"
          ? const Color.fromARGB(255, 255, 185, 72)
          : const Color.fromARGB(255, 255, 158, 210),
      

      );
  }
}