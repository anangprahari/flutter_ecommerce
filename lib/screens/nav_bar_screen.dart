import 'package:ecommerce_mobile_app/constants.dart'; // Mengimpor file konstanta aplikasi
import 'package:ecommerce_mobile_app/screens/Cart/cart_screen.dart'; // Mengimpor layar Keranjang
import 'package:ecommerce_mobile_app/screens/Home/home_screen.dart'; // Mengimpor layar Home
import 'package:ecommerce_mobile_app/screens/Profile/profile.dart'; // Mengimpor layar Profil
import 'package:ecommerce_mobile_app/screens/Order/order_screen.dart'; // Mengimpor layar Pesanan
import 'package:flutter/material.dart'; // Mengimpor paket material Flutter
import 'Favorite/favorite.dart'; // Mengimpor layar Favorit

// Widget utama BottomNavBar menggunakan StatefulWidget
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

// State untuk BottomNavBar
class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 2; // Indeks tab yang aktif, default-nya adalah HomeScreen

  // Daftar layar yang tersedia untuk navigasi
  List screens = const [
    OrderScreen(), // Layar Pesanan
    Favorite(), // Layar Favorit
    HomeScreen(), // Layar Home
    CartScreen(), // Layar Keranjang
    Profile(), // Layar Profil
  ];

  // Fungsi untuk menangani pergantian tab
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index; // Mengubah indeks tab yang aktif
    });
  }

  // Fungsi untuk menangani tombol back pada perangkat
  Future<bool> _onWillPop() async {
    // Jika tab yang aktif bukan HomeScreen, kembali ke HomeScreen
    if (currentIndex != 2) {
      setState(() {
        currentIndex = 2; // Atur indeks ke HomeScreen
      });
      return false; // Mencegah keluar aplikasi
    }

    // Menampilkan dialog konfirmasi untuk keluar aplikasi
    bool? exitResult = await showDialog(
      context: context,
      barrierDismissible: true, // Dialog dapat ditutup dengan klik di luar
      barrierColor: Colors.black87, // Warna latar belakang dialog
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Sudut dialog membulat
        ),
        elevation: 0, // Tanpa bayangan
        backgroundColor: Colors.transparent, // Latar belakang transparan
        child: Container(
          padding: const EdgeInsets.all(20), // Padding konten dialog
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar dialog
            borderRadius: BorderRadius.circular(20), // Sudut membulat
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Bayangan dialog
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ukuran kolom menyesuaikan isi
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kprimaryColor.withOpacity(0.1), // Warna ikon
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded, // Ikon logout
                  size: 32,
                  color: kprimaryColor,
                ),
              ),
              const SizedBox(height: 20), // Jarak antar elemen
              const Text(
                'Keluar Aplikasi', // Judul dialog
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?', // Pesan dialog
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Tombol batal
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: kprimaryColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: kprimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol keluar
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return exitResult ?? false; // Nilai keluar sesuai hasil dialog
  }

  // Widget utama yang membangun UI BottomNavBar
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Menangani tombol back
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentIndex = 2; // Mengarahkan ke HomeScreen
            });
          },
          shape: const CircleBorder(), // Bentuk lingkaran
          backgroundColor: kprimaryColor,
          child: const Icon(
            Icons.home, // Ikon Home
            color: Colors.white,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8, // Jarak FAB dari BottomAppBar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol navigasi untuk Pesanan
                buildNavItem(
                  icon: Icons.assignment,
                  label: "Pesanan",
                  index: 0,
                ),
                // Tombol navigasi untuk Favorit
                buildNavItem(
                  icon: Icons.favorite_border,
                  label: "Favorit",
                  index: 1,
                ),
                const SizedBox(width: 40), // Ruang untuk FAB
                // Tombol navigasi untuk Keranjang
                buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: "Keranjang",
                  index: 3,
                ),
                // Tombol navigasi untuk Profil
                buildNavItem(
                  icon: Icons.person,
                  label: "Profil",
                  index: 4,
                ),
              ],
            ),
          ),
        ),
        body: screens[currentIndex], // Menampilkan layar sesuai indeks
      ),
    );
  }

  // Widget untuk membangun tombol navigasi bawah
  Widget buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final isSelected = index == currentIndex; // Status tombol terpilih

    return GestureDetector(
      onTap: () => onTabTapped(index), // Pergantian tab saat ditekan
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, // Ikon tombol
            size: 28,
            color: isSelected ? kprimaryColor : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label, // Label tombol
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? kprimaryColor : Colors.grey.shade400,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 24,
              decoration: BoxDecoration(
                color: kprimaryColor, // Garis bawah tombol aktif
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }
}
