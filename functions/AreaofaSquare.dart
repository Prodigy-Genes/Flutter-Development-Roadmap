// Write a program in Dart that find the area of a circle using function. Formula: pi * r * r
import 'dart:io';

const pi = 3.142857142857143;

void area (int r){
  double area = pi * r * r;
  print(area.toInt());

}

void main(){
  print("Enter the radius of the circle: ");
  int? r = int.parse(stdin.readLineSync()!);
  area(r);

}