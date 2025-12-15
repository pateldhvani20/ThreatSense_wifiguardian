import 'package:flutter/material.dart';
import 'jarvis_intro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CyberTitanApp());
}

class CyberTitanApp extends StatelessWidget {
  const CyberTitanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JarvisIntroScreen(),
    );
  }
}
