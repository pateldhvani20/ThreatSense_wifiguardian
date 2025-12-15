import 'risk_engine.dart';
import 'attack_detection.dart';

class SecurityReport {
  final Map<String, dynamic> wifi;
  final Map<String, dynamic> risk;
  final List<Map<String, dynamic>> threats;

  SecurityReport._({
    required this.wifi,
    required this.risk,
    required this.threats,
  });

  factory SecurityReport.create({
    required Map<String, dynamic> wifi,
    required List<Map<String, dynamic>> allWifi,
  }) {
    final risk = RiskEngine().calculateRisk(
      ssid: wifi['ssid'],
      bssid: wifi['bssid'],
      rssi: wifi['rssi'],
      security: wifi['security'],
    );

    final detected = AttackDetection().detectThreats(allWifi);

    final relevant =
        detected.where((t) => t['ssid'] == wifi['ssid']).toList();

    return SecurityReport._(
      wifi: wifi,
      risk: risk,
      threats: relevant,
    );
  }

  Map<String, dynamic> finalVerdict() {
    int score = risk['score'];
    int adjusted = score;

    if (threats.any((t) => t['type'] == "EVIL TWIN")) adjusted += 30;
    if (threats.any((t) => t['type'] == "ROGUE AP")) adjusted += 15;

    if (adjusted > 100) adjusted = 100;

    String level = "LOW";
    if (adjusted >= 70) {
      level = "HIGH";
    } else if (adjusted >= 40) level = "MEDIUM";

    List<String> reasons = [...risk['reasons']];
    for (var t in threats) {
      reasons.add("${t['type']}: ${t['details']}");
    }

    String recommendation = "Safe for general browsing.";
    if (level == "MEDIUM") {
      recommendation =
          "Avoid sensitive activities. Use VPN.";
    } else if (level == "HIGH") {
      recommendation =
          "Disconnect immediately. Do NOT enter passwords.";
    }

    return {
      "adjusted_score": adjusted,
      "level": level,
      "reasons": reasons,
      "recommendation": recommendation,
    };
  }
}
