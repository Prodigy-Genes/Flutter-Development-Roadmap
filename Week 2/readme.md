### 17. Classes & Objects
- **Class:** The blueprint defining structure and properties.
- **Object:** An instance created from the class.
- **Constructor:** Initializes the object.
    ```dart
    class Task {
      String title;
      Task(this.title); // Constructor
    }
    
    void main() {
      var myTask = Task('Learn OOP'); // Object creation
    }
    ```
### 18. Methods
- **Definition:** Functions that live inside a class.
- **Usage:** Used to modify the object's internal state or perform actions.
    ```dart
    codingTask.complete(); // Calls the method to change isCompleted to true
    ```
### 20. Inheritance
- **Definition:** Creating a new class (Subclass) based on an existing one (Superclass).
- **Keywords:** `extends` (to inherit), `super` (to call the parent constructor).
    ```dart
    class DeadlineTask extends Task {
      DateTime due;
      // Pass standard data to super, handle new data here
      DeadlineTask(String title, this.due) : super(title, ''); 
    }
    ```
  ### 22. Encapsulation (Getters)
- **Private Variables:** Start with `_` (underscore). Only visible in the current file.
- **Getters:** Public wrappers to read private variables safely.
    ```dart
    bool _status = false;
    bool get status => _status; // Use fat arrow '=>'
    ```
  ### 23. Abstraction (Abstract Classes)
- **Abstract Class:** A partial blueprint. Cannot be used to create objects directly.
- **Abstract Method:** A method with no body (`;`). Child classes MUST implement it.
    ```dart
    abstract class Item {
      void run(); // No body
    }
    ```