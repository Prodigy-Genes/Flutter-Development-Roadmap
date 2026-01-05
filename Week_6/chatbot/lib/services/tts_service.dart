import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class TtService {
  final AudioPlayer _audioPlayer = AudioPlayer(); // This is an engine that plays the sound
  bool _isEnabled = true;
  // Tried using the firebase ai logic's SDK but there was a problem in it effectlively handling 
  // the tts appropriately so, I decided to switch back and use the normal http calls to 
  // Google studios using the gemini API key
  final _apiKey = dotenv.env['GEMINI_API_KEY'];

  // Set a getter for the bool
  bool get isEnabled => _isEnabled;

  // We set a default voice
  String _selectedVoice = "Kore";
  String get selectedVoice => _selectedVoice;

  // A list of available voices the model provides
  final List<String> availableVoices = [
    "Kore", "Zephyr", "Charon", "Puck", "Fenrir", "Leda", "Orus"
  ];

  // User can choose from the list what voice to use
  // Was unable to run lots of tests with this because of the api limit
  void setVoice(String voice) {
    if (availableVoices.contains(voice)) {
      _selectedVoice = voice;
    }
  }

  // A function to handle the enabled and disabled tts

  void toggleTTS() {
    _isEnabled = !_isEnabled;
    if (!_isEnabled) {
      stop();
    }
  }

  /// Sends the text to Gemini TTS API
  Future<void> speak(String text) async {
    // Checks if the tts is enabled or text is empty 
    if (!_isEnabled || text.isEmpty) return;

    int retryCount = 0;
    // Maximum number of retries is set here
    const int maxRetries = 3;

    // Set a while loop to keep it making a network request until the max  number of retries
    // is up.
    while (retryCount <= maxRetries) {
      try {
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent?key=$_apiKey');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {"text": "Say naturally: $text"}
                ]
              }
            ],
            "generationConfig": {
              "responseModalities": ["AUDIO"],
              "speechConfig": {
                "voiceConfig": {
                  // Use the selected voice here
                  "prebuiltVoiceConfig": {"voiceName": _selectedVoice}
                }
              }
            }
          }),
        );

        if (response.statusCode == 200) {
          // We take the long string from gemini and turn it into a dart Map
          final data = jsonDecode(response.body);
          
          // Safer extraction logic to avoid "missing identifier" or null errors
          // grabbing the first of the multiple responses Gemini provides
          final candidates = data['candidates'] as List?;
          // Null checking
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'] as List?;
            
            if (parts != null) {
              final audioPart = parts.firstWhere(
                // This returns the part of the response that contains audio data
                (p) => p is Map && p.containsKey('inlineData'),
                orElse: () => null,
              );
              // The API sends back a base64 string  of binary data so we handle that with
              // Uint8List which converts it to a PCM and most players have a porblem with that
              // So we create a wavHEader which tells the PCM exactly how to do things
              if (audioPart != null) {
                final String? base64Audio = audioPart['inlineData']?['data'];
                if (base64Audio != null) {
                  final Uint8List pcmBytes = base64Decode(base64Audio);
                  
                  final wavBytes = _createWavHeader(pcmBytes, 24000); // Like setting the frequency to Gemini standard 24000Hz
                  await _audioPlayer.play(BytesSource(wavBytes)); // We play the audio from the RAM
                  return; // Success
                }
              }
            }
          }
        }
        if (response.statusCode == 429) {
          throw Exception("Quota exceeded. Please wait a few seconds.");
        }
        
        throw Exception("API Error: ${response.statusCode}");
      } catch (e) {
        if (retryCount >= maxRetries || e.toString().contains("429") || e.toString().contains("Quota") ){
          rethrow;
        }
        
        // This gives the server a breathing room with an exponential backoff
        final delay = Duration(seconds: 1 << retryCount);
        await Future.delayed(delay);
        retryCount++;
      }
    }
  }

  // When Gemini sends audio back it is usually in raw PCM - Pulse Code Manipulation
  // And that is why this block converts that into WAV - WaveForm HEADER
  Uint8List _createWavHeader(Uint8List pcmData, int sampleRate) {
    final int channels = 1; // We set the sound channel to mono
    final int bitDepth = 16;
    final int byteRate = sampleRate * channels * bitDepth ~/ 8;
    final int blockAlign = channels * bitDepth ~/ 8;
    final int dataSize = pcmData.length;
    final int fileSize = 36 + dataSize;

    final header = ByteData(44);
    // This RIFF identifies the filetype 
    header.setUint8(0, 0x52); // R
    header.setUint8(1, 0x49); // I
    header.setUint8(2, 0x46); // F
    header.setUint8(3, 0x46); // F

    // Then the file size of the file is determined in bytes
    header.setUint32(4, fileSize, Endian.little);

    // Subformat is declared as a WAVE file
    header.setUint8(8, 0x57); // W
    header.setUint8(9, 0x41); // A
    header.setUint8(10, 0x56); // V
    header.setUint8(11, 0x45); // E
    header.setUint8(12, 0x66); // f
    header.setUint8(13, 0x6D); // m
    header.setUint8(14, 0x74); // t
    header.setUint8(15, 0x20); // _
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little); // PCM
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitDepth, Endian.little);

    // Data chunk
    header.setUint8(36, 0x64); // d
    header.setUint8(37, 0x61); // a
    header.setUint8(38, 0x74); // t
    header.setUint8(39, 0x61); // a
    header.setUint32(40, dataSize, Endian.little);

    final wavFile = Uint8List(44 + dataSize);
    wavFile.setAll(0, header.buffer.asUint8List());
    wavFile.setAll(44, pcmData);
    return wavFile;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}