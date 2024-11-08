import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/constants.dart';

class AddToCart extends StatefulWidget {
  final Product product;
  final Function(int) onQuantityChanged;

  const AddToCart({
    Key? key,
    required this.product,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (currentIndex > 1) {
                        setState(() {
                          currentIndex--;
                        });
                        widget.onQuantityChanged(currentIndex);
                      }
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentIndex.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        currentIndex++;
                      });
                      widget.onQuantityChanged(currentIndex);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  for (int i = 0; i < currentIndex; i++) {
                    provider.toggleFavorite(widget.product);
                  }
                  const snackBar = SnackBar(
                    content: Text(
                      "Successfully added!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
