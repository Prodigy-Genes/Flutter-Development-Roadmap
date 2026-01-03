import 'package:chatbot/services/cache_service.dart';
import 'package:chatbot/services/firestore_service.dart';
import 'package:chatbot/services/gemini_service.dart';
import 'package:chatbot/model/message.model.dart';
import 'package:chatbot/services/tts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Create a ChatState for the Messages model
class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final bool isMuted;
  final bool isAudioLoading;
  final String selectedVoice;
  final String? errorMessage;
  final String? currentlySpeakingMessage;

  ChatState({
    required this.messages,
    this.isTyping = false,
    this.isMuted = false,
    this.isAudioLoading=false,
    this.errorMessage,
    this.selectedVoice="Kore",
    this.currentlySpeakingMessage
  });

  // Helper to update the States immutably
  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    bool? isMuted,
    bool? isAudioLoading,
    String? selectedVoice,
    String? errorMessage,
    bool clearError = false,
    String? currentlySpeakingMessage,
    bool clearCurrentlySpeakingMessage = false
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
      : (errorMessage?? this.errorMessage),

      currentlySpeakingMessage: 
      clearCurrentlySpeakingMessage
      ? null
      : (currentlySpeakingMessage?? this.currentlySpeakingMessage)
      );
  }
} 


// A provider to provide an instance of the Gemini Service
final geminiService = Provider<GeminiService>((ref){
  return GeminiService();
});


// A provider to provide an instance of the tts Service
final ttsService = Provider<TtService>((ref){
  return TtService();
});

final firestoreService = Provider<FirestoreService>((ref){
  return FirestoreService();
});

final cacheService = Provider<CacheService>((ref){
  return CacheService();
});

// Create a ChatNotifier class using Notifier
class ChatNotifier extends Notifier<ChatState>{
  // Set up the initial build
  @override
  ChatState build(){
    _init();
    return ChatState(
      messages: [],// Set initial state empty
      isMuted: !ref.read(ttsService).isEnabled,
      selectedVoice: ref.read(ttsService).selectedVoice
      ); 
  }

  // We create an init function here to be used in the build method
  Future<void> _init() async{
    // Instant load from cache

    final local = await ref.read(cacheService).loadChat();
    if(local.isNotEmpty){
      state = state.copyWith(messages: local);
    }

    // Sync from firestore
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      final remote = await ref.read(firestoreService).loadMessages(user.uid);
      if(remote.isNotEmpty){
        state = state.copyWith(messages: remote);
        // update cache with fresh cloud data
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

  Future<void> sendMessage(String message) async{

    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;

    if(user ==null) {
      state = state.copyWith(errorMessage: "Please Login");
      return;
    }

    // Check if message is empty
    if(message.trim().isEmpty) return;
    
    // Take user message
    final userMessage = Message.create(
      text: message,  
      role: MessengerRole.user, 
      );

    // clear previous errors and update the state with user message and set typing to true
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      clearError: true
    );

    await ref.read(firestoreService).saveMessage(user.uid, userMessage);
    await ref.read(cacheService).saveChat(state.messages);

    
    try{
      // Get Gemini response
      final response = await ref.read(geminiService).generateResponse(message);

      // Check for null
      if (response != null && response.isNotEmpty) {
        // Use factory method for AI Message
        final aiResponse = Message.create(
          text: response, 
          role: MessengerRole.model
          );

          

          // Update UI state
          state = state.copyWith(
            messages: [...state.messages, aiResponse],
            isTyping: false
          );

          await ref.read(firestoreService).saveMessage(user.uid, aiResponse);
          await ref.read(cacheService).saveChat(state.messages);

          // Trigger the speech feature if the app isn't muted
          if(!state.isMuted){
            state = state.copyWith(
              isAudioLoading: true, 
              currentlySpeakingMessage: aiResponse.id);
            try{
              await ref.read(ttsService).speak(response);
              }
              finally{
                state = state.copyWith(
                  isAudioLoading: false,
                  clearCurrentlySpeakingMessage: true
                  );
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
final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>((){
  return ChatNotifier();
});