import 'package:chatbot/services/huggingface_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  // set the constructor
  ChatState({
    required this.messages,
    this. isTyping = false
  });

  // Helper to update the state immutably
  ChatState copyWith({
    List<Message>? messages,
    bool?  isTyping
  }){
    return ChatState(
      messages: messages?? this.messages,
      isTyping: isTyping?? this.isTyping
    );
  }


}
// A provider to provide an instance of the the Huggingface Service
final huggingfaceProvider = Provider<HuggingfaceService>((ref){
  return HuggingfaceService();
});



class ChatNotifier extends Notifier<ChatState>{
  @override
  ChatState build(){
    // initial state is empty
    return ChatState(messages:[]
    );
  }

  // Send a message function
  Future<void> sendMessage(String message) async{
    // Check if message is empty
    if(message.trim().isEmpty) return;

    // Take user message
    final userMessage = Message(
      text: message, 
      date: DateTime.now(), 
      isSentByMe: true,
      role: 'user'
      );

      //Update the UI wth user's message and set typing state to true
      state = state.copyWith(
        messages: [...state.messages, userMessage],
        isTyping: true
      );
      

      try{
        // Call Huggingface service here
        final huggingfaceservice = ref.read(huggingfaceProvider);
        final response = await huggingfaceservice.generateResponse(message);

        final aiMessage = Message(
          text: response?? "I am sorry, I couldn't come up with anything",
          date: DateTime.now(),
          isSentByMe: false,
          role: 'model'
        );

        // Update the UI with the ai's response and set typing state to false
        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isTyping: false
        );

      }catch(e){
        state = state.copyWith(isTyping: false);
      }

  }

}

// A provider for ChatNotifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>((){
  return ChatNotifier();
});