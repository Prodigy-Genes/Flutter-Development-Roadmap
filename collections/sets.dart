// Create a set of fruits and print all fruits using loop.

import 'dart:io';

Set<String> fruits = {"Apple", "Banana", "Orange", "Mango", "Pineapple"};

void main(){
  for(var fruit in fruits){
    stdout.write(fruit + ", ");
  
  }
}