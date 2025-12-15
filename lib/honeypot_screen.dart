import 'package:flutter/material.dart';

class HoneypotScreen extends StatefulWidget {
  const HoneypotScreen({super.key});

  @override
  State<HoneypotScreen> createState() => _HoneypotScreenState();
}

class _HoneypotScreenState extends State<HoneypotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<Map<String, dynamic>> honeypots = [
    {"name": "Free_Public_WiFi", "x": 0.3, "y": 0.4},
    {"name": "Cafe_WiFi", "x": 0.7, "y": 0.3},
    {"name": "Airport_Free_WiFi", "x": 0.5, "y": 0.7},
  ];

  final List<Map<String, dynamic>> attackers = [
    {"x": 0.1, "y": 0.9},
    {"x": 0.9, "y": 0.8},
  ];

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: const Text("AI Honeypot Trap"),
        backgroundColor: const Color(0xFF0B0F1A),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            children: [
              // Grid background
              CustomPaint(
                size: Size(w, h),
                painter: _GridPainter(),
              ),

              // Attacker paths
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) {
                  return CustomPaint(
                    size: Size(w, h),
                    painter: _AttackPathPainter(
                      honeypots: honeypots,
                      attackers: attackers,
                      progress: controller.value,
                    ),
                  );
                },
              ),

              // Honeypots
              for (var hpot in honeypots)
                Positioned(
                  left: w * hpot["x"] - 30,
                  top: h * hpot["y"] - 30,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purpleAccent.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.wifi,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hpot["name"],
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      )
                    ],
                  ),
                ),

              // Info card
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.purpleAccent),
                  ),
                  child: const Text(
                    "🧠 Guardian AI has deployed decoy Wi-Fi traps.\nSuspicious connections are redirected and analyzed.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

/* ================= GRID ================= */

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final dx = size.width * i / 10;
      final dy = size.height * i / 10;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ================= ATTACK PATH ================= */

class _AttackPathPainter extends CustomPainter {
  final List<Map<String, dynamic>> honeypots;
  final List<Map<String, dynamic>> attackers;
  final double progress;

  _AttackPathPainter({
    required this.honeypots,
    required this.attackers,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.8)
      ..strokeWidth = 2;

    for (var a in attackers) {
      for (var h in honeypots) {
        final start =
            Offset(size.width * a["x"], size.height * a["y"]);
        final end =
            Offset(size.width * h["x"], size.height * h["y"]);

        final current =
            Offset.lerp(start, end, progress)!;

        canvas.drawLine(start, current, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AttackPathPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
