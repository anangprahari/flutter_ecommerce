import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> messages = [
    ChatMessage(
      message: "Halo, saya ingin melaporkan masalah dengan pesanan saya.",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ChatMessage(
      message: "Selamat siang, saya Admin Jennifer. Ada yang bisa saya bantu?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
    ),
    ChatMessage(
      message:
          "Saya baru saja menerima sepatu yang saya pesan, tapi ukurannya terlalu kecil. Saya pesan ukuran 42 tapi yang datang ukuran 40.",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
    ),
    ChatMessage(
      message:
          "Mohon maaf atas ketidaknyamanannya. Boleh saya minta nomor pesanan Anda untuk saya cek?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 27)),
    ),
    ChatMessage(
      message: "Nomor pesanan saya JNS-789012",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 26)),
    ),
    ChatMessage(
      message:
          "Terima kasih. Saya sudah cek pesanan Anda. Untuk kasus ini, kami menyediakan beberapa solusi:\n\n1. Pengembalian barang dan penggantian dengan ukuran yang benar (gratis ongkir)\n2. Pengembalian dana penuh\n\nMohon pilih solusi yang Anda inginkan.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    ChatMessage(
      message:
          "Saya pilih opsi 1 saja, penggantian dengan ukuran yang benar. Prosesnya bagaimana ya?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
    ),
    ChatMessage(
      message:
          "Baik, saya akan bantu prosesnya. Berikut langkah-langkahnya:\n\n1. Kami akan kirim label pengiriman ke email Anda\n2. Kemas sepatu dengan box original\n3. Tempelkan label dan kirim via JNE\n4. Setelah kami terima, langsung kami proses pengiriman ukuran yang benar\n\nPengiriman akan memakan waktu 2-3 hari kerja. Apakah Anda setuju?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 23)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Column(
          children: [
            const Text(
              'Chat Dengan JenShop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Admin Jennifer',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageBubble(message: message);
                },
              ),
            ),
            Container(
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
                      controller: _messageController,
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
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          setState(() {
                            messages.add(ChatMessage(
                              message: _messageController.text,
                              isUser: true,
                              timestamp: DateTime.now(),
                            ));
                            _messageController.clear();
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        }
                      },
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
