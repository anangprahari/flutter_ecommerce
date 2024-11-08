import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class BRIVirtualAccountScreen extends StatelessWidget {
  final double amount;
  final String orderNumber;
  final VoidCallback onSuccess;

  const BRIVirtualAccountScreen({
    Key? key,
    required this.amount,
    required this.orderNumber,
    required this.onSuccess,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final vaNumber =
        "8077 7000 1282 4775 2"; // Replace with actual BRI VA number

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Menunggu Pembayaran',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatCurrency(amount),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Batas Akhir Pembayaran',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    getPaymentDeadline(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/icon/bri.png',
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Bank BRI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nomor Virtual Account',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vaNumber,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: vaNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Nomor VA berhasil disalin'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );

                          Future.delayed(Duration(seconds: 10), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pembayaran berhasil'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: kprimaryColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Salin',
                            style: TextStyle(
                              color: kprimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cara Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
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
                  ),
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
                  ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: kprimaryColor),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onSuccess,
                child: Text(
                  'Lihat Pesanan',
                  style: TextStyle(
                    color: kprimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionExpansionTile(String title, List<String> steps) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                      child: Text(
                        steps[index],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
