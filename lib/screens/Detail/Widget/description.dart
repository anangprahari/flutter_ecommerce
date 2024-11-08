import 'package:ecommerce_mobile_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';

class Description extends StatefulWidget {
  final Product product;

  const Description({Key? key, required this.product}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTab("Description", 0),
            _buildTab("Specifications", 1),
            _buildTab("Shipping", 2),
          ],
        ),
        const SizedBox(height: 16), // Mengurangi height dari SizedBox
        IndexedStack(
          index: selectedTab,
          children: [
            _buildDescription(),
            _buildSpecifications(),
            _buildShipping(),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        width: 100, // Mengurangi lebar tab agar sesuai dengan layar lebih kecil
        height: 36, // Mengurangi tinggi tab
        decoration: BoxDecoration(
          color: isSelected ? kprimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14, // Mengurangi ukuran font
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.product.description,
      style: const TextStyle(
        fontSize: 14, // Mengurangi ukuran font
        color: Colors.grey,
        height: 1.4,
      ),
    );
  }

  Widget _buildSpecifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.product.specifications.map((spec) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), // Mengurangi padding vertikal
          child: Row(
            children: [
              const Icon(Icons.check_circle,
                  size: 14, color: Colors.blue), // Mengurangi ukuran ikon
              const SizedBox(width: 6), // Mengurangi jarak antar elemen
              Text(
                spec,
                style: const TextStyle(fontSize: 14), // Mengurangi ukuran font
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShipping() {
    return Column(
      children: [
        if (widget.product.freeShipping)
          const ListTile(
            leading: Icon(Icons.local_shipping,
                color: Colors.blue, size: 20), // Mengurangi ukuran ikon
            title: Text('Free Shipping',
                style: TextStyle(fontSize: 14)), // Mengurangi ukuran font
          ),
        if (widget.product.returns30Days)
          const ListTile(
            leading: Icon(Icons.refresh, color: Colors.blue, size: 20),
            title: Text('30-Day Returns', style: TextStyle(fontSize: 14)),
          ),
        if (widget.product.warranty)
          const ListTile(
            leading: Icon(Icons.security, color: Colors.blue, size: 20),
            title: Text('2-Year Warranty', style: TextStyle(fontSize: 14)),
          ),
      ],
    );
  }
}
