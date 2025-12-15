import 'dart:async';
import 'package:flutter/material.dart';

class AITypingText extends StatefulWidget {
  final String text;
  const AITypingText({super.key, required this.text});

  @override
  State<AITypingText> createState() => _AITypingTextState();
}

class _AITypingTextState extends State<AITypingText> {
  String displayed = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index < widget.text.length) {
        setState(() {
          displayed += widget.text[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayed,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.cyanAccent,
        fontSize: 16,
      ),
    );
  }
}
