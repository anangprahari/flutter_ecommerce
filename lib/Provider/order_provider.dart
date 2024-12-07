import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _orders = [];
  String _shippingName = '';
  String _shippingAddress = '';
  String _shippingPhone = '';
  String _shippingRoute = '';
  String _paymentMethod = 'Cash on Delivery';

  // New field to track the last known shipping status
  int _lastKnownShippingStep = 0;

  List<Map<String, dynamic>> get orders => _orders;
  String get shippingName => _shippingName;
  String get shippingAddress => _shippingAddress;
  String get shippingPhone => _shippingPhone;
  String get shippingRoute => _shippingRoute;
  String get paymentMethod => _paymentMethod;
  int get lastKnownShippingStep => _lastKnownShippingStep;

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // Method to save the current shipping step
  Future<void> saveShippingStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastShippingStep', step);
    _lastKnownShippingStep = step;
    notifyListeners();
  }

  // Method to retrieve the last saved shipping step
  Future<int> retrieveLastShippingStep() async {
    final prefs = await SharedPreferences.getInstance();
    _lastKnownShippingStep = prefs.getInt('lastShippingStep') ?? 0;
    return _lastKnownShippingStep;
  }

  Future<void> fetchUserOrders() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      _orders = querySnapshot.docs.map((doc) {
        return {
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> addOrder(
    List<Product> products,
    String? name,
    String? address,
    String? phone,
    double totalPriceWithDiscount, {
    bool discountApplied = false,
    required String paymentMethod,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('Pengguna belum login');
      }

      String safeName = name ?? 'Nama tidak tersedia';
      String safeAddress = address ?? 'Alamat tidak tersedia';
      String safePhone = phone ?? 'Nomor telepon tidak tersedia';

      List<Map<String, dynamic>> productMaps = products.map((product) {
        return {
          'title': product.title,
          'review': product.review,
          'description': product.description,
          'price': product.price,
          'quantity': product.quantity,
          'image': product.image,
          'seller': product.seller,
          'colors': product.colors.map((color) => color.value).toList(),
          'category': product.category,
          'rate': product.rate,
          'discountPercentage': product.discountPercentage,
        };
      }).toList();

      DocumentReference orderRef = await _firestore.collection('orders').add({
        'userId': currentUser.uid,
        'products': productMaps,
        'name': safeName,
        'address': safeAddress,
        'phone': safePhone,
        'totalPriceWithDiscount': totalPriceWithDiscount,
        'shippingRoute': 'Order Confirmed > Processing > On the Way',
        'discountApplied': discountApplied,
        'paymentMethod': paymentMethod,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Pesanan Dikonfirmasi',
      });

      // Reset shipping step when a new order is added
      await saveShippingStep(0);

      // Update lokal state
      _orders.add({
        'id': orderRef.id,
        'products': productMaps,
        'name': safeName,
        'address': safeAddress,
        'phone': safePhone,
        'totalPriceWithDiscount': totalPriceWithDiscount,
        'shippingRoute': 'Order Confirmed > Processing > On the Way',
        'discountApplied': discountApplied,
        'paymentMethod': paymentMethod,
      });

      _shippingName = safeName;
      _shippingAddress = safeAddress;
      _shippingPhone = safePhone;
      _paymentMethod = paymentMethod;

      notifyListeners();
    } catch (e) {
      print('Error adding order: $e');
      rethrow;
    }
  }
}
