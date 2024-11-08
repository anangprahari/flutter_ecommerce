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
  final bool
      discountApplied; // Menambahkan parameter untuk mengecek apakah diskon diterapkan
  final String? virtualAccountNumber;
  final String? paymentDueDate;

  ShippingDetailsScreen({
    required this.name,
    required this.address,
    required this.phone,
    required this.cartItems,
    required this.totalPrice,
    required this.paymentMethod,
    required this.discountApplied, // Menyertakan parameter discountApplied
    this.virtualAccountNumber,
    this.paymentDueDate,
  });

  // Fungsi untuk memformat harga menjadi format Rupiah
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    double totalSubtotal =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double totalDiscount = 0;

    // Menghitung total diskon jika discountApplied adalah true
    if (discountApplied) {
      totalDiscount = cartItems.fold(
          0,
          (sum, item) =>
              sum +
              (item.price *
                  item.quantity *
                  (item.discountPercentage ?? 0) /
                  100));
    }

    double totalAfterDiscount =
        discountApplied ? totalSubtotal - totalDiscount : totalSubtotal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pengiriman', style: TextStyle(color: Colors.white)),
        backgroundColor: kprimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: kcontentColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Pengiriman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildShippingInfo(),
                SizedBox(height: 16),
                Text(
                  'Detail Pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildOrderDetailsWithImages(),
                SizedBox(height: 16),
                Text(
                  'Rincian Harga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildPriceDetails(
                    totalSubtotal, totalDiscount, totalAfterDiscount),
                SizedBox(height: 16),
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildPaymentMethod(),
                SizedBox(height: 16),
                Text(
                  'Status Pengiriman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildShippingRoute(),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(cartItems, name, address, phone,
                              totalAfterDiscount);

                      Provider.of<CartProvider>(context, listen: false)
                          .clearCart();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavBar()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Kembali Berbelanja',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama: $name', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('Alamat: $address', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('No. Telepon: $phone', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderDetailsWithImages() {
    return Column(
      children: cartItems.map((item) {
        double subtotalPerItem = item.price * item.quantity;
        double discountPerItem = discountApplied
            ? subtotalPerItem * (item.discountPercentage ?? 0) / 100
            : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(item.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Harga: ${formatCurrency(item.price)} x ${item.quantity}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Subtotal: ${formatCurrency(subtotalPerItem)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    if (discountApplied && discountPerItem > 0)
                      Text(
                        'Diskon: - ${formatCurrency(discountPerItem)}',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPriceDetails(
      double subtotal, double discount, double totalAfterDiscount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: TextStyle(fontSize: 16)),
            Text(formatCurrency(subtotal), style: TextStyle(fontSize: 16)),
          ],
        ),
        if (discountApplied && discount > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Diskon Total',
                  style: TextStyle(fontSize: 16, color: Colors.red)),
              Text("-" + formatCurrency(discount),
                  style: TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
        SizedBox(height: 8),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(formatCurrency(totalAfterDiscount),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Metode Pembayaran: $paymentMethod',
              style: TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.payments, color: kprimaryColor),
        ],
      ),
    );
  }

  Widget _buildShippingRoute() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan Dikonfirmasi', style: TextStyle(fontSize: 14)),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          SizedBox(height: 4),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sedang Diproses', style: TextStyle(fontSize: 14)),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          SizedBox(height: 4),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dalam Perjalanan', style: TextStyle(fontSize: 14)),
              Icon(Icons.local_shipping, color: kprimaryColor),
            ],
          ),
          SizedBox(height: 4),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dalam Pengantaran', style: TextStyle(fontSize: 14)),
              Icon(Icons.hourglass_bottom, color: Colors.grey),
            ],
          ),
          SizedBox(height: 4),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terkirim', style: TextStyle(fontSize: 14)),
              Icon(Icons.circle_outlined, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
