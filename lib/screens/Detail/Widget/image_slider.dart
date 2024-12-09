import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Widget untuk slider gambar dengan indikator halaman
class MyImageSlider extends StatefulWidget {
  // Callback untuk memberitahu perubahan indeks halaman
  final Function(int) onChange;

  // Path atau URL gambar yang akan ditampilkan
  final String image;

  const MyImageSlider({
    Key? key,
    required this.image,
    required this.onChange,
  }) : super(key: key);

  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  // Variabel untuk menyimpan indeks halaman saat ini
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kontainer untuk slider gambar
        SizedBox(
          height: 250,
          // PageView untuk membuat slider gambar yang dapat digeser
          child: PageView.builder(
            // Fungsi yang dipanggil ketika halaman berubah
            onPageChanged: (index) {
              // Memperbarui state dengan indeks halaman baru
              setState(() {
                _currentIndex = index;
              });
              // Memanggil callback onChange yang diberikan
              widget.onChange(index);
            },
            // Jumlah total halaman/gambar
            itemCount: 5, // Asumsikan memiliki beberapa gambar
            // Pembuat item untuk setiap halaman
            itemBuilder: (context, index) {
              // Menggunakan Hero widget untuk animasi transisi
              return Hero(
                // Tag unik untuk animasi
                tag: widget.image,
                // Menampilkan gambar dari aset
                child: Image.asset(widget.image),
              );
            },
          ),
        ),

        // Spasi antara slider dan indikator
        const SizedBox(height: 10),

        // Baris indikator halaman
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Membuat indikator untuk setiap halaman
          children: List.generate(
            5, // Ganti dengan jumlah gambar sebenarnya
            (index) => Container(
              // Margin horizontal antara indikator
              margin: const EdgeInsets.symmetric(horizontal: 4),
              // Ukuran indikator
              width: 8,
              height: 8,
              // Dekorasi indikator berbentuk lingkaran
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Warna indikator berubah berdasarkan halaman saat ini
                color: _currentIndex == index
                    ? Colors.black // Halaman saat ini berwarna hitam
                    : Colors.grey[400], // Halaman lain berwarna abu-abu
              ),
            ),
          ),
        ),
      ],
    );
  }
}
