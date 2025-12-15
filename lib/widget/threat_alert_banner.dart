import 'package:flutter/material.dart';

class ThreatAlertBanner extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;

  const ThreatAlertBanner({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  @override
  State<ThreatAlertBanner> createState() => _ThreatAlertBannerState();
}

class _ThreatAlertBannerState extends State<ThreatAlertBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withAlpha(220),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withAlpha(160),
              blurRadius: 30,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.message,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: widget.onDismiss,
            )
          ],
        ),
      ),
    );
  }
}
