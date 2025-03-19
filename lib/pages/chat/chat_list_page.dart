// lib/pages/chat/chat_list_page.dart
import 'package:flutter/material.dart';
// This page would display a list of chat rooms or recent contacts

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Typically, you'd fetch the user's chat rooms from Firestore
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: ListView.builder(
        itemCount: 5, // example
        itemBuilder: (ctx, i) {
          return ListTile(
            title: Text("Chat Room $i"),
            onTap: () {
              // Navigate to chat_room_page.dart
            },
          );
        },
      ),
    );
  }
}
