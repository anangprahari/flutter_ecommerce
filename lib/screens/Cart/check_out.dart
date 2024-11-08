import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/screens/Cart/checkout_screen.dart';
import 'package:intl/intl.dart';

class CheckOutBox extends StatefulWidget {
  const CheckOutBox({super.key});

  @override
  State<CheckOutBox> createState() => _CheckOutBoxState();
}

class _CheckOutBoxState extends State<CheckOutBox> {
  final TextEditingController _discountController = TextEditingController();
  bool _isDiscountApplied = false;

  void _applyDiscount() {
    setState(() {
      _isDiscountApplied =
          _discountController.text.trim().toLowerCase() == "jenshop";
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    double subtotal = 0;
    double discountAmount = 0;
    double total = 0;

    // Menghitung subtotal dan diskon per produk
    List<Map<String, dynamic>> productDetails =
        []; // Menyimpan rincian per produk
    for (var product in provider.cart) {
      double productSubtotal = product.price * product.quantity;
      double productDiscountAmount = 0;

      if (_isDiscountApplied &&
          product.discountPercentage != null &&
          product.discountPercentage! > 0) {
        productDiscountAmount =
            productSubtotal * (product.discountPercentage! / 100);
        discountAmount += productDiscountAmount;
      }

      subtotal += productSubtotal;
      total += (productSubtotal - productDiscountAmount);

      // Menambahkan rincian per produk ke list productDetails
      productDetails.add({
        'name': product.title,
        'price': product.price,
        'quantity': product.quantity,
        'subtotal': productSubtotal,
        'discount': productDiscountAmount,
      });
    }

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _discountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  filled: true,
                  fillColor: kcontentColor,
                  hintText: "Masukkan Kode Diskon",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  suffixIcon: TextButton(
                    onPressed: _applyDiscount,
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kprimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Rincian per produk
              ...productDetails.map((product) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Harga: Rp. ${NumberFormat.decimalPattern('id').format(product['price'])} x ${product['quantity']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Subtotal: Rp. ${NumberFormat.decimalPattern('id').format(product['subtotal'])}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      if (_isDiscountApplied)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Diskon:",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "- Rp. ${NumberFormat.decimalPattern('id').format(product['discount'])}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                    ],
                  )),
              const Divider(),

              // Tampilkan Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                        .format(subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tampilkan Diskon Total jika sudah diapply
              if (_isDiscountApplied)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Diskon Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "- " +
                          NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp. ',
                                  decimalDigits: 0)
                              .format(discountAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              // Tampilkan Total Pembayaran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Pembayaran",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                        .format(total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Check Out
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        subtotal: subtotal,
                        discountApplied: _isDiscountApplied,
                        total: total,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Check Out",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
