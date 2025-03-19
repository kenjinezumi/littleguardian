// lib/providers/chat_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // In memory list, or rely on streams
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<String> createChatRoom(String userA, String userB) async {
    // ID can be anything, or hash of user IDs
    final chatRoomId = [userA, userB].join("_");
    await _db.collection('chatRooms').doc(chatRoomId).set({
      'participants': [userA, userB],
      'createdAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
    return chatRoomId;
  }

  Future<void> sendMessage(ChatMessage msg) async {
    final docRef = _db
        .collection('chatRooms')
        .doc(msg.chatRoomId)
        .collection('messages')
        .doc(msg.messageId);
    await docRef.set(msg.toMap());
  }

  Stream<List<ChatMessage>> subscribeToMessages(String chatRoomId) {
    return _db
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
