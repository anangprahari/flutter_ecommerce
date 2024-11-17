import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/Provider/favorite_provider.dart';
import 'package:ecommerce_mobile_app/Provider/order_provider.dart';
import 'package:ecommerce_mobile_app/Provider/user_provider.dart';
import 'package:ecommerce_mobile_app/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // for add to cart
          ChangeNotifierProvider(create: (_) => CartProvider()),
          // for favorite
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JenShop',
          theme: ThemeData(
            textTheme: GoogleFonts.mulishTextTheme(),
            primaryColor: const Color(0xFF9775FA),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const IntroScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
          },
        ),
      );
}
