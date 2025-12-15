import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopart/cart_provider.dart';
import 'package:shopart/screens/catalog_screen.dart';

void main() {
  runApp(
    // We wrap the MyApp with ChangeNotifierProvider to provide the CartProvider to the entire application.
    ChangeNotifierProvider(
      create : (context) => CartProvider(),
      child: const MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopArt',
      theme: ThemeData(
        
        primarySwatch: Colors.purple,
        useMaterial3: true
      ),
      home: const CatalogScreen(),
    );
  }
}


