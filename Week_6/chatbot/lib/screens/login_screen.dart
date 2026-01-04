import 'package:chatbot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginLoadingProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 162, 209), // Dark background for the Emerald to pop
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logo.png',
              width: 142,
              height: 142),
            const SizedBox(height: 24),
            const Text(
              "Prodigygenes.ai",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Sign in to use Me!",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 48),
            
            // The Login Button
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading 
                  ? null // Disable button while loading
                  : () async {
                      // Start loading
                      ref.read(loginLoadingProvider.notifier).state = true;
                      
                      try {
                        final userCredential = await ref.read(authServiceProvider).signinWithGoogle();
                        await ref.read(authServiceProvider).signinWithGoogle();
                        if(!context.mounted) return;

                        if (userCredential != null && userCredential.user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Successfully logged in!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          // 3. User cancelled or something went wrong without throwing
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Login cancelled or failed."),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e){
                        if(!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("CRITICAL ERROR: $e"), 
                          backgroundColor: Colors.red, 
                          duration: Duration(seconds: 1), 
                          behavior: SnackBarBehavior.floating,
                          )
                      );
                      }
                      
                      finally {
                        // Stop loading (even if it fails or user cancels)
                        ref.read(loginLoadingProvider.notifier).state = false;
                      }
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text("Sign in with Google"),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}