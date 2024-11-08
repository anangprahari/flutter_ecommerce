import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/Provider/favorite_provider.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Detail/detail_screen.dart';
import 'package:intl/intl.dart'; // Import intl for currency formatting

class ProductCard extends StatefulWidget {
  final Product product;
  final String priceFormatted;

  const ProductCard({
    Key? key,
    required this.product,
    required this.priceFormatted,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Function to format original price in Rupiah without decimals
  String formatRupiah(double price) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section with discount and favorite
            Stack(
              children: [
                // Product Image
                Container(
                  height: 160, // Adjusted image height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Hero(
                    tag: widget.product.image,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Image.asset(
                        widget.product.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (widget.product.discountPercentage != null)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        '-${widget.product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () {
                      provider.toggleFavorite(widget.product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        provider.isExist(widget.product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product details section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Reviews
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 10,
                            color: index < widget.product.rate.floor()
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.product.rate} (${widget.product.review})",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Row(
                    children: [
                      Text(
                        widget.priceFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.product.originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          formatRupiah(widget.product.originalPrice!),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Free shipping badge
                  if (widget.product.freeShipping)
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 12,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Free Shipping',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
