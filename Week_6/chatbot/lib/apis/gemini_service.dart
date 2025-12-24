
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  Future<String?> generateResponse(String prompt) async{
    
    try{
      final apiKey = dotenv.env['API_KEY']??"";
    // Check if the apiKey is empty
    if(apiKey.isEmpty) return "API KEY NOT FOUND";

    final model = GenerativeModel(apiKey: apiKey, model: 'gemini-1.5-flash');
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text;
    }
    catch(e){
      return "Error: $e";
    }
      
  }
}