import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/Provider/favorite_provider.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Detail/detail_screen.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

// Widget StatefulWidget untuk kartu produk yang dapat diinteraksi
class ProductCard extends StatefulWidget {
  // Parameter produk dan harga yang diformat
  final Product product;
  final String priceFormatted;

  // Konstruktor dengan parameter wajib
  const ProductCard({
    Key? key,
    required this.product,
    required this.priceFormatted,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  // Kontroler animasi untuk efek sentuhan
  late AnimationController _controller;
  // Animasi skala untuk efek menekan kartu
  late Animation<double> _scaleAnimation;

  // Fungsi untuk memformat harga dalam mata uang Rupiah
  String formatRupiah(double price) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi kontroler animasi dengan durasi 200 milidetik
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    // Membuat animasi skala dengan rentang 1.0 ke 0.95
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Membersihkan kontroler animasi untuk mencegah memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan provider favorit dari konteks
    final provider = FavoriteProvider.of(context);
    // Mendapatkan lebar layar perangkat
    final screenWidth = MediaQuery.of(context).size.width;

    // Menghitung lebar kartu secara responsif
    final cardWidth = (screenWidth - 32) / 2;
    // Menghitung tinggi gambar dengan rasio aspek
    final imageHeight = cardWidth * 0.9;

    return GestureDetector(
      // Animasi ketika kartu ditekan
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),

      // Navigasi ke halaman detail produk saat kartu diklik
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: widget.product),
          ),
        );
      },

      // Widget pembungkus animasi skala
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            // Desain kontainer kartu produk
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: kprimaryColor.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tumpukan gambar produk dan fitur tambahan
                Stack(
                  children: [
                    // Kontainer gambar produk
                    Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kcontentColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      child: Hero(
                        // Efek transisi gambar antar layar
                        tag: widget.product.image,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.asset(
                            widget.product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Label diskon (jika ada)
                    if (widget.product.discountPercentage != null)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: kprimaryColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '-${widget.product.discountPercentage}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Tombol favorit
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        // Toggle status favorit produk
                        onTap: () {
                          provider.toggleFavorite(widget.product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            // Pilih ikon berdasarkan status favorit
                            provider.isExist(widget.product)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: kprimaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Informasi detail produk
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating produk
                      Row(
                        children: [
                          // Bintang rating
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                size: 12,
                                color: index < widget.product.rate.floor()
                                    ? Colors.amber
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Skor rating
                          Text(
                            "${widget.product.rate}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Judul produk
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Informasi harga
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Harga setelah diskon
                          Text(
                            widget.priceFormatted,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kprimaryColor,
                            ),
                          ),
                          // Harga asli (jika ada diskon)
                          if (widget.product.originalPrice != null)
                            Text(
                              formatRupiah(widget.product.originalPrice!),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey[400],
                              ),
                            ),
                        ],
                      ),

                      // Label gratis ongkir (jika berlaku)
                      if (widget.product.freeShipping) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 12,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Gratis Ongkir',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
