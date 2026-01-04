import 'package:chatbot/components/audio_visualizer.dart';
import 'package:chatbot/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gemini_chat_provider.dart';


class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  // Controller here will hold the message the user send on the app
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  void _scrolltobottom(){
    if(_scrollController.hasClients){
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut
       );
    }
  }

  @override
  void dispose(){
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    // Call in the ChatNotifier Provider for  the AI Model
    final chatState = ref.watch(chatNotifierProvider);
    final messages = chatState.messages;

    // Access the TTS service for voice options
    final ttService = ref.watch(ttsService);

    
    // scroll to the bottom whenever messages list or typing state changes
    ref.listen(chatNotifierProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length || 
          next.isTyping || 
          next.isAudioLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrolltobottom());
      }
    });

    

    return Scaffold(
      appBar: AppBar(
        leading: 
            // Mute/Unmute Toggle (Volume Icon)
            IconButton(
              
              onPressed: () => ref.read(chatNotifierProvider.notifier).toggleMute(), 
              icon: Icon(
                chatState.isMuted
                ? Icons.volume_off
                : Icons.volume_up
              ),
              ),

        actions: [
          // Voice selection drop down
          PopupMenuButton<String>(
            icon: const Icon(Icons.record_voice_over),
            tooltip: "Select Voice",
            onSelected: (String voice){
              ref.read(chatNotifierProvider.notifier).updateVoice(voice);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Voice changed to $voice"),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                  )
              );
            },
            itemBuilder: (context) => ttService.availableVoices
            .map((v) => PopupMenuItem(
              value: v, 
              child: Row(
                children: [
                  Icon(Icons.check,
                  color: chatState.selectedVoice == v
                  ? Colors.green
                  : Colors.transparent
                  
                  ),
                  const SizedBox(width: 8,),
                  Text(v),
                ],
              )))
            .toList(),

            ),

            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: UserAvatar(radius: 15,),
              )
            
        ]
            ),
      body: Column(
        children: [
          // Show an error banner here
           if (chatState.errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chatState.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
          // I use expanded here to take on all the remaining space of the screen
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isSpeaking = chatState.currentlySpeakingMessage == message.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  
                  child: Row(
                    mainAxisAlignment: message.isSentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                    
                    children: [
                      if(!message.isSentByMe && isSpeaking) const AudioVisualizer(),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal:16, vertical:10),
                      decoration: BoxDecoration(
                        color: message.isSentByMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(18).copyWith(
                          bottomRight: message.isSentByMe
                          ? const Radius.circular(0)
                          : const Radius.circular(18),
                          bottomLeft: message.isSentByMe
                          ? const Radius.circular(0)
                          : const Radius.circular(18)
                        )
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                            color: message.isSentByMe ? Colors.white : Colors.black87,
                            fontSize: 16
                            ),
                      ),
                    ),
                    if (message.isSentByMe && isSpeaking) const AudioVisualizer(),
                    ]
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: chatState.isTyping 
                ? _statusIndicator("Hold on. Lemme think...") 
                : chatState.isAudioLoading 
                  ? _statusIndicator("Generating voice...") 
                  : const SizedBox.shrink(),
            ),
          ),

          // The Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _statusIndicator(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          const SizedBox(width: 8),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
          )
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Send a message...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
                onSubmitted: (val) => _send(val),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _send(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(String text) {
    if (text.trim().isNotEmpty) {
      ref.read(chatNotifierProvider.notifier).sendMessage(text);
      _messageController.clear();
    }
  }
}
  
  



  
