import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Model untuk pesan chat, menyimpan detail pesan seperti isi pesan, pengirim, waktu, dll
class ChatMessage {
  final String message; // Isi pesan
  final bool isUser; // Apakah pesan dari pengguna
  final DateTime timestamp; // Waktu pengiriman pesan
  final String senderId; // ID pengirim pesan

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.senderId,
  });

  // Membuat objek ChatMessage dari dokumen Firestore
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      message: data['message'] ?? '',
      // Memeriksa apakah pesan dari pengguna saat ini
      isUser: data['senderId'] == FirebaseAuth.instance.currentUser?.uid,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
    );
  }

  // Mengonversi objek ChatMessage menjadi map untuk disimpan di Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

// Layanan untuk mengirim balasan otomatis dalam chat
class ChatAutoReplyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kamus balasan otomatis berdasarkan kata kunci
  final Map<String, String> _autoReplies = {
    'halo': 'Halo! Ada yang bisa kami bantu?',
    'komplain':
        'Mohon maaf atas ketidaknyamanan Anda. Bisa tolong jelaskan masalahnya?',
    'pesanan': 'Bisa konfirmasi nomor pesanan Anda?',
    'ukuran': 'Kami akan segera membantu Anda dengan masalah ukuran.',
    'pengiriman':
        'Informasi pengiriman sedang kami proses. Mohon tunggu sebentar.',
  };

  // Mengirim balasan otomatis berdasarkan pesan pengguna
  Future<void> sendAutoReply(String chatDocId, String userMessage) async {
    String lowercaseMessage = userMessage.toLowerCase();
    String? replyKey = _findAutoReplyKey(lowercaseMessage);

    if (replyKey != null) {
      String adminId = 'admin_jenshop';

      // Menambahkan pesan balasan otomatis ke Firestore
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

  // Mencari kata kunci yang cocok untuk balasan otomatis
  String? _findAutoReplyKey(String message) {
    for (var key in _autoReplies.keys) {
      if (message.contains(key)) {
        return key;
      }
    }
    return null;
  }
}

// Widget layar utama chat
class ChatScreen extends StatefulWidget {
  final String? orderNumber;
  const ChatScreen({Key? key, this.orderNumber}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Pengontrol untuk input teks pesan
  final TextEditingController _messageController = TextEditingController();

  // Pengontrol untuk scroll layar chat
  final ScrollController _scrollController = ScrollController();

  // Stream untuk memuat pesan dari Firestore
  late Stream<QuerySnapshot> _messagesStream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Layanan balasan otomatis
  final ChatAutoReplyService _autoReplyService = ChatAutoReplyService();

  @override
  void initState() {
    super.initState();
    // Inisialisasi stream pesan saat widget pertama kali dibuat
    _initializeMessagesStream();
  }

  // Menyiapkan stream untuk memuat pesan dari Firestore
  void _initializeMessagesStream() {
    // Menggunakan nomor pesanan atau dukungan umum sebagai ID dokumen
    String chatDocId = widget.orderNumber ?? 'general_support';
    _messagesStream = _firestore
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Mengirim pesan baru
  void _sendMessage() async {
    // Cek apakah pesan kosong
    if (_messageController.text.trim().isEmpty) return;

    // Periksa apakah pengguna sudah login
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    // Tentukan ID dokumen chat
    String chatDocId = widget.orderNumber ?? 'general_support';

    // Tambahkan pesan ke Firestore
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

    // Kirim balasan otomatis
    await _autoReplyService.sendAutoReply(chatDocId, _messageController.text);

    // Bersihkan input teks
    _messageController.clear();

    // Gulir ke bawah layar
    _scrollToBottom();
  }

  // Menggulung layar chat ke bagian bawah
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
      // App bar dengan judul dan detail kontak admin
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
          // Daftar pesan yang di-streaming dari Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                // Tampilkan indikator loading saat memuat
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Tampilkan pesan jika tidak ada pesan
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Belum ada pesan'));
                }

                // Konversi dokumen menjadi objek ChatMessage
                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                // Tampilkan daftar pesan
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
          // Area input pesan
          ChatInputArea(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// Widget untuk area input pesan
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
      // Dekorasi container input pesan
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
          // Tombol lampirkan file (belum diimplementasikan)
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {},
            color: kprimaryColor,
          ),
          // TextField untuk menulis pesan
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
          // Tombol kirim pesan
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

// Widget untuk menampilkan gelembung pesan
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      // Posisi pesan berbeda untuk pesan pengguna dan admin
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // Batasi lebar maksimum pesan
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          // Atur posisi cross-axis berdasarkan pengirim pesan
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Gelembung pesan
            Container(
              decoration: BoxDecoration(
                // Warna berbeda untuk pesan pengguna dan admin
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
                  // Warna teks berbeda untuk pesan pengguna dan admin
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Tampilkan waktu pengiriman pesan
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
