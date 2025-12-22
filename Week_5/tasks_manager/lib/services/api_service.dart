import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tasks_manager/models/todo.dart';

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com/todos";
  // Making a GET request to the API
  Future<List<Todo>> fetchTodos() async{
    // Implementation for fetching data from an API
    final headers = {
      // This makes the server think the request is coming from a Chrome browser
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      'Accept': 'application/json', // Explicitly ask for JSON
    };
    final uri = Uri.parse("$baseUrl?_limit=5");
    final response = await http.get(uri, headers: headers); // Making a GET request

    //print('Response Status: ${response.statusCode}');
    //print('Response Body: ${response.body}');
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList(); // using map to convert each JSON object to a Todo instance
    }
    else{
      throw Exception('Failed to load todos');
    }
  }

  // Making a POST request to the API
  Future<Todo> addTodos(Todo todo) async{
    // Implementation for adding data to an API
    final uri = Uri.parse("$baseUrl/${todo.userId}");
    final response = await http.post(
      uri,
      body: jsonEncode({
        "title": todo.title,
        "completed": todo.completed,
        "userId": todo.userId,
        "id": todo.id,
        
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    
      );
      if(response.statusCode == 201){
        return Todo.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception("Failed to add task to server");
      }
  }

  // Making a PATCH Request to the API
  Future<void> updateTodo(int id, bool completed) async{
    await http.patch(
      Uri.parse("$baseUrl/$id"),
      body: jsonEncode({
        "completed": completed,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

  }

  // Making a DELETE Request to the API
  Future<void> deleteTodo(int id) async{
    final response = await http.delete(
      Uri.parse('$baseUrl/$id')
    );
    if(response.statusCode !=200){
      throw Exception("Failed to delete Task on server");
    }
  }
  

}