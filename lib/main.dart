// Import pustaka yang diperlukan untuk aplikasi
import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/Provider/favorite_provider.dart';
import 'package:ecommerce_mobile_app/Provider/order_provider.dart';
import 'package:ecommerce_mobile_app/Provider/user_provider.dart';
import 'package:ecommerce_mobile_app/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/intro_screen.dart'; // Import halaman intro
import 'screens/login_screen.dart'; // Import halaman login
import 'package:firebase_core/firebase_core.dart'; // Firebase Core untuk inisialisasi
import 'package:ecommerce_mobile_app/firebase_options.dart'; // Konfigurasi Firebase

// Fungsi utama untuk menjalankan aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan widget diinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Inisialisasi Firebase dengan opsi platform
  );
  runApp(const MyApp()); // Menjalankan aplikasi
}

// Kelas utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          // Mengatur Provider untuk autentikasi
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // Mengatur Provider untuk menambahkan ke keranjang
          ChangeNotifierProvider(create: (_) => CartProvider()),
          // Mengatur Provider untuk fitur favorit
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          // Mengatur Provider untuk pemesanan
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          // Mengatur Provider untuk data pengguna
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
          title: 'JenShop', // Judul aplikasi
          theme: ThemeData(
            // Menggunakan Google Fonts untuk tema teks
            textTheme: GoogleFonts.mulishTextTheme(),
            primaryColor: const Color(0xFF9775FA), // Warna utama aplikasi
            scaffoldBackgroundColor: Colors.white, // Warna latar belakang
          ),
          home: const IntroScreen(), // Halaman awal aplikasi
          routes: {
            // Rute untuk halaman login
            '/login': (context) => const LoginScreen(),
          },
        ),
      );
}
