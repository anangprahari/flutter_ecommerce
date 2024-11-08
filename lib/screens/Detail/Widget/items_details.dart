import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'reviews_screen.dart'; // Import the new screen
import 'package:ecommerce_mobile_app/constants.dart'; // Import constants

class ItemsDetails extends StatelessWidget {
  final Product product;

  const ItemsDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(product.price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < product.rate.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${product.rate} (${product.reviewCount} reviews)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to ReviewsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReviewsScreen(reviews: product.reviews),
                  ),
                );
              },
              child: Text(
                'Read Reviews',
                style: TextStyle(color: kprimaryColor), // Set to kprimaryColor
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedPrice,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black, // Set to black
              ),
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 8),
              Text(
                'Rp. ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(product.originalPrice)}',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Save ${product.discountPercentage ?? 0}%',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Seller: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: product.seller,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Set to black
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
