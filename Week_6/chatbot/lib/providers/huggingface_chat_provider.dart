import 'package:chatbot/apis/huggingface_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MessageState= List<Message>;

// A provider to provide an instance of the the Huggingface Service
final huggingfaceProvider = Provider<HuggingfaceService>((ref){
  return HuggingfaceService();
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
      isSentByMe: true,
      isLoading: false
      );

      // Add user message to state
      state = [...state, userMessage];

      // Add a typing state
      final typingState = Message(
        text: "...", 
        date: DateTime.now(), 
        isSentByMe: false,
        isLoading: true
        );

      // Add typing state to state
      state = [...state, typingState];


      // Call Huggingface service here
      final huggingfaceservice = ref.read(huggingfaceProvider);
      final response = await huggingfaceservice.generateResponse(message);

      final filteredState = state.where((message) => !message.isLoading).toList();


      // Update UI with Huggingface response
      final huggingfacemessage = Message(
        text: response??"", // We set this nullable for incase it fails to generate a response
        date: DateTime.now(), 
        isSentByMe: false,
        isLoading: false
        );

      // Update the state
      state= [...filteredState, huggingfacemessage];


  }

}

// A provider for ChatNotifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, MessageState>((){
  return ChatNotifier();
});