class AttackDetection {
  List<Map<String, dynamic>> detectThreats(List<Map<String, dynamic>> wifiList) {
    List<Map<String, dynamic>> threats = [];

    // Group networks by SSID
    Map<String, List<Map<String, dynamic>>> ssidGroups = {};

    for (var wifi in wifiList) {
      ssidGroups.putIfAbsent(wifi['ssid'], () => []);
      ssidGroups[wifi['ssid']]!.add(wifi);
    }

    // Detect Evil Twin (Same SSID, multiple BSSIDs)
    ssidGroups.forEach((ssid, networks) {
      if (networks.length > 1) {
        threats.add({
          "ssid": ssid,
          "type": "EVIL_TWIN",
          "details": "Multiple networks found using SSID '$ssid'"
        });
      }
    });

    // Detect Rogue AP (Suspiciously strong RSSI)
    for (var wifi in wifiList) {
      if (wifi['rssi'] > -40) {
        threats.add({
          "ssid": wifi['ssid'],
          "type": "ROGUE_AP",
          "details": "Signal too strong – AP may be a fake hotspot"
        });
      }
    }

    return threats;
  }
}
