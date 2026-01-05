import 'dart:convert';

import 'package:chatbot/model/message.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  // This key basically holds the lock to every locally stored message in the app
  final cacheKey = "local_chat_cache";

  Future<void> saveChat(List<Message> messages) async{
    // Call in the SharedPreference dependency instance
    final pref = await SharedPreferences.getInstance();

    // Encode the Message model and convert to json for storing locally
    final String endcodedData = jsonEncode(messages.map((m)=> m.toMap()).toList());
    // Pass the encoded data to the key
    await pref.setString(cacheKey, endcodedData);

  }

  Future<List<Message>> loadChat() async{
    final pref = await SharedPreferences.getInstance();

    // retrieve the data stored locally via the key
    final String? cacheData = pref.getString(cacheKey);

    if(cacheData == null) return [];

    // We retrieve and decode the messages from local storage into 
    //list of maps for the message mmodel
    final List<dynamic> decodeData = jsonDecode(cacheData);
    return decodeData.map((m)=> Message.fromMap(m)).toList();
  }

  Future<void>clearCache() async{
    final pref = await SharedPreferences.getInstance();
    await pref.remove(cacheKey);
  }

}

