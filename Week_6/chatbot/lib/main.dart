import 'package:chatbot/screens/chat_screen.dart';
import 'package:chatbot/screens/login_screen.dart';
import 'package:chatbot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> getapi() async{
  await dotenv.load(fileName: ".env");
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await getapi();

  final container = ProviderContainer();

  try{
    final authService = container.read(authServiceProvider);
    await authService.init();
    //print("Auth Service Initialized Successfully");
  }catch(e){
    //print("Auth Initialization failed: $e");
  }

  
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp())
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Prodigygenes.ai',
        theme: ThemeData(
          
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data : (user){
        if(user != null){
          return const ChatScreen();
        }
        return const LoginScreen();
      },

      loading: () => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/logo.png",
            width: 142,
            height: 142),
            const SizedBox(height: 24,),
            Text("Hang Tight!", style: TextStyle(color: Colors.black),)
          ],
        ),
      ),

      error: (e, trace) => Scaffold(body: Center(child: Text("Error: $e"),),)
    );
  }
}


