//Create an empty list of type string called days. Use the add method to add names of 7 days and print all days.
import 'dart:io';
List<String> days = [];

void addDays(String day){
  days.add(day);
}

void main(){
  
  int num=1;
  while(num<=7){
    print("Add days of the week to the empty list: ");
    String? days = stdin.readLineSync();
    addDays(days!);
    num++;
  }  
  
  print("Days of the week include: ");
  for(var i in days){
    print(i);
  }
}