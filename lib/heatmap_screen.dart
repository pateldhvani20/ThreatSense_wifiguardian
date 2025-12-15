import 'package:flutter/material.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  // Fake AI-generated hotspot data (demo-safe)
  final List<Map<String, dynamic>> hotspots = const [
    {"x": 0.3, "y": 0.4, "risk": 80},
    {"x": 0.6, "y": 0.5, "risk": 60},
    {"x": 0.4, "y": 0.7, "risk": 30},
    {"x": 0.7, "y": 0.3, "risk": 90},
  ];

  Color riskColor(int risk) {
    if (risk >= 70) return Colors.redAccent;
    if (risk >= 40) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: const Text("AI Wi-Fi Risk Heatmap"),
        backgroundColor: const Color(0xFF0B0F1A),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;

              return Stack(
                children: [
                  // Grid background
                  CustomPaint(
                    size: size,
                    painter: GridPainter(),
                  ),

                  // Heat spots
                  for (var h in hotspots)
                    Positioned(
                      left: size.width * h["x"] - 30,
                      top: size.height * h["y"] - 30,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              riskColor(h["risk"]).withOpacity(0.7),
                              riskColor(h["risk"]).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Legend
                  const Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LegendDot(color: Colors.redAccent, label: "High Risk"),
                        LegendDot(color: Colors.orangeAccent, label: "Medium Risk"),
                        LegendDot(color: Colors.greenAccent, label: "Low Risk"),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ================= GRID ================= */

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;

    const int divisions = 8;

    for (int i = 1; i < divisions; i++) {
      final dx = size.width * i / divisions;
      final dy = size.height * i / divisions;

      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/* ================= LEGEND ================= */

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
