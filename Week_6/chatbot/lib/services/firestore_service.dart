import 'package:chatbot/model/message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // We create a subcollection in the users collection for chats
  // This way the each user has their own chat history 
  CollectionReference _chatRef(String userId) =>
    _db.collection("users").doc(userId).collection("chats");

    // Saving message to firestore by converting to json 
    Future<void> saveMessage(String userId, Message message) async{
      await _chatRef(userId).doc(message.id).set(message.toMap());
    }

    // Messages are loaded from firestore by converting from json to Message model 
    Future<List<Message>> loadMessages(String userId) async{
      final snapshot = await _chatRef(userId).orderBy('date', descending: false).get();
      return snapshot.docs.map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>)).toList();
    }

}

