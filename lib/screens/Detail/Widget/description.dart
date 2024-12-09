import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Widget stateful untuk menampilkan deskripsi, spesifikasi, dan informasi pengiriman produk
class Description extends StatefulWidget {
  // Produk yang akan ditampilkan detailnya
  final Product product;

  // Konstruktor dengan parameter produk yang wajib diisi
  const Description({Key? key, required this.product}) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description>
    with SingleTickerProviderStateMixin {
  // Variabel untuk melacak tab yang dipilih saat ini
  int selectedTab = 0;

  // Kontroler untuk mengatur tab
  late TabController _tabController;

  // Daftar label tab dalam bahasa Indonesia
  final List<String> _tabs = ["Deskripsi", "Spesifikasi", "Pengiriman"];

  // Kontroler scroll untuk mengatur posisi scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi kontroler tab dengan 3 tab
    _tabController = TabController(length: 3, vsync: this);
    
    // Tambahkan listener untuk mengupdate state saat tab berubah
    _tabController.addListener(() {
      setState(() {
        selectedTab = _tabController.index;
      });
      
      // Tambahkan animasi scroll ke atas saat tab berubah
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Bersihkan kontroler tab dan scroll saat widget dihapus
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget utama dengan scroll yang dapat digulir
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bangun custom tab bar
          _buildCustomTabBar(),
          const SizedBox(height: 24),
          
          // Bangun konten tab yang dipilih
          _buildTabContent(),
          const SizedBox(height: 24),
          
          // Tampilkan informasi tambahan hanya jika tab deskripsi dipilih
          if (selectedTab == 0) _buildAdditionalInfo(),
        ],
      ),
    );
  }

  // Metode untuk membuat custom tab bar dengan desain khusus
  Widget _buildCustomTabBar() {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        // Indikator tab dengan gradien warna primer
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              kprimaryColor,
              kprimaryColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: kprimaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        // Buat tab dari daftar label
        tabs: _tabs.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }

  // Metode untuk membuat desain individual tab
  Widget _buildTab(String text) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Metode untuk membuat konten tab dengan animasi transisi
  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      // Kustomisasi transisi fade dan slide
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<int>(selectedTab),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildSelectedContent(),
      ),
    );
  }

  // Metode untuk memilih konten berdasarkan tab yang aktif
  Widget _buildSelectedContent() {
    switch (selectedTab) {
      case 0:
        return _buildDescription();
      case 1:
        return _buildSpecifications();
      case 2:
        return _buildShipping();
      default:
        return const SizedBox.shrink();
    }
  }

  // Metode untuk membangun konten deskripsi produk
  Widget _buildDescription() {
    return _buildContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan ikon dan judul
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kprimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: kprimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Deskripsi Produk",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Teks deskripsi produk
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk membangun konten spesifikasi produk
  Widget _buildSpecifications() {
    return _buildContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan ikon dan judul
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kprimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: kprimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Spesifikasi Produk",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bangun daftar spesifikasi dengan animasi
          ...widget.product.specifications.asMap().entries.map(
                (entry) => _buildSpecificationItem(
                  entry.value,
                  entry.key,
                ),
              ),
        ],
      ),
    );
  }

  // Metode untuk membuat item spesifikasi dengan animasi
  Widget _buildSpecificationItem(String spec, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  // Ikon centang untuk setiap spesifikasi
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kprimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: kprimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Teks spesifikasi
                  Expanded(
                    child: Text(
                      spec,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Metode untuk membangun konten informasi pengiriman
  Widget _buildShipping() {
    return _buildContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan ikon dan judul
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kprimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: kprimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Informasi Pengiriman",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Tampilkan fitur pengiriman berdasarkan properti produk
          if (widget.product.freeShipping)
            _buildShippingFeature(
              icon: Icons.local_shipping_outlined,
              title: 'Pengiriman Ekspres Gratis',
              subtitle: 'Dikirim dalam 2-3 hari kerja',
              color: Colors.blue,
            ),
          if (widget.product.returns30Days)
            _buildShippingFeature(
              icon: Icons.refresh_outlined,
              title: 'Pengembalian 30 Hari',
              subtitle: 'Pengembalian Mudah dengan Dana Kembali Penuh',
              color: Colors.green,
            ),
          if (widget.product.warranty)
            _buildShippingFeature(
              icon: Icons.security_outlined,
              title: 'Garansi 2 Tahun',
              subtitle:
                  'Perlindungan yang Diperluas untuk Menjamin Ketenangan Anda',
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  // Metode untuk membuat kartu fitur pengiriman
  Widget _buildShippingFeature({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon dengan warna sesuai fitur
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          // Judul dan subjudul fitur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk membuat kartu konten dengan bayangan
  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // Metode untuk membangun informasi tambahan (hanya ditampilkan di tab deskripsi)
  Widget _buildAdditionalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul bagian informasi tambahan
          const Text(
            "Informasi Tambahan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Kartu informasi ketersediaan produk
          _buildInfoCard(
            icon: Icons.shopping_bag_outlined,
            title: "Tersedia",
            subtitle: "Siap dikirim",
            color: Colors.green,
          ),
          // Kartu informasi keaslian produk
          _buildInfoCard(
            icon: Icons.verified_outlined,
            title: "Produk Asli",
            subtitle: "100% produk asli",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Metode untuk membuat kartu informasi dengan ikon, judul, dan subjudul
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Kontainer ikon dengan latar belakang berwarna
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Kolom judul dan subjudul
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
