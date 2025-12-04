// Write an interactive dart program that allows users to add, remove and show tasks 
import 'dart:io';

// First declare a list to hold the list of tasks
List<String> tasks = ["Pay tax", "Water plants", "Clean the hall", "Buy groceries", "Walk the dog", "Go to the gym", "Go to church"];

class System {
  // show a welcome message to user
  void welcomeMessage(){
    print("----------------------------------------------------------------------------------------");
    print("Welcome to your task manager! Here is a list of your pending tasks: \n\n$tasks");
    print("----------------------------------------------------------------------------------------");
  }

  // Declare an optins function to show to user before and after each choice
  void options(){
    print("----------------------------------------------------------------------------------------------------");
    print("Choose an option from the list below: \n\n1. Add a task\n2. Remove a task\n3. Show tasks\n4. Exit");
    print("----------------------------------------------------------------------------------------------------");
  }

  // declare a function for adding tasks
  void addTask(String newTask){
    try{
      if (newTask.isEmpty){
        print("Task cannot be empty. Please enter a valid task");
      }
      else if(tasks.contains(newTask)){
        print("Task already exists. Add a new one");
      }
      else{
        tasks.add(newTask);
        print("Task $newTask has been added");
      }
    }catch(e){
      print(e);
    
    }
  }

  // declare a function for removing tasks
  void removeTask(String removeTask){
    try{
      if (removeTask.isEmpty){
        print("Task cannot be empty. Please enter a valid task");
      }
      else if(!tasks.contains(removeTask)){
        print("Task does not exist. Please enter a valid task");
      }
      else{
        tasks.remove(removeTask);
        print("Task $removeTask has been removed");
      }
    }catch(e){
      print(e);

    }
  }

  // declare a function for showing tasks
  void showTasks(){
    try{
      if (tasks.isEmpty){
        print("No tasks to show");
      }
      else{
        print("Your tasks are: \n\n$tasks");
      }
    }catch(e){
      print(e);
    }
  }

  // Declare a function for choosing from options list and validating selection
  void chooseOption(){
    options();
    String? choose = stdin.readLineSync();
    try{
      if(choose == '1'){
        print("Enter the task you want to add: ");
        String? newTask = stdin.readLineSync();
        addTask(newTask!);
      }else if(choose == '2'){
        print("Enter the task you want to remove: ");
        String? remove_Task = stdin.readLineSync();
        removeTask(remove_Task!);
      }else if(choose == '3'){
        showTasks();
      }else if(choose == '4'){
        print("Exiting the program...");
        exit(0);
      }else{
        print("Invalid option. Please try again.");
      }
    }catch(e){
      print(e);
    
    }
  }

}

void main(){
  var system = System();
  system.welcomeMessage();
  while(true){
    system.chooseOption();
    
  }
}