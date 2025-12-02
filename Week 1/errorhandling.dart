List<String> tasks = ["Call Mom", "Buy Groceries", "Walk the Dog"];
void main() {
  try {
    print("Current Task: ${tasks[5]}");
  }
  catch (e) {
    print("Error: $e");
  }
  finally {
    print("Task list completed");
  }
}