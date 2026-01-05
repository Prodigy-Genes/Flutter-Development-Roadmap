
import 'package:uuid/uuid.dart';

// Using enum to keep consistency everywhere in the code.
enum MessengerRole { user, model}
class Message {
  final String id; // Unique Id for firestore
  final String text;
  final DateTime date;
  final MessengerRole role; // user or model

  // This is a getter for the UI
  bool get isSentByMe => role == MessengerRole.user;


  Message({
    required this.id,
    required this.text, 
    required this.date, 
    required this.role, 
    });

  // Since we will just be updating the text and role fields
  factory Message.create({required String text, required MessengerRole role}){
    return Message
    (
      // Using Uuid so we are able to generate unique ids for each message
      // This way even if multiple users sent messages at the same time there would 
      // be no collison in id assignings.
    id: const Uuid().v4(), 
    text: text, 
    date: DateTime.now(), 
    role: role
    );
  }

  // Serialization: Convert Message to Map for JSON storage in firestore
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(), // We convert to a standardized String format for storing in firestore
      'role': role.name // Saves as user or model

    };
  }

  // Create a Message from Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      date: DateTime.parse(map['date']),
      role: MessengerRole.values.byName(map['role']),
      
    );
  }



  // CopyWith for state updates for immutable objects
  Message copyWith ({
    String? id,
    String? text,
    DateTime? date,
    MessengerRole? role,
    
  }){
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      role: role ?? this.role,
    );
  }
  
  }



