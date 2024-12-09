import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Widget StatelessWidget untuk menampilkan layar ulasan produk
class ReviewsScreen extends StatelessWidget {
  // List ulasan yang akan ditampilkan
  final List<Review> reviews;

  // Konstruktor dengan parameter wajib reviews
  const ReviewsScreen({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Struktur utama layar ulasan
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // AppBar dengan judul dan tombol filter
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Ulasan Pelanggan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Tombol filter ulasan
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Placeholder untuk implementasi filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Ringkasan ulasan (rating rata-rata, jumlah ulasan)
          _buildReviewSummary(),
          // Daftar ulasan yang dapat di-scroll
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildReviewCard(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk membangun ringkasan ulasan
  Widget _buildReviewSummary() {
    // Menghitung rating rata-rata
    double averageRating = reviews.isEmpty
        ? 0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Kolom rating utama
              Column(
                children: [
                  // Nilai rating rata-rata
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Visualisasi bintang rating
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < averageRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: kprimaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  // Jumlah total ulasan
                  Text(
                    '${reviews.length} Ulasan',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              // Kolom bar rating detail
              Expanded(
                child: Column(
                  children: List.generate(
                    5,
                    (index) => _buildRatingBar(5 - index, reviews),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Metode untuk membuat bar rating untuk setiap tingkat rating
  Widget _buildRatingBar(int rating, List<Review> reviews) {
    // Menghitung jumlah ulasan untuk rating tertentu
    int count = reviews.where((r) => r.rating == rating).length;
    // Menghitung persentase rating
    double percentage = reviews.isEmpty ? 0 : count / reviews.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // Label rating
          Text(
            '$rating',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          // Ikon bintang
          Icon(Icons.star, color: kprimaryColor, size: 16),
          const SizedBox(width: 8),
          // Progress bar untuk menunjukkan persentase rating
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Jumlah ulasan untuk rating tersebut
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk membuat kartu ulasan individual
  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris header ulasan dengan informasi pengguna
            Row(
              children: [
                // Avatar pengguna menggunakan huruf pertama nama
                CircleAvatar(
                  radius: 24,
                  backgroundColor: kprimaryColor.withOpacity(0.1),
                  child: Text(
                    review.username[0].toUpperCase(),
                    style: TextStyle(
                      color: kprimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Informasi pengguna dan rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama pengguna
                      Text(
                        review.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Baris rating dan waktu
                      Row(
                        children: [
                          // Visualisasi bintang rating
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: kprimaryColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Waktu ulasan
                          Text(
                            '2 hari yang lalu',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tombol opsi tambahan
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Placeholder untuk implementasi opsi tambahan
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Isi ulasan
            Text(
              review.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Tombol reaksi untuk ulasan
            Row(
              children: [
                // Tombol "Bermanfaat"
                _buildReactionButton(
                  icon: Icons.thumb_up_outlined,
                  label: 'Bermanfaat (24)',
                ),
                const SizedBox(width: 16),
                // Tombol "Komentar"
                _buildReactionButton(
                  icon: Icons.comment_outlined,
                  label: 'Komentar (3)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk membuat tombol reaksi pada ulasan
  Widget _buildReactionButton({
    required IconData icon,
    required String label,
  }) {
    return TextButton.icon(
      // Placeholder untuk fungsi tombol
      onPressed: () {
        // Implementasi fungsionalitas reaksi
      },
      // Konfigurasi ikon
      icon: Icon(icon, size: 16, color: Colors.grey[600]),
      // Gaya tombol
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[600],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      // Label tombol
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
