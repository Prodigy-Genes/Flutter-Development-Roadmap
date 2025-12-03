class Task{
  Task(this.title, this.description, [this.isCompleted = false]);
  String title, description;
  bool isCompleted;

  void complete(){
    if (!isCompleted){
      isCompleted = true;
    }
  }
}

void main(){
  var codingTask = Task("Master OOP", "Practice classes in Dart");
  print(codingTask.title); // Output: Master OOP
  print(codingTask.description); // Output: Practice classes in Dart
  codingTask.isCompleted; // Output: false
  codingTask.complete();
  print(codingTask.isCompleted); // Output: true
   
}