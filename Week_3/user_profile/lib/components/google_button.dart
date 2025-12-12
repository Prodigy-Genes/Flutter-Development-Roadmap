import 'package:flutter/material.dart';

class GoogleButton extends StatefulWidget {
  final VoidCallback onPressed;
  const GoogleButton({super.key, required this.onPressed});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(_isLoading) return; // Prevents multiple taps

        setState(() {
          _isLoading = true;
        });

        await Future.delayed(const Duration(seconds: 2)); // Simulate a 2 seconds network call
        if(mounted){
          setState(() {
            _isLoading = false;
          });
        }
        widget.onPressed();
      },

      child: Container(
        padding: EdgeInsets.all(4),
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 245, 128, 167),
            width: 4
          )
        ),
        child: Center(
          child: _isLoading
          ? const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 222, 59),
            ),
          )
          : Center(
            child: Image.network("https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png"),
          )
        ),
      ),

    );
  }
}