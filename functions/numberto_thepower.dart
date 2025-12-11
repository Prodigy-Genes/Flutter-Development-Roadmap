// Write a program in Dart to calculate power of a certain number. For e.g 5^3=125

import 'dart:io';
import 'dart:math';

void power(num x, num y){
  num result = pow(x, y);
  print(result);
}

void main(){
  print("Enter the base: ");
  num? x = .parse(stdin.readLineSync()!);
  print("Enter the power: ");
  num? y = .parse(stdin.readLineSync()!);
  power(x, y);
}