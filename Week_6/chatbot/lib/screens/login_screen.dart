import 'package:chatbot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background for the Emerald to pop
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.lightGreen),
            const SizedBox(height: 24),
            const Text(
              "Prodigygenes.ai",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Sign in to use Me!",
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 48),
            
            // The Login Button
            ElevatedButton.icon(
              onPressed: () => ref.read(authServiceProvider).signinWithGoogle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                height: 24,
              ),
              label: const Text("Sign in with Google"),
            ),
          ],
        ),
      ),
    );
  }
}