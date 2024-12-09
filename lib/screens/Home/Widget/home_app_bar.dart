import 'package:flutter/material.dart';

// Widget AppBar kustom yang dapat disesuaikan
class CustomAppBar extends StatelessWidget {
  // Konstruktor dengan key opsional
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat baris dengan tata letak fleksibel
    return Row(
      // Mengatur jarak antar elemen di sepanjang sumbu utama
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Container pertama untuk tombol ikon pertama (logo/ikon)
        Container(
          // Dekorasi container dengan bayangan dan sudut melengkung
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              // Bayangan ringan dengan opacity rendah
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Tombol ikon dengan gambar aset
          child: IconButton(
            // Mengatur padding tombol
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            // Fungsi yang dipanggil saat tombol ditekan (kosong saat ini)
            onPressed: () {},
            // Menampilkan gambar ikon dari aset
            icon: Image.asset(
              "images/icon.png",
              height: 24,
            ),
          ),
        ),

        // Baris kedua berisi tombol favorit dan notifikasi
        Row(
          children: [
            // Container untuk tombol favorit
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  size: 24,
                  color: Colors.black87,
                ),
              ),
            ),

            // Spasi kecil antar tombol
            const SizedBox(width: 12),

            // Container untuk tombol notifikasi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // Stack digunakan untuk menumpuk ikon notifikasi dengan lencana
              child: Stack(
                children: [
                  // Tombol ikon notifikasi
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 24,
                      color: Colors.black87,
                    ),
                  ),

                  // Lencana notifikasi di sudut kanan atas
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      // Kontainer berbentuk lingkaran dengan warna merah
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      // Teks jumlah notifikasi
                      child: const Text(
                        "9",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
