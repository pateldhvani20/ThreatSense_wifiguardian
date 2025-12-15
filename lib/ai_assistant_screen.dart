import 'package:flutter/material.dart';
import 'dart:math';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Guardian AI"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(250, 250),
              painter: JarvisCorePainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class JarvisCorePainter extends CustomPainter {
  final double progress;

  JarvisCorePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final basePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Outer rotating ring
    canvas.drawCircle(center, 110, basePaint);

    // Inner pulse
    final pulseRadius = 60 + 10 * sin(progress * 2 * pi);
    canvas.drawCircle(center, pulseRadius, basePaint);

    // Core
    final corePaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
