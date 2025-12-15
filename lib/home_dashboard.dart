import 'package:flutter/material.dart';
import 'radar_scanner.dart';
import 'heatmap_screen.dart';
import 'honeypot_screen.dart';
import 'guardian_ai_chat.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),

      // 🎤 JARVIS MIC BUTTON (VOICE ROUTING ENABLED)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        child: const Icon(Icons.mic, color: Colors.black),
        onPressed: () async {
          final command = await GuardianAI.listenForCommand();

          if (!context.mounted) return;

          switch (command) {
            case GuardianCommand.radar:
              GuardianAI.speak("Opening radar scan.");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RadarScanner(),
                ),
              );
              break;

            case GuardianCommand.heatmap:
              GuardianAI.speak("Opening Wi-Fi risk heatmap.");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HeatmapScreen(),
                ),
              );
              break;

            case GuardianCommand.honeypot:
              GuardianAI.speak("Deploying honeypot trap.");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HoneypotScreen(),
                ),
              );
              break;

            case GuardianCommand.unknown:
              GuardianAI.speak(
                "Sorry. I did not understand. Please say Radar, Heatmap, or Honeypot."
              );
              break;
          }
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔐 APP TITLE
              const Text(
                "CYBER TITAN AI",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "AI-Powered Wi-Fi Defense System",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // 🛡️ RADAR SCAN
              DashboardCard(
                icon: Icons.radar,
                title: "AI Radar Scan",
                subtitle:
                    "Detect Evil Twin, MITM & rogue Wi-Fi attacks",
                color: Colors.cyanAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RadarScanner(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🗺️ HEATMAP
              DashboardCard(
                icon: Icons.map,
                title: "Wi-Fi Risk Heatmap",
                subtitle:
                    "Visualize high-risk Wi-Fi zones using AI",
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HeatmapScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🐝 HONEYPOT TRAP
              DashboardCard(
                icon: Icons.bug_report,
                title: "AI Honeypot Trap",
                subtitle:
                    "Deploy decoy Wi-Fi traps to catch attackers",
                color: Colors.purpleAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HoneypotScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // 🤖 AI STATUS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.4),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.smart_toy,
                      color: Colors.cyanAccent,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Guardian AI is actively monitoring nearby networks and traps.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= DASHBOARD CARD ================= */

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.25),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
