import 'package:chatbot/model/message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // The exact path our collections will follow
  CollectionReference _chatRef(String userId) =>
    _db.collection("users").doc(userId).collection("chats");

    Future<void> saveMessage(String userId, Message message) async{
      await _chatRef(userId).doc(message.id).set(message.toMap());
    }

    Future<List<Message>> loadMessages(String userId) async{
      final snapshot = await _chatRef(userId).orderBy('date', descending: false).get();
      return snapshot.docs.map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>)).toList();
    }

    Future<void> clearChat(String userId) async{
      final batch = _db.batch();
      final snapshot = await _chatRef(userId).get();
      for(var doc in snapshot.docs){
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

}

