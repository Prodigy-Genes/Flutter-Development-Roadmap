import 'package:chatbot/model/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Initialise the service 
  Future<void> init() async{
    await _googleSignIn.initialize();
  }


  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Using stream to monitor the auth state of the user
  // Using stream because unlike Future which provides a single response or an error
  // Stream can be used to monitor the state changes in the app in terms of authentication
  // As in it is always active
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // GOOGLE SIGN IN
  Future<UserCredential?> signinWithGoogle() async{
    try{
      // Check if platform supports new authentication method
      if(!_googleSignIn.supportsAuthenticate()){
        throw Exception("Google Sign in is not supported on this platform");

      }

      // Trigger authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if(googleUser == null) return null;

      // Request authoriztion for access token
      // Requesting basic scopes to get the tokens required by firebasse
      final List<String> scopes = ['email', 'profile', 'openid'];
      final authClient = await googleUser.authorizationClient.authorizeScopes(scopes);
      final String accessToken = authClient.accessToken;

      // obtain id tokens from standard authentication getter
      final String? idToken = googleUser.authentication.idToken;

      // Create the firebase Credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken
      );

      // Sign in to firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if(userCredential.user != null){
        await _syncUserProfile(userCredential.user!);
      }

      return userCredential;
    }catch(e){
      print("Login Error: $e");
      return null;
      
    }

  }

  Future<void> _syncUserProfile(User firebaseUser) async{
    final userRef = _db.collection('users').doc(firebaseUser.uid);

    // Create custom model from firebase User data
    final newUser = UserModel(
      uid: firebaseUser.uid, 
      email: firebaseUser.email ?? "Unknown", 
      displayName: firebaseUser.displayName ?? "Unknown", 
      profilePicture: firebaseUser.photoURL, 
      createdAt: DateTime.now()
      );
      await userRef.set(newUser.toMap(), SetOptions(merge: true));
  }

  Future<void> signout() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

final authServiceProvider = Provider((ref){
  return AuthService();
});