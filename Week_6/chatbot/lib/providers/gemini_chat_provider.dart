

import 'package:chatbot/apis/gemini_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Create an alias for the model
typedef MessageState = List<Message>;

// A provider to provide an instance of the Gemini Service
final geminiService = Provider<GeminiService>((ref){
  return GeminiService();
});

// Create a ChatNotifier class using Notifier
class ChatNotifier extends Notifier<MessageState>{

  // Set up the initial build
  @override
  MessageState build(){
    return []; // Set initial state empty
  }

  Future<void> sendMessage(String message) async{
    // Check if message is empty
    if(message.isEmpty) return;

    // Take user message
    final userMessage = Message(text: message, date: DateTime.now(), isSentByMe: true, isLoading: false);

    // update the state with user message
    state = [...state, userMessage];

    // Add a typing state
    final typingMessage = Message(text: "...", date: DateTime.now(), isSentByMe: false, isLoading: true);
    state = [...state, typingMessage];
    
    // Call Gemini Service
    final geminiservice = ref.read(geminiService);
    final response = await geminiservice.generateResponse(message);

    // Remove the loading place holder and add the response
    final filteredState = state.where((message) => !message.isLoading).toList();


    // Update UI with Gemini response
    final geminiMessage = Message(text:response??"No response recieved", date: DateTime.now(), isSentByMe: false, isLoading: false);

    // update the state with Gemini response
    state = [...filteredState, geminiMessage];
  }
}

// A provider for ChatNotifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, MessageState>((){
  return ChatNotifier();
});