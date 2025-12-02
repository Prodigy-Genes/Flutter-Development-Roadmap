// Write a dart program that allows users to add, remove and show tasks 

List<String> tasks = ["Call Mom", "Buy Groceries", "Walk the Dog"];

void addTask (String newTask){
  try{
    tasks.add(newTask);
    }catch(e){
      print("Could not add task");
    }
}

void removeTask (String tasktoremove) {
  try{
    tasks.remove(tasktoremove);
  }catch(e){
    print("Task not found");
  }
}

void showTasks() {
  
  for(var task in tasks){
    print('Remaining tasks are: $task');
  }
}

void main() {
  addTask("Go to the gym");
  removeTask("Buy Groceries");
  showTasks();
}
