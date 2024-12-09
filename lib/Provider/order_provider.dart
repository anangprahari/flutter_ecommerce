import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

// Provider untuk mengelola pesanan pengguna
class OrderProvider with ChangeNotifier {
  // Inisialisasi instance Firestore dan FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Daftar pesanan pengguna
  List<Map<String, dynamic>> _orders = [];

  // Variabel untuk menyimpan informasi pengiriman
  String _shippingName = '';
  String _shippingAddress = '';
  String _shippingPhone = '';
  String _shippingRoute = '';
  String _paymentMethod = 'Cash on Delivery';

  // Variabel untuk melacak tahap pengiriman terakhir yang diketahui
  int _lastKnownShippingStep = 0;

  // Getter untuk mengakses variabel privat
  List<Map<String, dynamic>> get orders => _orders;
  String get shippingName => _shippingName;
  String get shippingAddress => _shippingAddress;
  String get shippingPhone => _shippingPhone;
  String get shippingRoute => _shippingRoute;
  String get paymentMethod => _paymentMethod;
  int get lastKnownShippingStep => _lastKnownShippingStep;

  // Metode untuk mengatur metode pembayaran
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners(); // Memberi tahu pendengar bahwa data telah berubah
  }

  // Metode untuk menyimpan tahap pengiriman saat ini ke SharedPreferences
  Future<void> saveShippingStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastShippingStep', step);
    _lastKnownShippingStep = step;
    notifyListeners();
  }

  // Metode untuk mengambil tahap pengiriman terakhir dari SharedPreferences
  Future<int> retrieveLastShippingStep() async {
    final prefs = await SharedPreferences.getInstance();
    _lastKnownShippingStep = prefs.getInt('lastShippingStep') ?? 0;
    return _lastKnownShippingStep;
  }

  // Metode untuk mengambil daftar pesanan pengguna dari Firestore
  Future<void> fetchUserOrders() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Mengambil pesanan yang sesuai dengan ID pengguna saat ini
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      // Mengubah dokumen Firestore menjadi daftar pesanan
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

  // Metode untuk menambahkan pesanan baru ke Firestore
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

      // Menyediakan nilai default jika informasi tidak tersedia
      String safeName = name ?? 'Nama tidak tersedia';
      String safeAddress = address ?? 'Alamat tidak tersedia';
      String safePhone = phone ?? 'Nomor telepon tidak tersedia';

      // Mengubah produk menjadi format yang dapat disimpan di Firestore
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

      // Menambahkan pesanan baru ke koleksi 'orders' di Firestore
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

      // Mereset tahap pengiriman saat pesanan baru ditambahkan
      await saveShippingStep(0);

      // Memperbarui status lokal
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

      // Memperbarui informasi pengiriman
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
