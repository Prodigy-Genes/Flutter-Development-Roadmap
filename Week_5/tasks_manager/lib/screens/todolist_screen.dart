import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_manager/providers/todo_provider.dart';
import 'package:tasks_manager/screens/completedtasks_screen.dart';

class TodolistScreen extends ConsumerWidget {
  const TodolistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Provider
    final todoState = ref.watch(incompletetasksProvider);

    // Manage the UI    
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.task),
        title: Text("Task Management"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedtasksScreen()));
          }, icon: Icon(Icons.check))
        ],
      ),

      body: todoState.when( 
        error: (err, stack) => Center(child: Text("OOPS! $err"),), 
        loading: ()=> Center(child: CircularProgressIndicator()),
        data: (todos) {
          return RefreshIndicator(
            onRefresh: () async{
              ref.invalidate(todoProvider);
              ref.refresh(todoProvider.future);
            },
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index){
                final todo = todos[index];
                return ListTile(
                  // Leading icon to mark task as completed
                  leading: IconButton(onPressed: (){
                    ref.read(todoProvider.notifier).markasComplete(todo.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Successfully marked ${todo.title} as completed"),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green
                      ),
                      
                      );
                  }, 
                  icon: Icon(Icons.circle, size: 12, color: todo.completed? Colors.green : Colors.grey)
                  ),
                  trailing: IconButton(
                    onPressed: (){
                      // Delete functionality can be implemented here
                      ref.read(todoProvider.notifier).deleteTodo(todo.id);

                      // Show Snack
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted: ${todo.title}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating, 
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red)
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