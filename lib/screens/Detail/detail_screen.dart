import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/addto_cart.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/description.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/detail_app_bar.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/image_slider.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/items_details.dart';

// Layar detail produk yang dapat berubah (stateful)
class DetailScreen extends StatefulWidget {
  // Parameter produk yang akan ditampilkan
  final Product product;

  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Variabel untuk menyimpan jumlah, warna, dan ukuran produk yang dipilih
  int quantity = 1;
  Color? selectedColor;
  String? selectedSize;
  int currentImage = 0;

  // Kontroller gulir untuk CustomScrollView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi warna dan ukuran pertama kali
    selectedColor = widget.product.colors.first;
    selectedSize = widget.product.sizes.first;
  }

  @override
  void dispose() {
    // Membersihkan kontroller scroll saat widget dihapus
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Area konten yang dapat digulir
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Bagian atas layar dengan gambar produk
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            color: kcontentColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              // AppBar detail produk
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: DetailAppBar(product: widget.product),
                              ),
                              // Slider gambar produk
                              Expanded(
                                child: Container(
                                  child: MyImageSlider(
                                    image: widget.product.image,
                                    onChange: (index) {
                                      setState(() {
                                        currentImage = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bagian detail produk
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Detail item produk
                              ItemsDetails(product: widget.product),
                              const SizedBox(height: 24),

                              // Bagian pilihan warna
                              _buildSection(
                                title: 'Warna',
                                child: _buildColorOptions(),
                              ),
                              const SizedBox(height: 24),

                              // Bagian pilihan ukuran
                              _buildSection(
                                title: 'Ukuran',
                                child: _buildSizeOptions(),
                              ),
                              const SizedBox(height: 24),

                              // Bagian keterangan produk
                              _buildSection(
                                title: 'Keterangan',
                                child: Description(product: widget.product),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bilah bawah untuk menambah ke keranjang
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat bagian dengan judul
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  // Membuat daftar pilihan warna
  Widget _buildColorOptions() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: widget.product.colors
          .map((color) => _buildColorOption(color))
          .toList(),
    );
  }

  // Membuat pilihan warna individual
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selectedColor == color ? kprimaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: selectedColor == color
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  // Membuat daftar pilihan ukuran
  Widget _buildSizeOptions() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children:
          widget.product.sizes.map((size) => _buildSizeOption(size)).toList(),
    );
  }

  // Membuat pilihan ukuran individual
  Widget _buildSizeOption(String size) {
    final isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kprimaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? kprimaryColor.withOpacity(0.1) : Colors.white,
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? kprimaryColor : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Membangun bilah bawah untuk menambah ke keranjang
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: AddToCart(
        product: widget.product,
        onQuantityChanged: (newQuantity) {
          setState(() {
            quantity = newQuantity.clamp(1, 99);
          });
        },
      ),
    );
  }
}
