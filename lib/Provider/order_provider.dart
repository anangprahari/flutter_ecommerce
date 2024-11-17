import 'package:flutter/material.dart';
import '../models/product_model.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  // Properties for shipping information and payment method
  String _shippingName = '';
  String _shippingAddress = '';
  String _shippingPhone = '';
  String _shippingRoute = '';
  String _paymentMethod = 'Cash on Delivery';

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
    String? name,
    String? address,
    String? phone,
    double totalPriceWithDiscount, {
    bool discountApplied = false,
    required String paymentMethod, // Require paymentMethod here
  }) {
    // Ensure safe defaults for null values
    String safeName = name ?? 'Nama tidak tersedia';
    String safeAddress = address ?? 'Alamat tidak tersedia';
    String safePhone = phone ?? 'Nomor telepon tidak tersedia';

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
      'name': safeName,
      'address': safeAddress,
      'phone': safePhone,
      'totalPriceWithDiscount': totalPriceWithDiscount,
      'shippingRoute': 'Order Confirmed > Processing > On the Way',
      'discountApplied': discountApplied,
      'paymentMethod': paymentMethod, // Correctly set payment method
    });

    // Update provider-level properties
    _shippingName = safeName;
    _shippingAddress = safeAddress;
    _shippingPhone = safePhone;
    _paymentMethod = paymentMethod;

    notifyListeners();
  }
}
