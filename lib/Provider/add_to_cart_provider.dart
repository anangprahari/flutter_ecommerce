import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  double _discount = 0.1; // Diskon 10% yang diterapkan otomatis

  List<Product> get cart => _cart;

  double get discount => _discount; // Getter untuk mengakses _discount

  // Menambahkan produk ke keranjang atau menambah jumlah produk jika sudah ada
  void toggleFavorite(Product product) {
    if (_cart.contains(product)) {
      for (Product element in _cart) {
        element.quantity++;
      }
    } else {
      _cart.add(product);
    }
    notifyListeners();
  }

  // Fungsi untuk menambah jumlah produk
  void incrementQtn(int index) {
    _cart[index].quantity++;
    notifyListeners();
  }

  // Fungsi untuk mengurangi jumlah produk
  void decrementQtn(int index) {
    if (_cart[index].quantity <= 1) {
      return;
    }
    _cart[index].quantity--;
    notifyListeners();
  }

  // Menghitung total harga produk di keranjang tanpa diskon
  double totalPrice() {
    double myTotal = 0.0;
    for (Product element in _cart) {
      myTotal += element.price * element.quantity;
    }
    return myTotal;
  }

  // Menghitung total harga setelah diskon
  double totalPriceWithDiscount() {
    return totalPrice() * (1 - _discount);
  }

  // Menghapus semua item di keranjang
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Mendapatkan instance dari CartProvider
  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(
      context,
      listen: listen,
    );
  }
}
