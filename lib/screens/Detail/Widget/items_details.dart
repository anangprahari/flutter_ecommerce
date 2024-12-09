import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/constants.dart';
import 'reviews_screen.dart';

// Widget StatelessWidget untuk menampilkan detail produk secara menyeluruh
class ItemsDetails extends StatelessWidget {
  // Parameter produk yang akan ditampilkan
  final Product product;

  // Konstruktor dengan parameter wajib product
  const ItemsDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memformat harga produk dalam rupiah dengan konfigurasi lokal Indonesia
    final formattedPrice = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(product.price);

    // Struktur utama tampilan detail produk
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian judul dan informasi penjual
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan judul produk
            Text(
              product.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            // Menampilkan nama penjual
            Text(
              'Penjual: ${product.seller}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Bagian harga produk
        _buildPriceSection(formattedPrice),
        const SizedBox(height: 20),
        // Bagian rating dan ulasan
        _buildRatingSection(context),
        // Menampilkan spesifikasi produk jika tersedia
        if (product.specifications.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSpecifications(),
        ],
        const SizedBox(height: 16),
        // Informasi pengiriman dan garansi
        _buildDeliveryInfo(),
      ],
    );
  }

  // Metode untuk membangun section harga produk
  Widget _buildPriceSection(String formattedPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kprimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Kolom harga produk saat ini
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Harga',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedPrice,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: kprimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Menampilkan harga asli dan diskon jika tersedia
          if (product.originalPrice != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harga Asli',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp. ${NumberFormat.currency(
                    locale: 'id',
                    symbol: '',
                    decimalDigits: 0,
                  ).format(product.originalPrice)}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Label persentase diskon
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-${product.discountPercentage}%',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Metode untuk membangun section rating dan ulasan
  Widget _buildRatingSection(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigasi ke layar ulasan saat di-tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewsScreen(reviews: product.reviews),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Kontainer rating bintang
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kprimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: kprimaryColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    product.rate.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kprimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Informasi jumlah ulasan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.reviewCount} Ulasan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ketuk untuk membaca semua ulasan',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk menampilkan spesifikasi produk
  Widget _buildSpecifications() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: product.specifications.map((spec) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            spec,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Metode untuk menampilkan informasi pengiriman dan garansi
  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Informasi pengiriman gratis
          if (product.freeShipping)
            _buildInfoRow(
              icon: Icons.local_shipping_outlined,
              title: 'Pengiriman Gratis',
              subtitle: 'Pesanan di atas Rp. 200.000',
            ),
          if (product.freeShipping && product.returns30Days)
            const SizedBox(height: 12),
          // Informasi pengembalian barang
          if (product.returns30Days)
            _buildInfoRow(
              icon: Icons.replay_outlined,
              title: 'Pengembalian 30 Hari',
              subtitle: 'Pengembalian atau penukaran dalam waktu 30 hari',
            ),
          if ((product.freeShipping || product.returns30Days) &&
              product.warranty)
            const SizedBox(height: 12),
          // Informasi garansi produk
          if (product.warranty)
            _buildInfoRow(
              icon: Icons.verified_user_outlined,
              title: 'Termasuk Garansi',
              subtitle: 'Garansi produk satu tahun',
            ),
        ],
      ),
    );
  }

  // Metode untuk membangun baris informasi dengan ikon, judul, dan subjudul
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        // Kontainer ikon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Icon(icon, size: 20, color: kprimaryColor),
        ),
        const SizedBox(width: 12),
        // Informasi teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
