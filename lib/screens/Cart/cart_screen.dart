import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/screens/Cart/check_out.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final finalList = provider.cart;

    producrQuantity(IconData icon, int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            icon == Icons.add
                ? provider.incrementQtn(index)
                : provider.decrementQtn(index);
          });
        },
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
      );
    }

    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: finalList.length,
                itemBuilder: (context, index) {
                  final cartItems = finalList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kcontentColor,
                            ),
                            child:
                                Image.asset(cartItems.image, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItems.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  cartItems.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp. ',
                                          decimalDigits: 0)
                                      .format(cartItems.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    producrQuantity(Icons.remove, index),
                                    const SizedBox(width: 10),
                                    Text(
                                      cartItems.quantity.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    producrQuantity(Icons.add, index),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              finalList.removeAt(index);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const CheckOutBox(),
          ],
        ),
      ),
    );
  }
}
