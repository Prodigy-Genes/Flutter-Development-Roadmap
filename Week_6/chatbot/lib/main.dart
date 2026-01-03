import 'package:chatbot/screens/chat_screen.dart';
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

  final container = ProviderContainer();

  try{
    await container.read(authServiceProvider).init();
  }catch(e){
    print("Auth Initialization failed: $e");
  }

  await getapi();
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
        title: 'Flutter Demo',
        theme: ThemeData(
          
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
    );
  }
}


