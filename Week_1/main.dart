// Write a dart program that allows users to add, remove and show tasks 


// First declare a list to hold the list of tasks
List<String> obligations = ["Pay tax", "Water plants", "Clean the hall"];

// declare a function for adding tasks
void addTask(String newTask){
  // call in the global list variable and append the newTask parameter to it
  try{
    if(newTask == obligations){
      print("Task already exists. Add a new one");
    }
    else{
      obligations.add(newTask);
      print("Task $newTask has been added");
    }
  }catch(e){
    print(e);
  }
}

// declare a function to remove some tasks from the list
void removeTask(String taskremoved){
  // call in the list variable and remove a task using the defined parameter
  try{
    if(taskremoved != obligations){
      print("Task does not exist");
    }
    else{
      obligations.remove(taskremoved);
      print("Task $taskremoved has been removed");
    }
  }catch (e){
    print(e);
  }
}

// now a variable to show the list of tasks remaining
void showTask(){
  print("This is the list of obligations you have to complete today: $obligations");
}

// Now the main function to actually run the code
void main(){
  addTask('Sweeping the halls');

  removeTask('Eat an apple a day');

  showTask();
}