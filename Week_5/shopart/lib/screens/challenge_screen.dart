import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopart/increment_provider.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<IncrementProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter Challenge"),
        actions: [
          IconButton(
            onPressed: () => context.read<IncrementProvider>().reset(), 
            icon: Icon(Icons.refresh))
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 350,),
          Center(
            child: Text(
              "Counter Value: ${counter.counter}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.read<IncrementProvider>().increment(), 
                child: Text("Increase")
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () => context.read<IncrementProvider>().decrement(), 
                child: Text("Decrease"))
            ],
          )
        ],
      ),
    );
  }
}