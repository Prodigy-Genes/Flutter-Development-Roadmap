import 'package:chatbot/model/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Initialise the service 
  Future<void> init() async{
    await _googleSignIn.initialize(
      serverClientId: dotenv.env['WEB_CLIENT_ID']
    );
  }

  // An instance of Firestore
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

      // Trigger google sign inauthentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

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
        //print("Auth success! Syncing to Firestore for UID: ${userCredential.user!.uid}");
        await _syncUserProfile(userCredential.user!);
      }

      return userCredential;
    }catch(e){
      //print("Login Error: $e");
      return null;
      
    }

  }

  Future<void> _syncUserProfile(User firebaseUser) async{
    try{
      // Create a database collection for the user
      final userRef = _db.collection('users').doc(firebaseUser.uid);

    // Create custom model from firebase User data
    final newUser = UserModel(
      uid: firebaseUser.uid, 
      email: firebaseUser.email ?? "Unknown", 
      displayName: firebaseUser.displayName ?? "Unknown", 
      profilePicture: firebaseUser.photoURL, 
      createdAt: DateTime.now()
      );
      // Then merge the existing data to firestore for everytime user logs in
      // to prevent exisiting user data
      await userRef.set(newUser.toMap(), SetOptions(merge: true));
      //print("Firestore Sync Complete!");
    }catch(e){
      //print("Firestore Sync ERROR: $e");
    }
    
  }

  Future<void> signout() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

// This is the root state provider so the authService can be used anywhere in the app
final authServiceProvider = Provider((ref){
  return AuthService();
});

// This state monitors the auth state of the user
final authStateProvider = StreamProvider((ref){
  return ref.watch(authServiceProvider).authStateChanges;
});
// This creates a loading state for the process of authenticating
final loginLoadingProvider = StateProvider<bool>((ref) => false);