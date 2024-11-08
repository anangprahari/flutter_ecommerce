import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../Provider/order_provider.dart';
import '../../models/product_model.dart';
import '../../constants.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

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
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan Saya',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kprimaryColor,
      ),
      backgroundColor: kcontentColor,
      body: orders.isEmpty
          ? Container(
              color: kcontentColor,
              child: Center(
                child: Text(
                  'Tidak ada pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                List<Product> products = order['products'];
                bool discountApplied = order['discountApplied'] ?? false;
                double totalPrice = order['totalPriceWithDiscount'];
                double totalSubtotal = products.fold(
                    0, (sum, item) => sum + (item.price * item.quantity));
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
                        // Informasi Pengiriman
                        Text(
                          'Informasi Pengiriman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildShippingInfo(order),
                        SizedBox(height: 16),

                        // Detail Pesanan
                        Text(
                          'Detail Pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildOrderDetails(products, discountApplied),
                        SizedBox(height: 16),

                        // Rincian Harga
                        Text(
                          'Rincian Harga',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildPriceDetails(totalSubtotal, totalDiscount,
                            totalPrice, discountApplied),
                        SizedBox(height: 16),

                        // Metode Pembayaran
                        Text(
                          'Metode Pembayaran',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildPaymentMethod(orderProvider.paymentMethod),
                        SizedBox(height: 16),

                        // Status Pengiriman
                        Text(
                          'Status Pengiriman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildShippingRoute(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildShippingInfo(Map<String, dynamic> order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama: ${order['name']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('Alamat: ${order['address']}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text('No. Telepon: ${order['phone']}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildOrderDetails(List<Product> products, bool discountApplied) {
    return Column(
      children: products.map((item) {
        double subtotalPerItem = item.price * item.quantity;
        double discountPerItem = discountApplied
            ? subtotalPerItem * (item.discountPercentage ?? 0) / 100
            : 0;

        return Column(
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
      double subtotal, double discount, double total, bool discountApplied) {
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
              Text('Diskon', style: TextStyle(fontSize: 16, color: Colors.red)),
              Text(
                '- ${formatCurrency(discount)}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(formatCurrency(total),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String paymentMethod) {
    return Text(
      paymentMethod,
      style: TextStyle(fontSize: 16),
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
