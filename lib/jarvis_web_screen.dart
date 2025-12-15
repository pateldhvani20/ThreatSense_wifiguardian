import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JarvisWebScreen extends StatefulWidget {
  const JarvisWebScreen({super.key});

  @override
  State<JarvisWebScreen> createState() => _JarvisWebScreenState();
}

class _JarvisWebScreenState extends State<JarvisWebScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'JarvisChannel',
        onMessageReceived: (message) {
          Navigator.pop(context, message.message);
        },
      )
      ..loadFlutterAsset('assets/jarvis/jarvis_html.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebViewWidget(controller: _controller),
    );
  }
}
