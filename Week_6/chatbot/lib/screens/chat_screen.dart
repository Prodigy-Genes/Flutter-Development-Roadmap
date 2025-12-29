import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/huggingface_chat_provider.dart';


class ChatScreen extends ConsumerWidget {
  ChatScreen({super.key});

  // Controller here will hold the message the user send on the app
  final messagecontroller = TextEditingController();

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Call in the ChatNotifier Provider for Gemini
    final messages = ref.watch(chatNotifierProvider); 

    return Scaffold(
      appBar: AppBar(title: const Text("AI Chatbot")),
      body: Column(
        children: [
          // I use expanded here to take on all the remaining space of the screen
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Align(
                    // I use ALign here to show the chat bubbles in different positions depending
                    // on who sent the message
                    alignment: message.isSentByMe
                        ? Alignment.centerRight 
                        : Alignment.centerLeft,
                    
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.isSentByMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: message.isLoading
                      ? const SizedBox(
                        width: 40,
                        child: Column(
                          children: [
                            Text("typing"),
                            SizedBox(height: 10,),
                            LinearProgressIndicator()
                          ],
                        )
                      )
                       

                       :Text(
                        message.text,
                        style: TextStyle(
                            color: message.isSentByMe ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // The Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messagecontroller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                    
                    
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    ref.read(chatNotifierProvider.notifier).sendMessage(messagecontroller.text);
                    messagecontroller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}