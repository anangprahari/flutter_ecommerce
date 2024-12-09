import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

// Provider untuk mengelola produk favorit pengguna
class FavoriteProvider extends ChangeNotifier {
  // Daftar produk favorit
  final List<Product> _favorite = [];

  // Getter untuk mengakses daftar produk favorit
  List<Product> get favorites => _favorite;

  // Metode untuk menambah atau menghapus produk dari daftar favorit
  void toggleFavorite(Product product) {
    if (_favorite.contains(product)) {
      // Jika produk sudah ada di daftar favorit, hapus
      _favorite.remove(product);
    } else {
      // Jika produk belum ada di daftar favorit, tambahkan
      _favorite.add(product);
    }
    notifyListeners(); // Memberi tahu pendengar bahwa daftar favorit telah berubah
  }

  // Metode untuk memeriksa apakah suatu produk sudah ada di daftar favorit
  bool isExist(Product product) {
    final isExist = _favorite.contains(product);
    return isExist;
  }

  // Metode statis untuk mengakses FavoriteProvider dari BuildContext
  // Memungkinkan penggunaan provider di berbagai widget
  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
