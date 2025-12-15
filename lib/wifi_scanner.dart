import 'package:flutter/material.dart';
import 'risk_engine.dart';
import 'attack_detection.dart';
import 'security_report.dart';
import 'widget/glass_card.dart';   // ✅ correct

class WifiScannerScreen extends StatelessWidget {
  const WifiScannerScreen({super.key});

  final List<Map<String, dynamic>> dummyWifiList = const [
    {
      'ssid': 'Cafe_FreeWiFi',
      'bssid': 'A4:12:BC:22:91:F1',
      'rssi': -55,
      'security': 'WPA2'
    },
    {
      'ssid': 'Airport_Free_WiFi',
      'bssid': '8C:19:FA:11:22:33',
      'rssi': -42,
      'security': 'OPEN'
    },
    {
      'ssid': 'Home_Network',
      'bssid': 'D4:16:AA:99:12:55',
      'rssi': -85,
      'security': 'WPA3'
    },
    {
      'ssid': 'Cafe_FreeWiFi',
      'bssid': 'AA:BB:CC:11:22:33',
      'rssi': -48,
      'security': 'WPA2'
    },
  ];

  Color _severityColor(String lvl) {
    switch (lvl) {
      case "HIGH":
        return Colors.redAccent;
      case "MEDIUM":
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  IconData _severityIcon(String lvl) {
    switch (lvl) {
      case "HIGH":
        return Icons.error;
      case "MEDIUM":
        return Icons.warning_amber;
      default:
        return Icons.check_circle;
    }
  }

  Widget _buildVerdictCard(Map<String, dynamic> verdict) {
    final level = verdict['level'];
    final score = verdict['adjusted_score'];
    final reasons = verdict['reasons'] as List;
    final recommendation = verdict['recommendation'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GlassCard(
        borderColor: _severityColor(level),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_severityIcon(level), color: _severityColor(level), size: 28),
                const SizedBox(width: 10),
                Text(
                  "Final Verdict: $level",
                  style: TextStyle(
                      color: _severityColor(level),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "$score/100",
                  style: TextStyle(
                      color: _severityColor(level),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Why: ${reasons.join(" · ")}",
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),

            Text(
              "Recommendation: $recommendation",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final threats = AttackDetection().detectThreats(dummyWifiList);

    return Scaffold(
      backgroundColor: const Color(0xff0f0f1a),
      appBar: AppBar(
        title: const Text("Wi-Fi Scanner"),
        backgroundColor: Colors.deepPurple,
      ),

      body: ListView(
        children: [
          if (threats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GlassCard(
                borderColor: Colors.redAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("⚠ Threats Detected:",
                        style: TextStyle(fontSize: 18, color: Colors.redAccent)),
                    const SizedBox(height: 10),
                    for (var t in threats)
                      Text(
                        "• ${t['type']} — ${t['details']}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),

          ...dummyWifiList.map((wifi) {
            final risk = RiskEngine().calculateRisk(
              ssid: wifi['ssid'],
              bssid: wifi['bssid'],
              rssi: wifi['rssi'],
              security: wifi['security'],
            );

            final report =
                SecurityReport.create(wifi: wifi, allWifi: dummyWifiList);
            final verdict = report.finalVerdict();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GlassCard(
                    borderColor: _severityColor(verdict['level']),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wifi['ssid'],
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text("BSSID: ${wifi['bssid']}",
                            style: const TextStyle(color: Colors.white70)),
                        Text("Signal: ${wifi['rssi']} dBm",
                            style: const TextStyle(color: Colors.white70)),
                        Text("Security: ${wifi['security']}",
                            style: const TextStyle(color: Colors.white70)),
                        Text("Base Risk: ${risk['risk_level']} (${risk['score']})",
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),

                _buildVerdictCard(verdict),
              ],
            );
          }),
        ],
      ),
    );
  }
}
