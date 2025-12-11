// Write a function in Dart called createUser with parameters name, age, and isActive, where isActive has a default value of true.
import 'dart:io';

void createUser(String name, int age, bool isActive){
  isActive = true;
}

void main(){
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();
  stdout.write("Enter your age: ");
  int? age = int.parse(stdin.readLineSync()!);
  createUser(name!, age, true);
  print("Your account is active");

}