### 1. Classes & Objects
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
### 2. Methods
- **Definition:** Functions that live inside a class.
- **Usage:** Used to modify the object's internal state or perform actions.
    ```dart
    codingTask.complete(); // Calls the method to change isCompleted to true
    ```
### 3. Inheritance
- **Definition:** Creating a new class (Subclass) based on an existing one (Superclass).
- **Keywords:** `extends` (to inherit), `super` (to call the parent constructor).
    ```dart
    class DeadlineTask extends Task {
      DateTime due;
      // Pass standard data to super, handle new data here
      DeadlineTask(String title, this.due) : super(title, ''); 
    }
    ```
  ### 4. Encapsulation (Getters)
- **Private Variables:** Start with `_` (underscore). Only visible in the current file.
- **Getters:** Public wrappers to read private variables safely.
    ```dart
    bool _status = false;
    bool get status => _status; // Use fat arrow '=>'
    ```
  ### 5. Abstraction (Abstract Classes)
- **Abstract Class:** A partial blueprint. Cannot be used to create objects directly.
- **Abstract Method:** A method with no body (`;`). Child classes MUST implement it.
    ```dart
    abstract class Item {
      void run(); // No body
    }
    ```
  ### 6. Polymorphism
- **Definition:** Treating different objects (Book, Magazine) as instances of their common parent (LibraryItem).
- **Benefit:** Allows you to write one loop that handles many different types of objects.

  ### 7. Mixins
- **Definition:** A way to reuse code across multiple classes hierarchies.
- **Keyword:** `mixin` (to define), `with` (to use).
- **Difference:** Inheritance (`extends`) is for what an object IS. Mixins (`with`) are for what an object DOES.
    ```dart
    mixin Flyable {
      void fly() => print('Flying');
    }
    
    class Bird extends Animal with Flyable {}
    ```

    ```dart
    void main() {
      List<LibraryItem> items = [Book(), Magazine()]; // Polymorphism
      for (var item in items) {
        item.checkOut(); // Calls the correct method for each type
      }
    }
  ### 26. Interfaces
- **Concept:** A contract that forces a class to implement specific methods.
- **Dart Feature:** Dart has no `interface` keyword. Every class is an interface.
- **Usage:** Use `implements` (instead of `extends`) to enforce the rules without inheriting the behavior.
    ```dart
    class CloudStorage implements Storage {
      @override
      void save() { ... } // Must write code from scratch
    }
    ```
