import 'dart:io';

// A program to print even numbers between intervals 
void evenNumbers(int start, int end){
  print("Even numbers between $start and $end:");
  for(int i = start; i<=end; i++){
    if(i%2==0){
      stdout.write("$i, ");
    }
  }
  print('\n');
}


void userInput(){
  print("In order to set an interval, please enter the start number and the end number\n");
  print("Enter the start number:");
  int start = int.parse(stdin.readLineSync()!);
  print("Enter the end number: ");
  int end = int.parse(stdin.readLineSync()!);
  evenNumbers(start, end);

}

void options (){
  print(
    "1. Set an interval\n"
    "2. Exit\n"
  );
  String? choice = stdin.readLineSync();
  if(choice == "1"){
    print("-------------------------------------------------");
    userInput();
    print("-------------------------------------------------");
  }
  else if(choice == "2"){
    print("-------------------------------------------------");
    print("Thank you for using our program");
    print("-------------------------------------------------");
    exit(0);
  }
  else{
    print("-------------------------------------------------");
    print("Invalid choice, please try again");
    print("-------------------------------------------------");
    options();
  }
  print("-------------------------------------------------");
}

void main(){
  while(true){
    options();
  }
}