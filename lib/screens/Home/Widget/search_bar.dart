import 'package:ecommerce_mobile_app/constants.dart';
import 'package:flutter/material.dart';


class MySearchBAR extends StatelessWidget {
  final Function(String) onSearch;
  const MySearchBAR({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: TextField(
              onChanged: (value) {
                onSearch(value); // Panggil fungsi pencarian
              },
              decoration: InputDecoration(
                hintText: "Cari produk...",
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 25,
            width: 1.5,
            color: Colors.grey,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
