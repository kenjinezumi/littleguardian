// lib/pages/chat/video_call_page.dart
import 'package:flutter/material.dart';

class VideoCallPage extends StatefulWidget {
  final String callId;   // or any relevant call identifier
  const VideoCallPage({Key? key, required this.callId}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  @override
  void initState() {
    super.initState();
    // Initialize call with Twilio/Agora or WebRTC
  }

  @override
  void dispose() {
    // End/cleanup call
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Call"),
      ),
      body: Center(
        child: Text("Video call with ID: ${widget.callId} (stub)"),
      ),
    );
  }
}
