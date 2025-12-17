import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopart/src/features/products/presentation/catalog_screen.dart';

void main() {
  runApp(
    // We wrap the entire app in ProviderScope to provide the CartProvider and IncrementProvider to the entire app
      ProviderScope(
        child: const MyApp()),
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
      home: const CatalogScreen()
      );
  }
}


