import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_manager/providers/todo_provider.dart';

class TodolistScreen extends ConsumerWidget {
  const TodolistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Provider
    final todoState = ref.watch(todoProvider);

    // Manage the UI    
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.task),
        title: Text("Task Management")
      ),

      body: todoState.when( 
        error: (err, stack) => Center(child: Text("OOPS! $err"),), 
        loading: ()=> Center(child: CircularProgressIndicator()),
        data: (todos) {
          return RefreshIndicator(
            onRefresh: () async{
              ref.refresh(todoProvider.future);
            },
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index){
                final todo = todos[index];
                return ListTile(
                  leading: todo.completed
                  ? Icon(Icons.check)
                  : Icon(Icons.circle),
            
                  trailing: IconButton(
                    onPressed: (){
                      // Delete functionality can be implemented here
                    },
                    icon: Icon(Icons.delete)
                  ),
            
                  title: Text(todo.title)
                );
              }
            ),
          );
        }
        ),
    );
  }
}