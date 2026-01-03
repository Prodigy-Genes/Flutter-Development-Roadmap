class UserModel{
  final String uid;
  final String email;
  final String displayName;
  final String? profilePicture; // URL from Google
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profilePicture,
    required this.createdAt,
  });

  // Convert to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      profilePicture: map['profilePicture'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}