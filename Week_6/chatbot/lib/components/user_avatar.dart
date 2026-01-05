import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot/providers/gemini_chat_provider.dart';
import 'package:chatbot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  final double radius;
  const UserAvatar({super.key, this.radius =20});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        // Call the user profile 
        final photoUrl = user?.photoURL;

        return GestureDetector(
          onTap: () {
            ref.read(chatNotifierProvider.notifier).clearCache();

            ref.read(authServiceProvider).signout(ref);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Sign out successful"),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating, 
                )
            );
          } ,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            foregroundImage: photoUrl != null? CachedNetworkImageProvider(photoUrl) : null,
            child: photoUrl == null ? Icon(Icons.person, size: 24, color: Colors.white,) : null
          
          
          ),
        );
      }, 
      error: (_,_) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.red,
        child: Icon(Icons.error_outline, size: 24, color: Colors.white,),
      ),
      // While checking Auth 
      loading: () => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black

      )
      );
  }
}