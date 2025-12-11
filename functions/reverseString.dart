// Write a program in Dart to reverse a String using function.

import 'dart:io';

void reverseString(String str){
  for(var i = str.length -1; i>=0; i--){
    stdout.write(str[i]);
  }
}

void main(){
  print("Enter a string: ");
  String? str = stdin.readLineSync();
  reverseString(str!);

}