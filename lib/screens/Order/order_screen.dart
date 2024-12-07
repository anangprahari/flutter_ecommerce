import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Provider/order_provider.dart';
import '../../models/product_model.dart';
import '../../constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int currentStep = 2;
  bool showNotification = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrdersAndInitializeStatus();
  }

  Future<void> _fetchOrdersAndInitializeStatus() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Fetch orders
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchUserOrders();

        // Retrieve last known shipping step
        final orderProvider =
            Provider.of<OrderProvider>(context, listen: false);
        int lastStep = await orderProvider.retrieveLastShippingStep();

        setState(() {
          currentStep = lastStep;
          _isLoading = false;
        });

        // If the last step is not the final step, start automatic updates
        if (currentStep < 5) {
          _startStatusUpdates(initialStep: currentStep);
        }
      }
    } catch (e) {
      print('Error fetching orders and status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startStatusUpdates({int initialStep = 0}) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Start from the last known step
    for (int step = initialStep; step < 5; step++) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(() {
        currentStep = step;
      });

      // Save the current step
      await orderProvider.saveShippingStep(currentStep);

      // Show notification on the final step
      if (step == 4) {
        setState(() {
          showNotification = true;
        });

        // Hide notification after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            showNotification = false;
          });
        }
      }
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Widget _buildOrderCard(
      Map<String, dynamic> order,
      List<Product> products,
      bool discountApplied,
      double totalPrice,
      double totalSubtotal,
      double totalDiscount) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Informasi Pengiriman'),
            _buildShippingInfo(order),
            _buildSectionTitle('Detail Pesanan'),
            _buildOrderDetails(products, discountApplied),
            _buildSectionTitle('Rincian Harga'),
            _buildPriceDetails(totalSubtotal, totalDiscount, totalPrice),
            _buildSectionTitle('Metode Pembayaran'),
            _buildPaymentMethod(order['paymentMethod']),
            _buildSectionTitle('Status Pengiriman'),
            _buildShippingStatus(order['shippingRoute']),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(Map<String, dynamic> order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, 'Nama Penerima', order['name']),
            const Divider(height: 24),
            _buildInfoRow(
                Icons.location_on, 'Alamat Pengiriman', order['address']),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Nomor Telepon', order['phone']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: kprimaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(List<Product> products, bool discountApplied) {
    return Column(
      children: products.map((item) {
        double subtotal = item.price * item.quantity;
        double discount = discountApplied
            ? subtotal * (item.discountPercentage ?? 0) / 100
            : 0;
        return _buildProductCard(item, subtotal, discount);
      }).toList(),
    );
  }

  Widget _buildProductCard(Product product, double subtotal, double discount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                      '${formatCurrency(product.price)} × ${product.quantity}'),
                  if (product.discountPercentage != null &&
                      product.discountPercentage! > 0)
                    Text(
                      'Diskon: ${product.discountPercentage}%',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            Text(
              formatCurrency(subtotal - discount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails(
      double subtotal, double discount, double totalPrice) {
    return Column(
      children: [
        _buildPriceRow('Subtotal', subtotal),
        if (discount > 0)
          _buildPriceRow('Diskon Total', -discount, isRed: true),
        const Divider(),
        _buildPriceRow('Total Pembayaran', totalPrice, isBold: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double value,
      {bool isBold = false, bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(formatCurrency(value),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isRed ? Colors.red : null,
            )),
      ],
    );
  }

  Widget _buildPaymentMethod(String paymentMethod) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.payment, color: kprimaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                paymentMethod,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingStatus(String shippingRoute) {
    const steps = [
      'Pesanan Dikonfirmasi',
      'Sedang Diproses',
      'Dalam Perjalanan',
      'Dalam Pengantaran',
      'Terkirim'
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              if (i > 0)
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: Colors.grey.withOpacity(0.3),
                    end: i <= currentStep
                        ? kprimaryColor
                        : Colors.grey.withOpacity(0.3),
                  ),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, color, _) {
                    return Container(
                      margin: const EdgeInsets.only(left: 12),
                      height: 20,
                      width: 2,
                      color: color,
                    );
                  },
                ),
              Row(
                children: [
                  TweenAnimationBuilder<Color?>(
                    tween: ColorTween(
                      begin: Colors.grey[300],
                      end: i <= currentStep ? kprimaryColor : Colors.grey[300],
                    ),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, color, _) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: Icon(
                          i <= currentStep
                              ? Icons.check
                              : Icons.circle_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: i <= currentStep ? Colors.black : Colors.grey,
                      fontWeight: i <= currentStep
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai belanja sekarang!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pesanan Saya',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: kprimaryColor,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: kcontentColor,
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: kprimaryColor,
                  ),
                )
              : orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];
                        // Convert products from Firebase map to Product objects
                        List<Product> products = (order['products'] as List)
                            .map((productMap) => Product(
                                  title: productMap['title'] ?? '',
                                  review: productMap['review'] ?? '',
                                  description: productMap['description'] ?? '',
                                  image: productMap['image'] ?? '',
                                  price:
                                      (productMap['price'] ?? 0.0).toDouble(),
                                  seller: productMap['seller'] ?? '',
                                  colors: productMap['colors'] is List
                                      ? (productMap['colors'] as List)
                                          .map((color) => Color(color))
                                          .toList()
                                      : [],
                                  category: productMap['category'] ?? '',
                                  rate: (productMap['rate'] ?? 0.0).toDouble(),
                                  quantity: productMap['quantity'] ?? 1,
                                ))
                            .toList();

                        bool discountApplied =
                            order['discountApplied'] ?? false;
                        double totalPrice =
                            order['totalPriceWithDiscount'].toDouble();
                        double totalSubtotal = products.fold(0,
                            (sum, item) => sum + (item.price * item.quantity));
                        double totalDiscount = discountApplied
                            ? products.fold(
                                0,
                                (sum, item) =>
                                    sum +
                                    (item.price *
                                        item.quantity *
                                        (item.discountPercentage ?? 0) /
                                        100))
                            : 0;

                        return _buildOrderCard(order, products, discountApplied,
                            totalPrice, totalSubtotal, totalDiscount);
                      },
                    ),
        ),
        if (showNotification)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Pesanan anda sudah diterima',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
