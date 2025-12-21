import 'package:tasks_manager/models/todo.dart';
// import riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_manager/services/api_service.dart';



typedef TodoState = List<Todo>;
/*  
final todoProvider = FutureProvider<TodoState>((ref) async {
  // 1. Get API Service
  final apiService = ApiService();
  // 2. Fetch Todos from API Service
  final todos = await apiService.fetchTodos();
  // 3. Return Todos
  return todos;
});
*/
// This is merely for reading access only from the API.

// Now we are going to try interacting with the tasks so we will need a class extending to an AsyncNotifier, since FutureProvider
// only gives us read access.

class TodoNotifier extends AsyncNotifier<TodoState>{
  @override
  // using the build method to initialize the data
  Future<TodoState> build() async{
    // 1. Get API Service
    final apiService = ApiService();
    // 2. fetch the todos
    final todos = await apiService.fetchTodos();
    // 3. return the todos
    return todos;
  } 
  
  // 2. Add methods to modify the data
  void deleteTodo(int todoId){
    // We check if current state is not loading yet, we do nothing
    final currentState = state;
    if(!currentState.hasValue) return;

    // We use the oldList
    final oldList = currentState.value!;

    // We then create a new list without the deleted item
    final newList = oldList.where((todo)=> todo.id != todoId).toList();

    // We update the state which triggers the UI to rebuild
    state =AsyncData(newList);
  }

  void markasComplete(int todoId){
    final currentState = state;
    // We use the oldList
    final oldList = currentState.value!;
    
    // We then create a new list without the completed iem
    final newList = oldList.map((todo){
    if(todo.id == todoId){
      return todo.copyWith(completed: !todo.completed);
    }
    else{
      return todo;
    }
  }).toList();

  // We then update the state which triggers the UI to rebuild
  state = AsyncData(newList);
  }
}
// Make the provider accessible to the UI
final todoProvider = AsyncNotifierProvider<TodoNotifier, TodoState>((){
  return TodoNotifier();
});

// Make a completed tasks provider for the completed tasks screen
final completedtasksProvider = Provider<AsyncValue<TodoState>>((ref){
  final completedtodos = ref.watch(todoProvider);

  // We use the .when to transform the data only if completed is true
  return completedtodos.whenData((todos){
    return todos.where((todo) => todo.completed).toList();
  });
}); 

// Make an incomplete tasks provider for tasks screen
final incompletetasksProvider = Provider<AsyncValue<TodoState>>((ref){
  final incompletetodos = ref.watch(todoProvider);

  return incompletetodos.whenData((todos){
    return todos.where((todo) => !todo.completed).toList();
  });
});