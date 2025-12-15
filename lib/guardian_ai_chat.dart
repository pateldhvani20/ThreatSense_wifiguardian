import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum GuardianCommand { radar, heatmap, honeypot, unknown }

class GuardianAI {
  static final FlutterTts _tts = FlutterTts();
  static final SpeechToText _stt = SpeechToText();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);

    await _stt.initialize();

    _initialized = true;
  }

  /// Jarvis greeting
  static Future<void> greetUser() async {
    await init();
    await _tts.speak(
      "Hello. I am Guardian A I. "
      "What would you like to open?"
    );
  }

  /// 🎤 Listen and return command
  static Future<GuardianCommand> listenForCommand() async {
    await init();

    await _tts.speak("Listening.");

    String recognizedText = "";

    await _stt.listen(
      listenFor: const Duration(seconds: 5),
      onResult: (result) {
        recognizedText = result.recognizedWords.toLowerCase();
      },
    );

    await Future.delayed(const Duration(seconds: 5));
    await _stt.stop();

    if (recognizedText.contains("radar")) {
      return GuardianCommand.radar;
    } else if (recognizedText.contains("heat")) {
      return GuardianCommand.heatmap;
    } else if (recognizedText.contains("honey")) {
      return GuardianCommand.honeypot;
    } else {
      return GuardianCommand.unknown;
    }
  }

  /// Speak feedback
  static Future<void> speak(String msg) async {
    await _tts.speak(msg);
  }
}
