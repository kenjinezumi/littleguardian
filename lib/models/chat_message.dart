// lib/models/message.dart
/// For in-app chat between parent <-> babysitter
class ChatMessage {
  final String messageId;
  final String chatRoomId;
  final String senderId;
  final String recipientId;
  final String content;
  final DateTime timestamp;
  final bool isImage;
  final bool isVideo;

  ChatMessage({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    this.isImage = false,
    this.isVideo = false,
  });

  factory ChatMessage.fromMap(String id, Map<String, dynamic> data) {
    return ChatMessage(
      messageId: id,
      chatRoomId: data['chatRoomId'] ?? '',
      senderId: data['senderId'] ?? '',
      recipientId: data['recipientId'] ?? '',
      content: data['content'] ?? '',
      timestamp: DateTime.parse(data['timestamp']),
      isImage: data['isImage'] ?? false,
      isVideo: data['isVideo'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'recipientId': recipientId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isImage': isImage,
      'isVideo': isVideo,
    };
  }
}
