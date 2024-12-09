import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/screens/Cart/checkout_screen.dart';
import 'package:intl/intl.dart';

// Widget StatefulWidget untuk kotak checkout
class CheckOutBox extends StatefulWidget {
  const CheckOutBox({super.key});

  @override
  State<CheckOutBox> createState() => _CheckOutBoxState();
}

class _CheckOutBoxState extends State<CheckOutBox> {
  // Kontroler untuk input kode diskon
  final TextEditingController _discountController = TextEditingController();

  // Status apakah diskon sudah diterapkan
  bool _isDiscountApplied = false;

  // Metode untuk menerapkan diskon
  void _applyDiscount() {
    setState(() {
      // Cek apakah kode diskon yang dimasukkan adalah "jenshop"
      _isDiscountApplied =
          _discountController.text.trim().toLowerCase() == "jenshop";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance provider keranjang
    final provider = CartProvider.of(context);

    // Inisialisasi variabel untuk perhitungan total
    double subtotal = 0;
    double discountAmount = 0;
    double total = 0;

    // Mendapatkan ukuran layar
    final screenSize = MediaQuery.of(context).size;

    // Mengecek apakah layar termasuk layar kecil (misalnya iPhone SE)
    final isSmallScreen = screenSize.width <= 375;

    // List untuk menyimpan detail produk
    List<Map<String, dynamic>> productDetails = [];

    // Iterasi melalui setiap produk di keranjang untuk menghitung total
    for (var product in provider.cart) {
      // Menghitung subtotal produk
      double productSubtotal = product.price * product.quantity;
      double productDiscountAmount = 0;

      // Menerapkan diskon jika tersedia
      if (_isDiscountApplied &&
          product.discountPercentage != null &&
          product.discountPercentage! > 0) {
        productDiscountAmount =
            productSubtotal * (product.discountPercentage! / 100);
        discountAmount += productDiscountAmount;
      }

      // Menambahkan ke total keseluruhan
      subtotal += productSubtotal;
      total += (productSubtotal - productDiscountAmount);

      // Menyimpan detail produk untuk ditampilkan
      productDetails.add({
        'name': product.title,
        'price': product.price,
        'quantity': product.quantity,
        'subtotal': productSubtotal,
        'discount': productDiscountAmount,
      });
    }

    // Kontainer utama untuk kotak checkout
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        // Efek bayangan di bagian atas
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bagian input diskon
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 12 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kontainer input kode diskon
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      // TextField untuk memasukkan kode diskon
                      Expanded(
                        child: TextField(
                          controller: _discountController,
                          style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Masukkan Kode Diskon",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol untuk mengaktifkan diskon
                      ElevatedButton(
                        onPressed: _applyDiscount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Aktifkan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Daftar produk yang dapat digulir
          ConstrainedBox(
            constraints: BoxConstraints(
              // Membatasi tinggi maksimum daftar produk
              maxHeight: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                ),
                child: Column(
                  children: [
                    // Daftar item produk
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productDetails.length,
                      itemBuilder: (context, index) {
                        final product = productDetails[index];
                        // Kontainer untuk setiap produk
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Baris pertama: nama produk dan kuantitas
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen ? 13 : 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${product['quantity']}x',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isSmallScreen ? 13 : 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Baris kedua: harga per item dan subtotal
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(product['price']),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isSmallScreen ? 12 : 13,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(product['subtotal']),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: isSmallScreen ? 13 : 14,
                                    ),
                                  ),
                                ],
                              ),
                              // Menampilkan diskon jika ada
                              if (_isDiscountApplied && product['discount'] > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "- ${NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0,
                                        ).format(product['discount'])}",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: isSmallScreen ? 12 : 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bagian ringkasan dan checkout
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: 8,
              ),
              child: Column(
                children: [
                  // Kontainer ringkasan pembayaran
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Baris subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(subtotal),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                          ],
                        ),
                        // Baris total diskon (jika ada)
                        if (_isDiscountApplied) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Diskon",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isSmallScreen ? 13 : 14,
                                ),
                              ),
                              Text(
                                "- ${NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(discountAmount)}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: isSmallScreen ? 13 : 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Garis pembatas
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: Colors.grey[300]),
                        ),
                        // Baris total pembayaran
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tombol checkout
                  Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      // Aksi saat tombol checkout ditekan
                      onPressed: () {
                        // Navigasi ke layar checkout dengan membawa detail pembayaran
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              subtotal: subtotal,
                              discountApplied: _isDiscountApplied,
                              total: total,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Checkout Sekarang",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
