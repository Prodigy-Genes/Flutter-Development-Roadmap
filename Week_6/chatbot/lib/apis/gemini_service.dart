import 'package:firebase_ai/firebase_ai.dart';
// Imported the firebase AI logic here, I am using the Gemini Developer API
// Since it is free for testing.

class GeminiService {
  // Name of the model
  static const String modelname = "gemini-2.5-flash";

  // To ensure its ready when called
  late final GenerativeModel _model;

  // Adding chat history
  late ChatSession _chat;

  // This is an Instance of the model to call and use in the app
   GeminiService(){
    _model = FirebaseAI.googleAI().generativeModel(
    model: modelname, 
    systemInstruction: Content.system("You are a chat assistant. Provide assistance in any way you can.")
    
    );


    // Initialise chatsession here
    _chat = _model.startChat(history: []);
   } 
  
  Future<String?> generateResponse(String prompt) async{
    
    try{
    // We send the prompt to the model 
    // We get a response from the model and return it in text format
    // The session automatically adds the user prompt and the AI response to its history.
    final response = await _chat.sendMessage(Content.text(prompt) );

    return response.text?? "I am sorry, I couldn't generate a response.";
    }
    catch(e){
      throw Exception("Error: $e");
    
    }
      
  }
}