import 'package:tasks_manager/models/todo.dart';
// import riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_manager/services/api_service.dart';



typedef TodoState = List<Todo>;

final todoProvider = FutureProvider<TodoState>((ref) async {
  // 1. Get API Service
  final apiService = ApiService();
  // 2. Fetch Todos from API Service
  final todos = await apiService.fetchTodos();
  // 3. Return Todos
  return todos;


});