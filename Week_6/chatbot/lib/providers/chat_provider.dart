import 'package:chatbot/apis/gemini_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MessageState= List<Message>;

// A provider to provide an instance of the the Gemini Service
final geminiProvider = Provider<GeminiService>((ref){
  return GeminiService();
});



class ChatNotifier extends Notifier<MessageState>{
  @override
  MessageState build(){
    // initial state is empty
    return [];
  }

  // Send a message function
  Future<void> sendMessage(String message) async{
    // Check if message is empty
    if(message.isEmpty) return;

    // Take user message
    final userMessage = Message(
      text: message, 
      date: DateTime.now(), 
      isSentByMe: true
      );

      // Add user message to state
      state = [...state, userMessage];

      // Call Gemini service here 
      final geminiservice = ref.read(geminiProvider);
      final response = await geminiservice.generateResponse(message);

      // Update UI with GEmini response
      final geminiMessage = Message(
        text: response??"",
        date: DateTime.now(),
        isSentByMe: false
      );

      // Update the state
      state= [...state, geminiMessage];


  }

}

// A provider for ChatNotifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, MessageState>((){
  return ChatNotifier();
});