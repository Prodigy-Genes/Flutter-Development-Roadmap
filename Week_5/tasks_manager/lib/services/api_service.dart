import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tasks_manager/models/todo.dart';

class ApiService {
  Future<List<Todo>> fetchTodos() async{
    // Implementation for fetching data from an API
    final headers = {
      // This makes the server think the request is coming from a Chrome browser
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      'Accept': 'application/json', // Explicitly ask for JSON
    };
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=5');
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
}