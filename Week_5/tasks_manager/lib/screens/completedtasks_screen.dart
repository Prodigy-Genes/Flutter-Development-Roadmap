import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_manager/providers/todo_provider.dart';


class CompletedtasksScreen extends ConsumerWidget {
  
  const CompletedtasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedtodos = ref.watch(completedtasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      
    ),

    body: completedtodos.when(
      data: (completedtodos){
        return RefreshIndicator(
          onRefresh :() async{
            ref.refresh(todoProvider.future);
          },
          child: ListView.builder(
            itemCount: completedtodos.length,
            itemBuilder: (context, index){
              final completedtodo = completedtodos[index];
              return ListTile(
                leading: completedtodo.completed
                ? Icon(Icons.check)
                : Icon(Icons.circle),
                title: Text(completedtodo.title),
                trailing: IconButton(onPressed: (){
                  ref.read(todoProvider.notifier).deleteTodo(completedtodo.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Deleted: ${completedtodo.title}"),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      )
                  );
                }, icon: Icon(Icons.delete, color: Colors.red)),
              );
            }  
            ),
        );
      }, 
      error: (err, stack) => Center(child: Text("OOPS! $err"),), 
      loading: () => Center(child: CircularProgressIndicator())
      )
    );
      
       
  }
}