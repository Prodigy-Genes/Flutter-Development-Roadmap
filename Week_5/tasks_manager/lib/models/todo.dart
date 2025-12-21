class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // Declaring the factory constructor to create a Todo instance from a JSON map 
  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // We need a new instance of the object with the updated model using copyWith
  // Allows us to change one property while keeping others the same
  Todo copyWith({bool? completed}){
    return Todo(
      userId: userId, 
      id: id, 
      title: title, 
      completed: completed ?? this.completed
      );
  }
}

  
