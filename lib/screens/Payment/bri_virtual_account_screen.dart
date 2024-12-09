import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants.dart';

// Widget utama untuk layar akun virtual BRI
class BRIVirtualAccountScreen extends StatefulWidget {
  // Parameter yang dibutuhkan untuk membuat layar
  final double amount; // Jumlah pembayaran
  final String orderNumber; // Nomor pesanan
  final VoidCallback onSuccess; // Callback ketika pembayaran berhasil

  const BRIVirtualAccountScreen({
    Key? key,
    required this.amount,
    required this.orderNumber,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<BRIVirtualAccountScreen> createState() =>
      _BRIVirtualAccountScreenState();
}

// State untuk layar akun virtual BRI
class _BRIVirtualAccountScreenState extends State<BRIVirtualAccountScreen> {
  // Variabel untuk mengatur ekspansi instruksi
  bool isExpanded = false;
  
  // Nomor virtual account BRI
  final String vaNumber = "8077 7000 1282 4775";
  
  // Instance Firestore untuk pencatatan transaksi
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Instance Firebase Messaging untuk notifikasi
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // Catat transaksi saat layar pertama kali dimuat
    _logTransaction();
  }

  // Fungsi untuk mencatat transaksi ke Firestore
  Future<void> _logTransaction() async {
    try {
      await firestore.collection('transactions').add({
        'orderNumber': widget.orderNumber,
        'amount': widget.amount,
        'vaNumber': vaNumber,
        'status': 'pending', // Status awal transaksi
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Transaksi berhasil dicatat!");
    } catch (e) {
      debugPrint("Gagal mencatat transaksi: $e");
    }
  }

  // Fungsi untuk mengirim notifikasi pembayaran
  Future<void> _sendPaymentNotification() async {
    try {
      await messaging.sendMessage(
        to: '/topics/payments', // Topik untuk notifikasi pembayaran
        data: {
          'orderNumber': widget.orderNumber,
          'amount': widget.amount.toString(),
          'status': 'completed',
        },
      );
      debugPrint("Notifikasi pembayaran terkirim!");
    } catch (e) {
      debugPrint("Gagal mengirim notifikasi pembayaran: $e");
    }
  }

  // Fungsi untuk memformat mata uang dalam Rupiah
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Menggunakan format Indonesia
      symbol: 'Rp ',
      decimalDigits: 0, // Tanpa digit desimal
    );
    return formatter.format(amount);
  }

  // Fungsi untuk mendapatkan batas waktu pembayaran
  String getPaymentDeadline() {
    // Tambahkan 24 jam dari waktu sekarang
    final deadline = DateTime.now().add(const Duration(hours: 24));
    return DateFormat('HH:mm, d MMM yyyy').format(deadline);
  }

  // Fungsi untuk menyalin nomor VA ke clipboard
  void _copyVANumber() {
    Clipboard.setData(ClipboardData(text: vaNumber));
    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Nomor VA berhasil disalin'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );

    // Simulasi pembayaran berhasil setelah 10 detik
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _markPaymentSuccess();
      }
    });
  }

  // Fungsi untuk menandai pembayaran sebagai berhasil
  Future<void> _markPaymentSuccess() async {
    try {
      // Cari dokumen transaksi dengan nomor pesanan yang sesuai
      await firestore
          .collection('transactions')
          .where('orderNumber', isEqualTo: widget.orderNumber)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          // Update status transaksi menjadi 'completed'
          doc.reference.update({'status': 'completed'});
        }
      });

      // Kirim notifikasi pembayaran
      _sendPaymentNotification();

      // Tampilkan snackbar konfirmasi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Pembayaran berhasil'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Gagal menandai pembayaran berhasil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Struktur utama layar pembayaran
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // App bar dengan judul dan ID pesanan
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menunggu Pembayaran',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ID Pesanan: ${widget.orderNumber}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Body dengan scroll view
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAmountSection(), // Bagian jumlah pembayaran
            const SizedBox(height: 8),
            _buildVirtualAccountSection(), // Bagian nomor virtual account
            const SizedBox(height: 8),
            _buildPaymentInstructions(), // Bagian instruksi pembayaran
            const SizedBox(height: 16),
            _buildSupportSection(), // Bagian dukungan pelanggan
          ],
        ),
      ),
      // Bottom navigation bar dengan tombol aksi
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Widget untuk menampilkan section jumlah pembayaran
  Widget _buildAmountSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatCurrency(widget.amount),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kprimaryColor,
                    ),
                  ),
                ],
              ),
              // Penanda waktu pembayaran
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      getPaymentDeadline(),
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan section nomor virtual account
  Widget _buildVirtualAccountSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan logo bank
          Row(
            children: [
              Image.asset(
                'images/icon/bri.png',
                height: 40,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank BRI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Akun Virtual',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Container dengan detail nomor virtual account
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor Rekening Virtual',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vaNumber,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    // Tombol salin nomor VA
                    InkWell(
                      onTap: _copyVANumber,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kprimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.copy,
                              size: 16,
                              color: kprimaryColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Salin',
                              style: TextStyle(
                                color: kprimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan section instruksi pembayaran
  Widget _buildPaymentInstructions() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Ekspansi tile untuk instruksi pembayaran melalui ATM
          _buildInstructionExpansionTile(
            'ATM BRI',
            [
              'Masukkan Kartu ATM & PIN',
              'Pilih menu Transaksi Lain',
              'Pilih menu Pembayaran',
              'Pilih menu Lainnya',
              'Pilih BRIVA',
              'Masukkan Nomor Virtual Account',
              'Periksa informasi yang tertera di layar',
              'Pilih Ya untuk melakukan pembayaran',
            ],
            Icons.atm,
          ),
          // Ekspansi tile untuk instruksi pembayaran melalui Mobile Banking
          _buildInstructionExpansionTile(
            'Mobile Banking BRI',
            [
              'Login ke aplikasi BRI Mobile',
              'Pilih menu Mobile Banking BRI',
              'Pilih menu Pembayaran',
              'Pilih menu BRIVA',
              'Masukkan Nomor Virtual Account',
              'Masukkan PIN',
              'Periksa informasi yang tertera di layar',
              'Pilih Ya untuk melakukan pembayaran',
            ],
            Icons.phone_android,
          ),
          // Ekspansi tile untuk instruksi pembayaran melalui Internet Banking
          _buildInstructionExpansionTile(
            'Internet Banking BRI',
            [
              'Login ke Internet Banking BRI',
              'Pilih menu Pembayaran',
              'Pilih menu BRIVA',
              'Masukkan Nomor Virtual Account',
              'Periksa informasi yang tertera di layar',
              'Masukkan password dan mToken',
              'Pembayaran selesai',
            ],
            Icons.computer,
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat ekspansi tile dengan instruksi pembayaran
  Widget _buildInstructionExpansionTile(
      String title, List<String> steps, IconData icon) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        // Widget ExpansionTile untuk menampilkan instruksi yang dapat diperluas
        child: ExpansionTile(
          // Ikon leading untuk setiap metode pembayaran
          leading: Icon(icon, color: kprimaryColor),
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // Judul metode pembayaran
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            // Konten yang akan ditampilkan saat tile diperluas
            Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Penomoran langkah dengan desain bulat
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kprimaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: kprimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Teks instruksi untuk setiap langkah
                        Expanded(
                          child: Text(
                            steps[index],
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan section dukungan pelanggan
  Widget _buildSupportSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul section dukungan
          Text(
            'Butuh Bantuan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          // Baris dengan ikon headset dan teks layanan pelanggan
          Row(
            children: [
              Icon(Icons.headset_mic, color: kprimaryColor),
              SizedBox(width: 8),
              Text(
                'Layanan Pelanggan 24/7',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Nomor telepon layanan pelanggan
          Text(
            '1500017',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kprimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun bottom bar dengan tombol aksi
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      // Dekorasi container dengan shadow ringan
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tombol untuk melihat pesanan dengan full width
          Expanded(
            child: ElevatedButton(
              // Gaya tombol dengan warna primer
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Panggil callback onSuccess saat tombol ditekan
              onPressed: widget.onSuccess,
              child: Text(
                'Lihat Pesanan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
