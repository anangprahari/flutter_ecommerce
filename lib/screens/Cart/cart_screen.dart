import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/screens/Cart/check_out.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

// Widget StatefulWidget untuk layar keranjang belanja
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance provider keranjang dari konteks
    final provider = CartProvider.of(context);

    // Mendapatkan daftar item yang ada di keranjang
    final finalList = provider.cart;

    // Fungsi untuk membuat tombol kuantitas (tambah dan kurang)
    Widget quantityButton(IconData icon, int index) {
      return Material(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          // Aksi ketika tombol ditekan untuk menambah atau mengurangi kuantitas
          onTap: () {
            setState(() {
              icon == Icons.add
                  ? provider.incrementQtn(index)
                  : provider.decrementQtn(index);
            });
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: kprimaryColor,
            ),
          ),
        ),
      );
    }

    // Struktur utama layar keranjang
    return Scaffold(
      // Warna latar belakang layar
      backgroundColor: Colors.grey[100],

      // Konfigurasi app bar
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        elevation: 0,
        centerTitle: true,
        // Tombol kembali di sebelah kiri
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // Judul app bar
        title: const Text(
          "Keranjang Saya",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        // Aksi di app bar untuk menghapus semua item
        actions: [
          if (finalList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              // Menampilkan dialog konfirmasi penghapusan
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Hapus Semua"),
                    content: const Text(
                        "Apakah Anda yakin ingin mengosongkan keranjang?"),
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
                            // Mengosongkan daftar keranjang
                            finalList.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Hapus",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),

      // Kondisi tampilan saat keranjang kosong
      body: finalList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon keranjang kosong
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  // Teks keranjang kosong
                  Text(
                    "Keranjang Anda kosong",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          // Tampilan saat keranjang berisi item
          : SafeArea(
              child: Column(
                children: [
                  // Daftar item keranjang
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: finalList.length,
                      itemBuilder: (context, index) {
                        // Item keranjang saat ini
                        final cartItems = finalList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          // Kontainer untuk setiap item keranjang
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              // Efek bayangan
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
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Gambar produk
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: kcontentColor,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.asset(
                                              cartItems.image,
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
                                                cartItems.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Kategori produk
                                              Text(
                                                cartItems.category,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Harga produk
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0,
                                                ).format(cartItems.price),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: kprimaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Kontrol kuantitas
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Tombol kurangi kuantitas
                                                    quantityButton(
                                                        Icons.remove, index),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      // Menampilkan jumlah kuantitas
                                                      child: Text(
                                                        cartItems.quantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    // Tombol tambah kuantitas
                                                    quantityButton(
                                                        Icons.add, index),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Tombol hapus item
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            // Menghapus item dari keranjang
                                            finalList.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Kotak checkout ditampilkan jika keranjang tidak kosong
                  if (finalList.isNotEmpty) const CheckOutBox(),
                ],
              ),
            ),
    );
  }
}
