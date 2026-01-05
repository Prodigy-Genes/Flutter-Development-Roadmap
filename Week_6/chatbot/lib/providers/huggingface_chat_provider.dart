import 'package:chatbot/services/cache_service.dart';
import 'package:chatbot/services/firestore_service.dart';
import 'package:chatbot/services/huggingface_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:chatbot/services/tts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final bool isMuted;
  final bool isAudioLoading;
  final String selectedVoice;
  final String? errorMessage;
  // set the constructor
  ChatState({
    required this.messages,
    this. isTyping = false,
    this. isMuted = false,
    this. isAudioLoading = false,
    this. selectedVoice = 'kore',
    this .errorMessage
  });

  // Helper to update the state immutably
  ChatState copyWith({
    List<Message>? messages,
    bool?  isTyping,
    bool? isMuted,
    bool? isAudioLoading,
    String? selectedVoice,
    String? errorMessage,
    bool clearError = false
  }){
    return ChatState(
      messages
      : messages
      ?? this.messages,
      
      isTyping
      : isTyping
      ?? this.isTyping,

      isMuted
      : isMuted
      ?? this.isMuted,

      isAudioLoading
      : isAudioLoading
      ?? this.isAudioLoading,  

      selectedVoice
      : selectedVoice 
      ?? this.selectedVoice,
      
      errorMessage: 
      clearError 
      ? null 
      : this.errorMessage,
      
    );
  }


}
// A provider to provide an instance of the the Huggingface Service
final huggingfaceProvider = Provider<HuggingfaceService>((ref){
  return HuggingfaceService();
});

// A provider to provide an instance of the tts service
final ttsService = Provider<TtService>((ref){
  return TtService();
});

final firestoreService = Provider<FirestoreService>((ref){
  return FirestoreService();
});

final cacheService = Provider<CacheService>((ref){
  return CacheService();
});

class ChatNotifier extends Notifier<ChatState>{
  
  @override
  ChatState build(){
    _init();
    // initial state is empty
    return ChatState(
      messages:[],
      isMuted: ref.read(ttsService).isEnabled,
      selectedVoice: ref.read(ttsService).selectedVoice 

    );
  }

  Future<void> _init() async{
    final local = await ref.read(cacheService).loadChat();
    if(local.isNotEmpty){
      state = state.copyWith(messages: local);
    }

    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      final remote = await ref.read(firestoreService).loadMessages(user.uid);
      if(remote.isNotEmpty){
        state = state.copyWith(messages: remote);
        // Update the local data with fresh cloud data
        await ref.read(cacheService).saveChat(remote);
      }
    }
  }

  // A function to toggle the mute state
  void toggleMute(){
    final tts = ref.read(ttsService);
    tts.toggleTTS();
    state = state.copyWith(isMuted: !tts.isEnabled);
  }

  void updateVoice(String voiceName){
    ref.read(ttsService).setVoice(voiceName);
  }

  // manually stop any ongoing speech
  void stopSpeech(){
    ref.read(ttsService).stop();
  }

  // Send a message function
  Future<void> sendMessage(String message) async{
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      state = state.copyWith(errorMessage: "Please login");
      return;
    }
    // Check if message is empty
    if(message.trim().isEmpty) return;    

    // Take user message
    final userMessage = Message.create(
      text: message, 
      role: MessengerRole.user
      );

      //Update the UI wth user's message and set typing state to true
      state = state.copyWith(
        messages: [...state.messages, userMessage],
        isTyping: true,
        clearError: true
      );

      await ref.read(firestoreService).saveMessage(user.uid, userMessage);
      await ref.read(cacheService).saveChat(state.messages);
      

      try{
        // Call Huggingface service here
        final aiData = ref.read(huggingfaceProvider);
        final response = await aiData.generateResponse(message);

        if(response != null && response.isNotEmpty){
          final aiResponse = Message.create(
            text: response, 
            role: MessengerRole.model
            );

          // Update the Ui
          state = state.copyWith(
            messages: [...state.messages, aiResponse],
            isTyping: false
          );

          await ref.read(firestoreService).saveMessage(user.uid, userMessage);
          await ref.read(cacheService).saveChat(state.messages);

          if(!state.isMuted){
            state = state.copyWith(isAudioLoading: true);
            try{
              await ref.read(ttsService).speak(response);
            }
            finally{
              state = state.copyWith(isAudioLoading: false);
            }
          }

        }

        
        
        
      }catch(e){
        String errString = e.toString();
      
      // Simplify error message if it's a quota issue
      if (errString.contains("quota") || errString.contains("limit")) {
        final RegExp regExp = RegExp(r'(\d+\.?\d*)s');
        final match = regExp.firstMatch(errString);
        final seconds = match != null ? "${double.tryParse(match.group(1)!)?.ceil()}s" : "30s";
        errString = "Quota exceeded. Try again in $seconds.";
      }

      state = state.copyWith(
        isTyping: false,
        isAudioLoading: false,
        errorMessage: errString.toString()
        );
        
      }

  }

  

}

// A provider for ChatNotifier
//final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>((){
  //return ChatNotifier();
//});