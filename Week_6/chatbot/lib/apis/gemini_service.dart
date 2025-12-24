import 'package:firebase_ai/firebase_ai.dart';


class GeminiService {
  Future<String?> generateResponse(String prompt) async{
    
    try{
      // Initialisee Gemini Developer Backend service
    final model = FirebaseAI.googleAI().generativeModel(model: "gemini-2.5-flash");
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text;
    }
    catch(e){
      return "Error: $e";
    }
      
  }
}