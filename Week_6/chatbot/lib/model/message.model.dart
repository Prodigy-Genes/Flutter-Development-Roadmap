
import 'package:uuid/uuid.dart';

enum MessengerRole { user, model}
class Message {
  final String id; // Unique Id for firestore
  final String text;
  final DateTime date;
  final MessengerRole role; // user or model

  bool get isSentByMe => role == MessengerRole.user;


  Message({
    required this.id,
    required this.text, 
    required this.date, 
    required this.role, 
    });

  // Automatically generate an id for each Message model
  factory Message.create({required String text, required MessengerRole role}){
    return Message
    (
    id: const Uuid().v4(), 
    text: text, 
    date: DateTime.now(), 
    role: role
    );
  }

  // Convert Message to Map for JSON storage
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(), // We convert to a standardized String format
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



  // CopyWith for state updates
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



