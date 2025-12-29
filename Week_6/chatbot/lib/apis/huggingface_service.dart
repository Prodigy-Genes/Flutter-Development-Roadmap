
import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";



class HuggingfaceService {
  // Address of the model
  static const String modelId = "HuggingFaceH4/zephyr-7b-beta:featherless-ai";
  static const String apiUrl = "https://router.huggingface.co/v1/chat/completions";

  // Load apikey from .env 
  final apiToken = dotenv.env["API_KEY"];
    
  final List<Map<String, String>> _messages = [
    {
      "role": "system",
      "content": "You are a helpful chat assistant. Engage the user in a friendly and natural conversation."
    }
  ];

  // function to generate response
  Future<String?> generateResponse (String message) async{
    
    try{
      if (apiToken == null) return "Error: API_KEY not found.";

      _messages.add({"role": "user", "content": message});
      // Assign the Headers when making a POST request to the API
      final headers = {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json'
      };

      // We send a prompt and message to the model in Json format as the body 
      final body = jsonEncode({
        "model": modelId,  // We call the model id of the model we want to use
        "messages": _messages,
        
          "max_tokens": 250,  // limits the number of words in the response
          "temperature": 0.7, // controls the randomness of the response  with 0.0 - 0.3
          // being deterministic and 0.7 - 1.0 being creative 
        
      });

      // Send the Post Request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body
      ).timeout(const Duration(seconds: 30));

      // Check if it worked
      if(response.statusCode == 200){
        
        // huggingface returns a result of strings in Json format which we decode into a Map
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // if choices is found then we skim the top of the list and looking into message key
        // and content we return the response. 
        final String botResponse= data['choices'][0]?['message']?['content']?? "No response recieved";

        // 5. Save the assistant's response to history for next time
        _messages.add({"role": "assistant", "content": botResponse});

        return botResponse;
      }
      
      else{
        // This returns the status code and meaning of that code when there's an error
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    }
    catch(e){
      return "Error: $e";
    }
  }
}