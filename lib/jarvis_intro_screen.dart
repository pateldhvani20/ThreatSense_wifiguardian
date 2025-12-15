import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home_dashboard.dart';

class JarvisIntroScreen extends StatefulWidget {
  const JarvisIntroScreen({super.key});

  @override
  State<JarvisIntroScreen> createState() => _JarvisIntroScreenState();
}

class _JarvisIntroScreenState extends State<JarvisIntroScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _startIntro();
  }

  Future<void> _startIntro() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
    await _tts.setVolume(1.0);

    await _tts.speak(
      "Hello. I am Guardian A I. "
      "Your cyber defense system is now active. "
      "What would you like to do today?"
    );

    // Wait before moving to dashboard
    await Future.delayed(const Duration(seconds: 6));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🤖 ROBOT IMAGE
            Image.asset(
              'assets/robot/giphy.gif',
              width: 220,
            ),
            const SizedBox(height: 30),

            // 🧠 AI TEXT
            const Text(
              "Guardian AI Initializing...",
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
