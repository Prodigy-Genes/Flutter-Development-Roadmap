class Task {
  String title, description;
  bool isCompleted;
  Task(this.title, this.description, [this.isCompleted = false]);

}

class DeadlineTask extends Task {
  DateTime deadline;
  DeadlineTask(String title, String description, this.deadline): super(title, description);
}

void main(){
  
  var project = DeadlineTask("App Release", "Push to Appstore", DateTime.now());
  print(project.title);
  print(project.description);
  print(project.deadline);
  print(project.isCompleted);

}