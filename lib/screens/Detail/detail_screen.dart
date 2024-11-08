import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/addto_cart.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/description.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/detail_app_bar.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/image_slider.dart';
import 'package:ecommerce_mobile_app/screens/Detail/Widget/items_details.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  Color? selectedColor;
  String? selectedSize;
  int currentImage = 0;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.product.colors.first;
    selectedSize = widget.product.sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kcontentColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: DetailAppBar(product: widget.product),
                          ),
                        ),
                        const SizedBox(height: 4),
                        MyImageSlider(
                          image: widget.product.image,
                          onChange: (index) {
                            setState(() {
                              currentImage = index;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemsDetails(product: widget.product),
                        const SizedBox(height: 24),
                        const Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.product.colors
                              .map((color) => _buildColorOption(color))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.product.sizes
                              .map((size) => _buildSizeOption(size))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        Description(product: widget.product),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kcontentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 16),
            child: AddToCart(
              product: widget.product,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  quantity = newQuantity.clamp(1, 99);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selectedColor == color ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedSize == size ? Colors.orange : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(4),
          color: selectedSize == size ? Colors.orange[100] : Colors.white,
        ),
        child: Text(
          size,
          style: TextStyle(
            color: selectedSize == size ? Colors.orange : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
