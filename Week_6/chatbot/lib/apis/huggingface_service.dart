
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";



class HuggingfaceService {
  // Address of the model
  static const String modelId = "HuggingFaceH4/zephyr-7b-beta:featherless-ai";
  static const String apiUrl = "https://router.huggingface.co/v1/chat/completions";

  
  

  // function to generate response
  Future<String?> generateResponse (String message) async{
    try{
      // Load apikey from .env 
      final apiToken = dotenv.env["API_KEY"];
      if (apiToken == null) return "Error: API_KEY not found.";
      // Assign the Headers when making a POST request to the API
      final headers = {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json'
      };

      // Now declaring the body since the API expects some sort of 
      // body and structure
      final body = jsonEncode({
        "model": modelId, // The model ID goes inside the body now
        "messages": [
          {
            "role": "system", 
            "content": "You are a senior cybersecurity analyst. concise, technical, and focus on security risks."
          },
          {
            "role": "user",
            "content": message
          }
        ],
        "max_tokens": 250, // "max_new_tokens" is renamed to "max_tokens" in this API
        "temperature": 0.7
      });

      // Send the Post Request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body
      );

      // Check if it worked
      if(response.statusCode == 200){
        // hugginface returns a list of maps
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }else{
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    }
    catch(e){
      return "Error: $e";
    }
  }
}