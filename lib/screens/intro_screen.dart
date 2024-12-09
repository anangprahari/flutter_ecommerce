import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../constants.dart';

// Widget IntroScreen sebagai halaman intro/welcome
class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State createState() => _IntroScreenState();
}

// State untuk widget IntroScreen
class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  // Controller untuk mengatur animasi tombol
  late final AnimationController _buttonController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  // Animasi scale untuk efek scaling pada tombol
  late final Animation<double> _buttonScale = TweenSequence<double>([
    // Sequence pertama - mengecilkan tombol
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.0, end: 0.95),
      weight: 1.0,
    ),
    // Sequence kedua - mengembalikan ukuran tombol
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      weight: 1.0,
    ),
  ]).animate(CurvedAnimation(
    parent: _buttonController,
    curve: Curves.easeInOut,
  ));

  // Method untuk menjalankan animasi tombol dan navigasi
  void _animateButton() async {
    await _buttonController.forward();
    await _buttonController.reverse();

    // Navigasi ke halaman register setelah animasi selesai
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    }
  }

  // Method untuk membersihkan controller saat widget di dispose
  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  // Method untuk membangun tampilan UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Dekorasi background dengan gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kprimaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Widget judul aplikasi
                      const Text(
                        'Selamat Datang Di JenShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      // Widget subtitle
                      const Text(
                        'Temukan produk impian Anda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Widget logo aplikasi
                      Image.asset(
                        'images/icon/Jenshop.png',
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 24.0),
                      // Widget tombol dengan animasi scale
                      AnimatedBuilder(
                        animation: _buttonScale,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScale.value,
                            child: Container(
                              // Dekorasi untuk tombol dengan shadow
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: kprimaryColor.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _animateButton,
                                // Style untuk tombol
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kprimaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                    vertical: 16.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 0,
                                ),
                                // Teks pada tombol
                                child: const Text(
                                  'Ayo Belanja',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
