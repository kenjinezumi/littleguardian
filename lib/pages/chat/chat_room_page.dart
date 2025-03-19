// lib/pages/chat/chat_room_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;
  final String currentUserId;
  final String otherUserId;

  const ChatRoomPage({
    Key? key,
    required this.chatRoomId,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Room")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatProv.subscribeToMessages(widget.chatRoomId),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = snapshot.data!;
                return ListView.builder(
                  itemCount: msgs.length,
                  itemBuilder: (ctx, i) {
                    final m = msgs[i];
                    final isMine = (m.senderId == widget.currentUserId);
                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(8),
                        color: isMine ? Colors.green[100] : Colors.grey[300],
                        child: Text(m.content),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  decoration: const InputDecoration(
                    hintText: "Type message...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final uuid = const Uuid().v4();
    final msg = ChatMessage(
      messageId: uuid,
      chatRoomId: widget.chatRoomId,
      senderId: widget.currentUserId,
      recipientId: widget.otherUserId,
      content: text,
      timestamp: DateTime.now(),
    );
    await Provider.of<ChatProvider>(context, listen: false).sendMessage(msg);
    _msgCtrl.clear();
  }
}
