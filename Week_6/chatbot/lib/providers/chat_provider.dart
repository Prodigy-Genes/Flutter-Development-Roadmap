//import 'package:chatbot/apis/gemini_service.dart';
import 'package:chatbot/apis/huggingface_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef MessageState= List<Message>;

// A provider to provide an instance of the the Gemini Service
/*final geminiProvider = Provider<GeminiService>((ref){
  return GeminiService();
});*/

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
      isSentByMe: true
      );

      // Add user message to state
      state = [...state, userMessage];

      // Call Gemini service here 
      //final geminiservice = ref.read(geminiProvider);
      //final response = await geminiservice.generateResponse(message);

      // Call Huggingface service here
      final huggingfaceservice = ref.read(huggingfaceProvider);
      final response = await huggingfaceservice.generateResponse(message);


      // Update UI with GEmini response
      /*final geminiMessage = Message(
        text: response??"",
        date: DateTime.now(),
        isSentByMe: false
      );*/

      // Update UI with Huggingface response
      final huggingfacemessage = Message(
        text: response??"", 
        date: DateTime.now(), 
        isSentByMe: false
        );

      // Update the state
      state= [...state, huggingfacemessage];


  }

}

// A provider for ChatNotifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, MessageState>((){
  return ChatNotifier();
});