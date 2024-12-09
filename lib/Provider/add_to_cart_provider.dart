import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

// Provider untuk mengelola keranjang belanja dengan state management
class CartProvider extends ChangeNotifier {
  // Daftar produk dalam keranjang
  final List<Product> _cart = [];

  // Diskon default 10% yang akan diterapkan secara otomatis
  double _discount = 0.1;

  // Getter untuk mendapatkan daftar produk dalam keranjang
  List<Product> get cart => _cart;

  // Getter untuk mendapatkan nilai diskon
  double get discount => _discount;

  // Metode untuk menambahkan atau mengupdate produk dalam keranjang
  // Jika produk sudah ada, akan menambah kuantitas
  void toggleFavorite(Product product) {
    if (_cart.contains(product)) {
      // Jika produk sudah ada di keranjang, tambahkan kuantitasnya
      for (Product element in _cart) {
        element.quantity++;
      }
    } else {
      // Jika produk belum ada, tambahkan ke keranjang
      _cart.add(product);
    }
    // Memberi tahu listeners bahwa state telah berubah
    notifyListeners();
  }

  // Metode untuk menambah kuantitas produk di keranjang berdasarkan index
  void incrementQtn(int index) {
    _cart[index].quantity++;
    // Memberi tahu listeners bahwa state telah berubah
    notifyListeners();
  }

  // Metode untuk mengurangi kuantitas produk di keranjang berdasarkan index
  void decrementQtn(int index) {
    // Mencegah kuantitas menjadi kurang dari 1
    if (_cart[index].quantity <= 1) {
      return;
    }
    _cart[index].quantity--;
    // Memberi tahu listeners bahwa state telah berubah
    notifyListeners();
  }

  // Menghitung total harga produk di keranjang tanpa diskon
  double totalPrice() {
    double myTotal = 0.0;
    // Iterasi setiap produk untuk menghitung total harga
    for (Product element in _cart) {
      myTotal += element.price * element.quantity;
    }
    return myTotal;
  }

  // Menghitung total harga setelah menerapkan diskon
  double totalPriceWithDiscount() {
    return totalPrice() * (1 - _discount);
  }

  // Metode untuk mengosongkan keranjang
  void clearCart() {
    _cart.clear();
    // Memberi tahu listeners bahwa state telah berubah
    notifyListeners();
  }

  // Metode statis untuk mendapatkan instance CartProvider dari konteks
  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}
