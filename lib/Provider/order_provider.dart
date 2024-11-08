import 'package:flutter/material.dart';
import '../models/product_model.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  // Properti untuk menyimpan informasi pengiriman dan metode pembayaran
  String _shippingName = '';
  String _shippingAddress = '';
  String _shippingPhone = '';
  String _shippingRoute = '';
  String _paymentMethod = 'Bayar di Tempat'; // Default ke 'Bayar di Tempat'

  List<Map<String, dynamic>> get orders => _orders;
  String get shippingName => _shippingName;
  String get shippingAddress => _shippingAddress;
  String get shippingPhone => _shippingPhone;
  String get shippingRoute => _shippingRoute;
  String get paymentMethod => _paymentMethod;

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void addOrder(
    List<Product> products,
    String name,
    String address,
    String phone,
    double totalPriceWithDiscount, {
    bool discountApplied = false,
    String paymentMethod = 'Bayar di Tempat',
  }) {
    // Membuat salinan produk untuk pesanan
    List<Product> productCopies = products.map((product) {
      return Product(
        title: product.title,
        review: product.review,
        description: product.description,
        image: product.image,
        price: product.price,
        colors: product.colors,
        seller: product.seller,
        category: product.category,
        rate: product.rate,
        quantity: product.quantity,
        discountPercentage: product.discountPercentage,
      );
    }).toList();

    _orders.add({
      'products': productCopies,
      'name': name,
      'address': address,
      'phone': phone,
      'totalPriceWithDiscount': totalPriceWithDiscount,
      'shippingRoute': 'Order Confirmed > Processing > On the Way',
      'discountApplied': discountApplied,
      'paymentMethod': paymentMethod,
    });

    // Update informasi pengiriman dan metode pembayaran
    _shippingName = name;
    _shippingAddress = address;
    _shippingPhone = phone;
    _paymentMethod = paymentMethod;

    notifyListeners();
  }
}
