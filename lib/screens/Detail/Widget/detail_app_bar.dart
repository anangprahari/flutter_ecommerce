import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Provider/favorite_provider.dart';
import '../../../constants.dart';

class DetailAppBar extends StatelessWidget {
  final Product product;
  const DetailAppBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    // Fungsi untuk menampilkan sidebar berbagi
    void _showShareSidebar(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bagikan Produk Ini",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildShareIcon("images/icon/whatsapp.png", "WhatsApp"),
                      _buildShareIcon("images/icon/instagram.png", "Instagram"),
                      _buildShareIcon("images/icon/google.png", "Google"),
                      _buildShareIcon("images/icon/email.png", "Email"),
                      _buildShareIcon("images/icon/facebook.png", "Facebook"),
                      GestureDetector(
                        onTap: () {
                          _copyLinkToClipboard(context);
                        },
                        child: _buildShareIcon(
                            "images/icon/link.png", "Salin Link"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(40, 40),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20),
            ),
            Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                  ),
                  onPressed: () {
                    _showShareSidebar(context); // Memanggil fungsi sidebar
                  },
                  icon: const Icon(Icons.share_outlined, size: 20),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(10),
                    minimumSize: const Size(40, 40),
                  ),
                  onPressed: () {
                    provider.toggleFavorite(product);
                  },
                  icon: Icon(
                    provider.isExist(product)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: provider.isExist(product)
                        ? kprimaryColor
                        : Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun ikon berbagi dari gambar aset
  Widget _buildShareIcon(String assetPath, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              assetPath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],
      ),
    );
  }

  // Fungsi untuk menyalin link dan menampilkan notifikasi di tengah layar
  void _copyLinkToClipboard(BuildContext context) {
    // Menyalin link ke clipboard
    Clipboard.setData(const ClipboardData(text: "https://flutter.dev/"));

    // Menampilkan dialog notifikasi di tengah layar
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Berhasil disalin",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
