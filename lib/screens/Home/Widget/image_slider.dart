import 'package:flutter/material.dart';

// Widget slider gambar kustom dengan indikator
class ImageSlider extends StatelessWidget {
  // Callback untuk perubahan slide
  final Function(int) onChange;
  // Indeks slide saat ini
  final int currentSlide;

  // Konstruktor dengan parameter wajib
  const ImageSlider({
    super.key,
    required this.currentSlide,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan Stack untuk menumpuk elemen
    return Stack(
      children: [
        // Kontainer utama slider
        Container(
          height: 200,
          // Dekorasi dengan bayangan dan sudut melengkung
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // PageView untuk slider gambar
            child: PageView(
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              // Callback saat halaman berubah
              onPageChanged: onChange,
              // Efek physic bouncing saat scroll
              physics: const BouncingScrollPhysics(),
              // Daftar gambar slide
              children: [
                _buildSlideItem("images/MEGA SALE.png"),
                _buildSlideItem("images/EXTRA DISCOUNT.png"),
                _buildSlideItem("images/FLASH.png"),
                _buildSlideItem("images/4.png"),
              ],
            ),
          ),
        ),

        // Indikator slide di bagian bawah
        Positioned.fill(
          bottom: 16,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              // Dekorasi latar belakang semi transparan
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              // Membuat indikator slide dinamis
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  4,
                  (index) => AnimatedContainer(
                    // Animasi perubahan ukuran indikator
                    duration: const Duration(milliseconds: 300),
                    width: currentSlide == index ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    // Dekorasi indikator dengan warna berbeda
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentSlide == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Metode pribadi untuk membuat item slide
  Widget _buildSlideItem(String imagePath) {
    return Container(
      // Dekorasi dengan gambar latar
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      // Gradient overlay untuk efek bayangan
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
