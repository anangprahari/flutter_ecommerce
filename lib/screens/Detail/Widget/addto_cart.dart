import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'package:flutter/services.dart';

// Widget untuk menambahkan produk ke keranjang dengan kontrol kuantitas
class AddToCart extends StatefulWidget {
  // Produk yang akan ditambahkan ke keranjang
  final Product product;

  // Fungsi callback untuk memberi tahu perubahan kuantitas
  final Function(int) onQuantityChanged;

  const AddToCart({
    Key? key,
    required this.product,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart>
    with SingleTickerProviderStateMixin {
  // Variabel untuk menyimpan jumlah produk saat ini
  int currentIndex = 1;

  // Controller animasi untuk efek visual
  late AnimationController _animationController;

  // Animasi untuk pengubahan skala
  late Animation<double> _scaleAnimation;

  // Animasi untuk efek geser
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller animasi
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Konfigurasi animasi skala
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Konfigurasi animasi geser
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Memainkan animasi setelah frame pertama di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    // Membersihkan controller animasi
    _animationController.dispose();
    super.dispose();
  }

  // Menampilkan snackbar sukses saat produk ditambahkan ke keranjang
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Konfigurasi tampilan snackbar
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Ikon centang di bagian kiri
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Pesan sukses
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ditambahkan ke Keranjang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Produk berhasil ditambahkan ke keranjang Anda",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: kprimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 16,
          right: 16,
        ),
        elevation: 8,
      ),
    );
  }

  // Membangun kontrol untuk mengubah kuantitas produk
  Widget _buildQuantityControls() {
    return Container(
      height: 46,
      // Desain kontainer dengan border dan gradient
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        borderRadius: BorderRadius.circular(23),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tombol kurang
          _buildControlButton(
            icon: Icons.remove,
            onPressed: () {
              // Mengurangi jumlah jika lebih dari 1
              if (currentIndex > 1) {
                setState(() {
                  currentIndex--;
                });
                widget.onQuantityChanged(currentIndex);
                _playHapticFeedback();
              }
            },
            isEnabled: currentIndex > 1,
          ),
          // Menampilkan jumlah saat ini
          SizedBox(
            width: 32,
            child: Text(
              currentIndex.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Tombol tambah
          _buildControlButton(
            icon: Icons.add,
            onPressed: () {
              // Menambah jumlah
              setState(() {
                currentIndex++;
              });
              widget.onQuantityChanged(currentIndex);
              _playHapticFeedback();
            },
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  // Menghasilkan getaran ringan saat tombol ditekan
  void _playHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  // Membangun tombol kontrol (tambah/kurang)
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Menangani sentuhan dengan efek visual
        onTap: isEnabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            // Warna ikon berubah berdasarkan status aktif/non-aktif
            color: isEnabled ? Colors.white : Colors.white38,
            size: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengakses provider keranjang
    final provider = CartProvider.of(context);
    // Mendapatkan ukuran layar
    final screenSize = MediaQuery.of(context).size;

    // Menghitung ukuran teks adaptif
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double adaptiveTextSize = (14 / textScaleFactor).clamp(12.0, 16.0);

    // Membungkus widget dengan AnimatedBuilder untuk animasi
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        // Efek geser pada kontainer
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Container(
            // Padding dan dekorasi kontainer
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.03,
              vertical: screenSize.height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                // Padding dan dekorasi kontainer internal
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.03,
                  vertical: screenSize.height * 0.01,
                ),
                decoration: BoxDecoration(
                  // Gradient warna latar belakang
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.black87,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Kontrol kuantitas
                    _buildQuantityControls(),
                    SizedBox(width: screenSize.width * 0.02),
                    // Tombol "Tambah ke Keranjang"
                    Expanded(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: ElevatedButton(
                          onPressed: () {
                            // Memainkan animasi saat tombol ditekan
                            _animationController.forward().then((_) {
                              _animationController.reverse();
                            });
                            _playHapticFeedback();

                            // Menambahkan produk ke keranjang sejumlah currentIndex
                            for (int i = 0; i < currentIndex; i++) {
                              provider.toggleFavorite(widget.product);
                            }
                            // Menampilkan snackbar sukses
                            _showSuccessSnackBar(context);
                          },
                          // Gaya tombol
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kprimaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Ikon keranjang
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: adaptiveTextSize + 4,
                                ),
                                SizedBox(width: screenSize.width * 0.01),
                                // Teks tombol
                                Text(
                                  'Tambah Ke Keranjang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: adaptiveTextSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
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
            ),
          ),
        );
      },
    );
  }
}
