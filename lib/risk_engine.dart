class RiskEngine {
  Map<String, dynamic> calculateRisk({
    required String ssid,
    required String bssid,
    required int rssi,
    required String security,
  }) {
    int score = 0;
    List<String> reasons = [];

    if (security.contains("OPEN")) {
      score += 40;
      reasons.add("Open network – no encryption");
    } else if (security.contains("WEP")) {
      score += 35;
      reasons.add("Weak encryption (WEP)");
    } else if (security.contains("WPA") &&
        !security.contains("WPA2") &&
        !security.contains("WPA3")) {
      score += 10;
      reasons.add("Older encryption (WPA)");
    }

    if (rssi > -40) {
      score += 10;
      reasons.add("Suspiciously strong signal – possible rogue AP");
    }

    if (rssi < -80) {
      score += 5;
      reasons.add("Very weak signal");
    }

    String level = "SAFE";
    if (score >= 60) {
      level = "DANGEROUS";
    } else if (score >= 30) level = "MEDIUM";

    return {
      "ssid": ssid,
      "score": score,
      "risk_level": level,
      "reasons": reasons,
    };
  }
}
