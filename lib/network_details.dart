import 'package:flutter/material.dart';

class NetworkDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> wifi;

  const NetworkDetailsScreen({super.key, required this.wifi});

  Color riskColor(int score) {
    if (score >= 70) return Colors.redAccent;
    if (score >= 40) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  String riskLabel(int score) {
    if (score >= 70) return "HIGH RISK";
    if (score >= 40) return "MEDIUM RISK";
    return "LOW RISK";
  }

  @override
  Widget build(BuildContext context) {
    final int riskScore = wifi['risk'];
    final Color color = riskColor(riskScore);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      appBar: AppBar(
        title: const Text("AI Network Analysis"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔮 Risk Meter
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(150),
                      blurRadius: 30,
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$riskScore%",
                        style: TextStyle(
                          color: color,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        riskLabel(riskScore),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 📡 Network Info
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wifi['ssid'],
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("BSSID: ${wifi['bssid']}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Security: ${wifi['security']}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Signal: ${wifi['signal']} dBm",
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🧠 AI Explanation
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Guardian AI Explanation",
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (String reason in wifi['reasons'])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        "• $reason",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🚨 Attack Tags
            Wrap(
              spacing: 10,
              children: wifi['attacks'].map<Widget>((a) {
                return Chip(
                  label: Text(a),
                  backgroundColor: Colors.redAccent.withAlpha(40),
                  labelStyle: const TextStyle(color: Colors.redAccent),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // ✅ Recommendation
            _glassCard(
              borderColor: color,
              child: Row(
                children: [
                  Icon(Icons.security, color: color, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      wifi['advice'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _glassCard(
      {required Widget child, Color borderColor = Colors.white24}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
