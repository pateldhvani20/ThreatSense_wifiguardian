import 'package:flutter/material.dart';

class GuardianAIOrb extends StatefulWidget {
  const GuardianAIOrb({super.key});

  @override
  State<GuardianAIOrb> createState() => _GuardianAIOrbState();
}

class _GuardianAIOrbState extends State<GuardianAIOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0.8),
                Colors.blueAccent.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(
                    0.5 + controller.value * 0.4),
                blurRadius: 30 + controller.value * 20,
              ),
            ],
          ),
          child: const Icon(
            Icons.smart_toy,
            color: Colors.white,
            size: 50,
          ),
        );
      },
    );
  }
}
