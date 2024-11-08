import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/constants.dart'; // Import untuk warna kcontentColor dan kprimaryColor

class ReviewsScreen extends StatelessWidget {
  final List<Review> reviews;
  const ReviewsScreen({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor, // Set warna background
      appBar: AppBar(
        title: const Text(
          'Customer Reviews',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kprimaryColor, // Warna AppBar menggunakan warna utama
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: kprimaryColor,
                      child: Text(
                        review.username[0],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(
                              5,
                              (starIndex) => Icon(
                                Icons.star,
                                color: starIndex < review.rating
                                    ? kprimaryColor
                                    : Colors.grey.shade300,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
