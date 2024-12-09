import 'package:ecommerce_mobile_app/Provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:ecommerce_mobile_app/screens/Detail/detail_screen.dart';

// Layar produk favorit yang dapat berubah (stateful)
class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan provider favorit
    final provider = FavoriteProvider.of(context);
    // Mendapatkan daftar produk favorit
    final finalList = provider.favorites;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // AppBar layar favorit
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        elevation: 0,
        centerTitle: true,
        // Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Judul AppBar
        title: const Text(
          "Produk Favorit",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        // Aksi pada AppBar
        actions: [
          // Tombol hapus semua favorit jika daftar tidak kosong
          if (finalList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () {
                // Tampilkan dialog konfirmasi penghapusan
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("Hapus Produk Favorit"),
                    content: const Text(
                      "Apakah Anda yakin ingin menghapus semua produk dari favorit?",
                    ),
                    actions: [
                      // Tombol batal
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      // Tombol konfirmasi hapus
                      TextButton(
                        onPressed: () {
                          setState(() {
                            // Hapus semua item dari daftar favorit
                            finalList.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      // Isi body layar favorit
      body: finalList.isEmpty
          // Tampilan saat daftar favorit kosong
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon favorit kosong
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  // Teks informasi daftar favorit kosong
                  Text(
                    "Daftar favorit Anda kosong",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Produk yang Anda suka akan muncul di sini",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          // Tampilan daftar produk favorit
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: finalList.length,
                itemBuilder: (context, index) {
                  final item = finalList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    // Gesture detector untuk navigasi ke layar detail
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(product: item),
                          ),
                        );
                      },
                      // Kontainer untuk setiap item favorit
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              // Konten utama item favorit
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Gambar produk
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: kcontentColor,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: Image.asset(
                                          item.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Informasi detail produk
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Judul produk
                                          Text(
                                            item.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Informasi penjual
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.store_outlined,
                                                size: 16,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                item.seller,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Rating produk
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                size: 16,
                                                color: Colors.amber[700],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${item.rate}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                " (${item.reviewCount})",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Informasi harga
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Harga saat ini
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0,
                                                ).format(item.price),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: kprimaryColor,
                                                ),
                                              ),
                                              // Harga asli (jika ada diskon)
                                              if (item.originalPrice !=
                                                  null) ...[
                                                const SizedBox(width: 8),
                                                Text(
                                                  NumberFormat.currency(
                                                    locale: 'id',
                                                    symbol: 'Rp ',
                                                    decimalDigits: 0,
                                                  ).format(item.originalPrice),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[500],
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tombol hapus dari favorit
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        // Hapus item dari daftar favorit
                                        finalList.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
