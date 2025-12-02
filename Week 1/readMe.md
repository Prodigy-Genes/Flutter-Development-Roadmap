# Dart & Flutter Training Notes

## Week 1: Introduction to Dart Programming

### 1. Dart Basics
- **Entry Point:** Every Dart program starts execution inside the `main` function[cite: 13, 16].
    ```dart
    void main() {
      // Code execution starts here
    }
    ```
- **Printing to Console:** Use `print()` to display output to the debug console[cite: 16].
    ```dart
    print('Task Manager Starting...');
    ```

### 2. Variables
- **Declaration:** Use `var` to let Dart infer the type, or specify the type explicitly (e.g., `String`).
- **Syntax:** Always end statements with a semicolon `;`.
    ```dart
    var task = 'Buy Milk'; // Dart infers this is a String
    String explicitTask = 'Walk Dog'; // Explicitly typed
    ```

### 3. Lists (Arrays)
- **Declaration:** Use brackets `[]` to create a list.
- **Type:** Use `List<Type>` to define what kind of data is inside.
    ```dart
    List<String> tasks = ['Buy Milk', 'Walk Dog']; 
    ```
- **Accessing Elements:** Use square brackets `[]` with an index (starting at 0).
    ```dart
    print(tasks[0]); // Prints the first item
    ```
### 4. Sets
- **Definition:** An unordered collection of unique items.
- **Syntax:** Use curly braces `{}`.
- **Type:** `Set<Type>`
    ```dart
    Set<String> tags = {'urgent', 'work'};
    ```
    tags.add('personal'); // Adds a new unique item
    tags.remove('work'); // Removes an item

### 5. Maps (Dictionaries)
- **Definition:** A collection of Key-Value pairs.
- **Syntax:** `Map<KeyType, ValueType> variableName = { key: value };`
    ```dart
    Map<String, String> taskDetails = {'Buy Milk': 'High'};
    ```
- **Accessing Values:** Use the key inside square brackets `[]`.
    ```dart
    print(taskDetails['Buy Milk']); // Prints 'High'

### 6. Records (Tuples)
- **Definition:** A fixed-sized collection of objects of different types.
- **Syntax:** Use parentheses `()`.
- **Access:** Use `$1`, `$2`, etc.
    ```dart
    var login = ('admin', 1234); 
    ```    
### 7. Control Structures (Loops)
- **For-in Loop:** Iterates over a collection.
    ```dart
    for (var task in tasks) {
      print(task);
    }
    ```
### 8. Control Flow (If/Else)
- **Conditional Logic:** execute code based on a condition.
    ```dart
    if (tasks.isEmpty) {
      print('No tasks yet');
    } else {
      print('You have tasks');
    }
    ```
### 9. While Loops
- **Stopping:** You can stop a loop by changing the condition variable or using `break`.
    ```dart
    // Method 1: Changing the variable (State)
    while (isRunning) {
      print('Running...');
      isRunning = false; 
    }

    // Method 2: Forcing a break
    while (true) {
      print('Running...');
      break; 
    }
    ```
### 10. Functions
- **Syntax:** `ReturnType functionName(ParameterType parameterName) { ... }`
    ```dart
    void addTask(String newTask) {
      // Code to run
    }
    ```
### 11. List Methods
- **Adding Items:** Use `.add()` to append an item to the end of a list.
    ```dart
    tasks.add('New Task');
    ```
### 12. Calling Functions
- **Execution:** Functions do not run until they are called in `main` (or by another function).
    ```dart
    void main() {
      addTask('Call Mom'); // Runs the code inside addTask
    }
    ```
### 13. Removing Items
- **Removing by Value:** Use `.remove()` to find and delete an item.
    ```dart
    tasks.remove('read');
    ```
- **Removing by Index:** Use `.removeAt()` to delete an item at a specific index.
    ```dart
    tasks.removeAt(0); // Removes the first item

### 15. Error Handling
- **Try-Catch:** Prevents crashes when risky code fails.
- **Finally:** (Optional) Code that runs no matter what happens (success or error).
    ```dart
    try {
      print(tasks[10]); 
    } catch (e) {
      print('Error: $e'); 
    } finally {
      print('Done'); // Always runs
    }
    ```
    


---