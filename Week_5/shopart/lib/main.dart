import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopart/cart_provider.dart';
import 'package:shopart/increment_provider.dart';
//import 'package:shopart/screens/catalog_screen.dart';
import 'package:shopart/screens/challenge_screen.dart';

void main() {
  runApp(
    // We wrap the MyApp with ChangeNotifierProvider to provide the CartProvider to the entire application.
      const MyApp(),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => IncrementProvider()),
      ],
      child: MaterialApp(
      title: 'ShopArt',
      theme: ThemeData(
        
        primarySwatch: Colors.purple,
        useMaterial3: true
      ),
      home: const ChallengeScreen(),
    )
      );
  }
}


