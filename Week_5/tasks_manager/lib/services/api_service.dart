import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tasks_manager/models/todo.dart';

class ApiService {
  Future<List<Todo>> fetchTodos() async{
    // Implementation for fetching data from an API
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response = await http.get(uri); // Making a GET request

    // print('Response Status: ${response.statusCode}');
    // print('Response Body: ${response.body}');
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList(); // using map to convert each JSON object to a Todo instance
    }
    else{
      throw Exception('Failed to load todos');
    }
  }
}