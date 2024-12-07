import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_mobile_app/constants.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String senderId;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.senderId,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      message: data['message'] ?? '',
      isUser: data['senderId'] == FirebaseAuth.instance.currentUser?.uid,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ChatAutoReplyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expanded and more context-aware auto-reply dictionary
  final Map<String, String> _autoReplies = {
    'halo': 'Halo! Ada yang bisa kami bantu?',
    'komplain': 'Mohon maaf atas ketidaknyamanan Anda. Bisa tolong jelaskan masalahnya?',
    'pesanan': 'Bisa konfirmasi nomor pesanan Anda?',
    'ukuran': 'Kami akan segera membantu Anda dengan masalah ukuran.',
    'pengiriman': 'Informasi pengiriman sedang kami proses. Mohon tunggu sebentar.',
  };

  Future<void> sendAutoReply(String chatDocId, String userMessage) async {
    String lowercaseMessage = userMessage.toLowerCase();
    String? replyKey = _findAutoReplyKey(lowercaseMessage);

    if (replyKey != null) {
      String adminId = 'admin_jenshop';

      await _firestore
          .collection('chats')
          .doc(chatDocId)
          .collection('messages')
          .add(ChatMessage(
            message: _autoReplies[replyKey]!,
            isUser: false,
            timestamp: DateTime.now(),
            senderId: adminId,
          ).toFirestore());
    }
  }

  String? _findAutoReplyKey(String message) {
    for (var key in _autoReplies.keys) {
      if (message.contains(key)) {
        return key;
      }
    }
    return null;
  }
}

class ChatScreen extends StatefulWidget {
  final String? orderNumber;
  const ChatScreen({Key? key, this.orderNumber}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messagesStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatAutoReplyService _autoReplyService = ChatAutoReplyService();

  @override
  void initState() {
    super.initState();
    _initializeMessagesStream();
  }

  void _initializeMessagesStream() {
    String chatDocId = widget.orderNumber ?? 'general_support';
    _messagesStream = _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    String chatDocId = widget.orderNumber ?? 'general_support';

    await _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .add(ChatMessage(
          message: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
          senderId: currentUser.uid,
        ).toFirestore());

    await _autoReplyService.sendAutoReply(chatDocId, _messageController.text);

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Column(
          children: [
            Text(
              'Chat Dengan JenShop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Admin Anang Prahari Fernando',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Belum ada pesan'));
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          ChatInputArea(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatInputArea extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;

  const ChatInputArea({
    Key? key,
    required this.messageController,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
            color: kprimaryColor,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Tulis pesan...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: kprimaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSendMessage,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: message.isUser ? kprimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}