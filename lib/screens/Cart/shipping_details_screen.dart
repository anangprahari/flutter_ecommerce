import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/nav_bar_screen.dart';
import 'package:intl/intl.dart';
import '../../Provider/order_provider.dart';
import '../../constants.dart';
import '../../Provider/add_to_cart_provider.dart';

class ShippingDetailsScreen extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final List<Product> cartItems;
  final double totalPrice;
  final String paymentMethod;
  final bool discountApplied;
  final String? virtualAccountNumber;
  final String? paymentDueDate;

  const ShippingDetailsScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.phone,
    required this.cartItems,
    required this.totalPrice,
    required this.paymentMethod,
    required this.discountApplied,
    this.virtualAccountNumber,
    this.paymentDueDate,
  }) : super(key: key);

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  double calculateSubtotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double calculateTotalDiscount() {
    if (!discountApplied) return 0;
    return cartItems.fold(
        0,
        (sum, item) =>
            sum +
            (item.price *
                item.quantity *
                (item.discountPercentage ?? 0) /
                100));
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = calculateSubtotal();
    double totalDiscount = calculateTotalDiscount();
    double totalAfterDiscount = subtotal - totalDiscount;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Pengiriman',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Informasi Pengiriman'),
                _buildShippingInfo(),
                _buildSectionTitle('Detail Pesanan'),
                _buildOrderDetails(),
                _buildSectionTitle('Rincian Harga'),
                _buildPriceSummary(subtotal, totalDiscount, totalAfterDiscount),
                _buildSectionTitle('Metode Pembayaran'),
                _buildPaymentInfo(),
                _buildSectionTitle('Status Pengiriman'),
                _buildShippingStatus(),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildReturnToShoppingButton(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, 'Nama Penerima', name),
            const Divider(height: 24),
            _buildInfoRow(Icons.location_on, 'Alamat Pengiriman', address),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Nomor Telepon', phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kprimaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cartItems.map((item) {
              double itemSubtotal = item.price * item.quantity;
              double itemDiscount = discountApplied
                  ? itemSubtotal * (item.discountPercentage ?? 0) / 100
                  : 0;
              return _buildProductDetail(item, itemSubtotal, itemDiscount);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetail(Product item, double subtotal, double discount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.image,
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
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatCurrency(item.price)} × ${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (discount > 0)
                  Text(
                    'Diskon: -${formatCurrency(discount)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatCurrency(subtotal - discount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(double subtotal, double discount, double total) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', subtotal),
            if (discount > 0) _buildSummaryRow('Total Diskon', -discount),
            const Divider(),
            _buildSummaryRow('Total Pembayaran', total, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          formatCurrency(value),
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  paymentMethod.contains('Akun Virtual')
                      ? Icons.account_balance
                      : Icons.payments,
                  color: kprimaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  paymentMethod,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (virtualAccountNumber != null)
              _buildPaymentDetail(
                  'Nomor Rekening Virtual', virtualAccountNumber!),
            if (paymentDueDate != null)
              _buildPaymentDetail('Batas Waktu Pembayaran', paymentDueDate!),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStatus() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusStep('Pesanan Dikonfirmasi', true),
            _buildStatusLine(true),
            _buildStatusStep('Sedang Diproses', true),
            _buildStatusLine(true),
            _buildStatusStep('Dalam Perjalanan', false),
            _buildStatusLine(false),
            _buildStatusStep('Dalam Pengantaran', false),
            _buildStatusLine(false),
            _buildStatusStep('Terkirim', false, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep(String text, bool isCompleted,
      {bool isLast = false}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? kprimaryColor : Colors.grey[300],
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
              color: isCompleted ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 11),
      width: 2,
      height: 24,
      color: isCompleted ? kprimaryColor : Colors.grey[300],
    );
  }

  Widget _buildReturnToShoppingButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<OrderProvider>(context, listen: false).addOrder(
            cartItems,
            name,
            address,
            phone,
            totalPrice,
            paymentMethod: paymentMethod,
          );
          Provider.of<CartProvider>(context, listen: false).clearCart();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kprimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 56),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Kembali Berbelanja',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
