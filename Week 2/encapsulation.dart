// Encapsulation protects the internal state of an object from unintended interference and misuse.

class Task {
  String Title, Description;
  bool _isCompleted; // Private variable
  Task(this.Title, this.Description, [this._isCompleted = false]); // Constructor

  // Getter function
  bool get isCompleted => _isCompleted;

  void complete (){
  if(_isCompleted == false){
    _isCompleted = true;
  }
}
}



void main (){
  var project = Task("My App", "This is a mobile app");
  print(project.isCompleted); // Accessing via getter function
  project.complete();
  print(project.isCompleted);

  
}