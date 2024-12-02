import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constants.dart';

class MandiriVirtualAccountScreen extends StatefulWidget {
  final double amount;
  final String orderNumber;
  final VoidCallback onSuccess;

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

class _MandiriVirtualAccountScreenState
    extends State<MandiriVirtualAccountScreen> {
  bool isExpanded = false;
  final vaNumber = "8810 7000 1234 5678";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _logTransaction();
  }

  Future<void> _logTransaction() async {
    try {
      await firestore.collection('transactions').add({
        'orderNumber': widget.orderNumber,
        'amount': widget.amount,
        'vaNumber': vaNumber,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Transaction logged successfully!");
    } catch (e) {
      debugPrint("Failed to log transaction: $e");
    }
  }

  Future<void> _sendPaymentNotification() async {
    try {
      await messaging.sendMessage(
        to: '/topics/payments',
        data: {
          'orderNumber': widget.orderNumber,
          'amount': widget.amount.toString(),
          'status': 'completed',
        },
      );
      debugPrint("Payment notification sent successfully!");
    } catch (e) {
      debugPrint("Failed to send payment notification: $e");
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String getPaymentDeadline() {
    final deadline = DateTime.now().add(Duration(hours: 24));
    return DateFormat('HH:mm, d MMM yyyy').format(deadline);
  }

  void _copyVANumber() {
    Clipboard.setData(ClipboardData(text: vaNumber));
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

    // Simulate payment success
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        _markPaymentSuccess();
      }
    });
  }

  Future<void> _markPaymentSuccess() async {
    try {
      await firestore
          .collection('transactions')
          .where('orderNumber', isEqualTo: widget.orderNumber)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.update({'status': 'completed'});
        }
      });

      _sendPaymentNotification();

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
      debugPrint("Failed to mark payment success: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAmountSection(),
            SizedBox(height: 8),
            _buildVirtualAccountSection(),
            SizedBox(height: 8),
            _buildPaymentInstructions(),
            SizedBox(height: 16),
            _buildSupportSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
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
                      color: kprimaryColor, // Mandiri Blue
                    ),
                  ),
                ],
              ),
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

  Widget _buildVirtualAccountSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        child: ExpansionTile(
          leading: Icon(icon, color: kprimaryColor),
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
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

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
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
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
