import 'dart:math';
import 'package:flutter/material.dart';
import 'network_details.dart';
import 'widget/threat_alert_banner.dart';

class RadarScanner extends StatefulWidget {
  const RadarScanner({super.key});

  @override
  State<RadarScanner> createState() => _RadarScannerState();
}

class _RadarScannerState extends State<RadarScanner>
    with TickerProviderStateMixin {
  late AnimationController sweepController;
  late AnimationController pulseController;

  bool showThreatAlert = false;

  final List<Map<String, dynamic>> targets = [
    {"ssid": "Cafe_FreeWiFi", "angle": 45.0, "ring": 1, "risk": "HIGH"},
    {"ssid": "Home_Network", "angle": 140.0, "ring": 2, "risk": "LOW"},
    {"ssid": "Airport_FreeWiFi", "angle": 270.0, "ring": 3, "risk": "MEDIUM"},
  ];

  @override
  void initState() {
    super.initState();

    sweepController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();

    pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    sweepController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  void triggerThreatAlert() {
    if (!showThreatAlert) {
      setState(() => showThreatAlert = true);

      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => showThreatAlert = false);
      });
    }
  }

  Color riskColor(String risk) {
    if (risk == "HIGH") return Colors.redAccent;
    if (risk == "MEDIUM") return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  Offset polar(double center, double radius, double angleDeg) {
    final rad = angleDeg * pi / 180;
    return Offset(
      center + radius * cos(rad),
      center + radius * sin(rad),
    );
  }

  bool sweepHits(double sweepAngle, double targetAngle) {
    final diff = (sweepAngle - targetAngle * pi / 180).abs();
    return diff < 0.2;
  }

  @override
  Widget build(BuildContext context) {
    const double size = 320;
    const double center = size / 2;
    const List<double> rings = [60, 100, 140];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: const Text("AI Radar Scan"),
        backgroundColor: const Color(0xFF0B0F1A),
      ),
      body: Stack(
        children: [
          // 🚨 Threat Alert Banner
          if (showThreatAlert)
            ThreatAlertBanner(
              title: "⚠ HIGH RISK NETWORK",
              message:
                  "Guardian AI detected a dangerous Wi-Fi signal nearby.",
              onDismiss: () =>
                  setState(() => showThreatAlert = false),
            ),

          // 🔮 Radar UI
          Center(
            child: AnimatedBuilder(
              animation:
                  Listenable.merge([sweepController, pulseController]),
              builder: (_, __) {
                final sweepAngle =
                    sweepController.value * 2 * pi;

                return SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radar rings
                      for (double r in rings)
                        Container(
                          width: r * 2,
                          height: r * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors.cyanAccent.withOpacity(0.25),
                            ),
                          ),
                        ),

                      // Sweep cone
                      CustomPaint(
                        size: const Size(size, size),
                        painter:
                            RadarSweepPainter(sweepAngle),
                      ),

                      // Targets
                      for (var t in targets)
                        Builder(builder: (_) {
                          final Offset pos = polar(
                            center,
                            rings[t["ring"] - 1],
                            t["angle"],
                          );

                          final bool hit = sweepHits(
                              sweepAngle, t["angle"]);

                          final double glow = hit
                              ? 22
                              : 8 + pulseController.value * 6;

                          return Positioned(
                            left: pos.dx - 6,
                            top: pos.dy - 6,
                            child: GestureDetector(
                              onTap: () {
                                if (t["risk"] == "HIGH") {
                                  triggerThreatAlert();
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        NetworkDetailsScreen(
                                      wifi: {
                                        "ssid": t["ssid"],
                                        "bssid":
                                            "A4:12:BC:22:91:F1",
                                        "security": "OPEN",
                                        "signal": -45,
                                        "risk":
                                            t["risk"] == "HIGH"
                                                ? 85
                                                : 30,
                                        "attacks": const [
                                          "Evil Twin",
                                          "MITM"
                                        ],
                                        "reasons": const [
                                          "Radar sweep anomaly detected",
                                          "Duplicate SSID identified",
                                        ],
                                        "advice":
                                            "Avoid sensitive actions. Use VPN.",
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      riskColor(t["risk"]),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: riskColor(
                                              t["risk"])
                                          .withOpacity(0.9),
                                      blurRadius: glow,
                                      spreadRadius:
                                          hit ? 4 : 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== RADAR SWEEP CONE ===================== */

class RadarSweepPainter extends CustomPainter {
  final double angle;

  RadarSweepPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.45),
          Colors.cyanAccent.withOpacity(0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
          Rect.fromCircle(center: center, radius: radius));

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        angle - 0.35,
        0.7,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RadarSweepPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
