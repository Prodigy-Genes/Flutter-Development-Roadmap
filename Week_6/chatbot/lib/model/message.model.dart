import 'dart:convert';
class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final String role; // user or model


  Message({
    required this.text, 
    required this.date, 
    required this.role, 
    required this.isSentByMe
    });

  // Convert Message to Map for JSON storage
  Map<String, dynamic> toMap(){
    return {
      'text': text,
      'date': date.toIso8601String(),
      'role': role,

    };
  }

  // Create a Message from Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'],
      date: DateTime.parse(map['date']),
      role: map['role'],
      isSentByMe: map['isSentByMe']
    );
  }

  // Helper for MMKV storage
  String toJson() => json.encode(toMap());

  factory Message.fromJson(String sourse) => Message.fromMap(json.decode(sourse));

  // CopyWith for state updates
  Message copyWith ({
    String? text,
    DateTime? date,
    String? role,
    bool? isSentByMe
  }){
    return Message(
      text: text ?? this.text,
      date: date ?? this.date,
      role: role ?? this.role,
      isSentByMe: isSentByMe ?? this.isSentByMe,
    );
  }
  
  }



