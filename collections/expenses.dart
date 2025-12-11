// Create a program thats reads list of expenses amount using user input and print total.
import 'dart:io';

Map<String, double> expenses = {};

void addExpenses(String name, double amount){
  //  Store the name and amount in the expenses map
  expenses[name] = amount;

}

void calculate(){
  // Calculate the total expenses
  double total = 0;
  for(var amount in expenses.values){
    total += amount;
  }
  print("Total expenses: $total");

}

void main(){
  // User types in the name and amount
  int number = 0;
  while(number <5){
    print("Enter the name of the expense: ");
    String? name = stdin.readLineSync();
    print("Enter the amount of the expense: ");
    double? amount = double.parse(stdin.readLineSync()!);
    addExpenses(name!, amount);
    number++;
  }
  calculate();

}