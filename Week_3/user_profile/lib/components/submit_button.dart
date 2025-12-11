import 'package:flutter/material.dart';

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
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Center(
        child: Text(isLoading? "Loading...": "Submit", style: TextStyle(color: Colors.white, fontSize: 20,),
      ),
    )
    ) 
    );
  }
}