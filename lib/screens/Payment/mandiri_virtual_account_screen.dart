import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants.dart';

// Widget StatefulWidget untuk layar pembayaran virtual account Mandiri
class MandiriVirtualAccountScreen extends StatefulWidget {
  // Parameter yang diperlukan untuk inisialisasi layar
  final double amount; // Jumlah pembayaran
  final String orderNumber; // Nomor pesanan
  final VoidCallback onSuccess; // Callback saat pembayaran berhasil

  const MandiriVirtualAccountScreen({
    Key? key,
    required this.amount,
    required this.orderNumber,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<MandiriVirtualAccountScreen> createState() =>
      _MandiriVirtualAccountScreenState();
}

// State dari MandiriVirtualAccountScreen
class _MandiriVirtualAccountScreenState
    extends State<MandiriVirtualAccountScreen> {
  // Variabel untuk mengatur ekspansi instruksi pembayaran
  bool isExpanded = false;
  
  // Nomor virtual account yang statis
  final vaNumber = "8810 7000 1234 5678";
  
  // Inisialisasi instance Firestore dan Firebase Messaging
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // Mencatat transaksi saat layar pertama kali dimuat
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
        'timestamp': FieldValue.serverTimestamp(), // Waktu server
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
        to: '/topics/payments', // Topik untuk pembayaran
        data: {
          'orderNumber': widget.orderNumber,
          'amount': widget.amount.toString(),
          'status': 'completed', // Status pembayaran selesai
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
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Fungsi untuk mendapatkan batas waktu pembayaran (24 jam dari sekarang)
  String getPaymentDeadline() {
    final deadline = DateTime.now().add(Duration(hours: 24));
    return DateFormat('HH:mm, d MMM yyyy').format(deadline);
  }

  // Fungsi untuk menyalin nomor virtual account
  void _copyVANumber() {
    // Menyalin nomor VA ke clipboard
    Clipboard.setData(ClipboardData(text: vaNumber));
    
    // Menampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Nomor VA berhasil disalin'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 1),
      ),
    );

    // Simulasi pembayaran berhasil setelah 10 detik
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        _markPaymentSuccess();
      }
    });
  }

  // Fungsi untuk menandai pembayaran sebagai berhasil
  Future<void> _markPaymentSuccess() async {
    try {
      // Memperbarui status transaksi di Firestore
      await firestore
          .collection('transactions')
          .where('orderNumber', isEqualTo: widget.orderNumber)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'status': 'completed'});
        }
      });

      // Mengirim notifikasi pembayaran
      _sendPaymentNotification();

      // Menampilkan snackbar konfirmasi pembayaran berhasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Pembayaran berhasil'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Gagal menandai pembayaran berhasil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membangun struktur utama layar pembayaran
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      // AppBar dengan judul dan informasi pesanan
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menunggu Pembayaran',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ID Pesanan: ${widget.orderNumber}',
              style: TextStyle(
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
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Body dengan scroll view yang berisi berbagai bagian informasi
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAmountSection(), // Bagian jumlah pembayaran
            SizedBox(height: 8),
            _buildVirtualAccountSection(), // Bagian nomor virtual account
            SizedBox(height: 8),
            _buildPaymentInstructions(), // Bagian instruksi pembayaran
            SizedBox(height: 16),
            _buildSupportSection(), // Bagian dukungan
          ],
        ),
      ),
      // Bottom bar dengan tombol aksi
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Widget untuk menampilkan bagian jumlah pembayaran
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
                    formatCurrency(widget.amount), // Memformat jumlah dalam Rupiah
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kprimaryColor, // Warna biru Mandiri
                    ),
                  ),
                ],
              ),
              // Penghitung waktu pembayaran
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
                      getPaymentDeadline(), // Mendapatkan batas waktu pembayaran
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

  // Widget untuk menampilkan bagian virtual account
  Widget _buildVirtualAccountSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian header dengan logo dan nama bank
          Row(
            children: [
              Image.asset(
                'images/icon/mandiri.png',
                height: 40,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Mandiri',
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
          // Container untuk menampilkan nomor virtual account
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
                // Baris untuk nomor VA dan tombol salin
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
                    InkWell(
                      onTap: _copyVANumber, // Fungsi salin nomor VA
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

  // Widget untuk menampilkan instruksi pembayaran
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
          // Expansion tile untuk berbagai metode pembayaran
          _buildInstructionExpansionTile(
            'Internet Banking Mandiri',
            [
              'Login ke Mandiri Online',
              'Pilih menu Pembayaran',
              'Pilih menu Multipayment',
              'Pilih penyedia jasa "JenShop"',
              'Masukkan Nomor Virtual Account dan nominal, lalu pilih Lanjut',
              'Setelah muncul tagihan, pilih Konfirmasi',
              'Masukkan PIN atau challenge code token',
              'Simpan bukti bayar',
            ],
            Icons.computer,
          ),
          _buildInstructionExpansionTile(
            'ATM Mandiri',
            [
              'Masukkan kartu ATM dan PIN',
              'Pilih Menu Bayar/Beli',
              'Pilih menu Lainnya hingga menemukan Multipayment',
              'Masukkan kode biller JenShop 88708, pilih Benar',
              'Masukkan Nomor Rekening Virtual JenShop, pilih Benar',
              'Masukkan 1 untuk memilih tagihan, pilih Ya',
              'Lakukan konfirmasi pembayaran, lalu pilih Ya',
              'Simpan struk sebagai bukti pembayaran',
            ],
            Icons.atm,
          ),
          _buildInstructionExpansionTile(
            'Livin by Mandiri',
            [
              'Login ke aplikasi Livin by Mandiri',
              'Pilih menu Pembayaran',
              'Pilih kategori Multipayment',
              'Pilih penyedia jasa JenShop',
              'Masukkan Nomor Rekening Virtual',
              'Konfirmasi detail pembayaran',
              'Masukkan PIN Livin',
              'Simpan bukti pembayaran',
            ],
            Icons.phone_android,
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat expansion tile instruksi pembayaran
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
        // Menghilangkan garis pembatas default pada expansion tile
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading:
              Icon(icon, color: kprimaryColor), // Ikon di sebelah kiri judul
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            // Daftar langkah-langkah instruksi
            Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true, // Mengatur ukuran list sesuai konten
                physics:
                    NeverScrollableScrollPhysics(), // Mencegah scroll dalam list
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
                        // Teks langkah instruksi
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

  // Widget untuk menampilkan bagian dukungan/bantuan
  Widget _buildSupportSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Butuh Bantuan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          // Baris dengan ikon headset dan teks panggilan
          Row(
            children: [
              Icon(Icons.headset_mic, color: kprimaryColor),
              SizedBox(width: 8),
              Text(
                'Panggilan Mandiri',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Nomor kontak bantuan
          Text(
            '14000',
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
      decoration: BoxDecoration(
        color: Colors.white,
        // Efek bayangan ringan
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
          // Tombol "Lihat Pesanan" yang memenuhi lebar layar
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Memanggil callback onSuccess saat tombol ditekan
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
