import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Models
class HelpCategory {
  final String title;
  final String description;
  final IconData icon;
  final int articleCount;
  final List<HelpArticle> articles;

  HelpCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.articleCount,
    required this.articles,
  });
}

class HelpArticle {
  final String title;
  final String content;
  final bool isPinned;
  final DateTime lastUpdated;

  HelpArticle({
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.lastUpdated,
  });
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<HelpArticle> _searchResults = [];

  final List<HelpCategory> categories = [
    HelpCategory(
      title: 'Pemesanan & Pembayaran',
      description: 'Cara pesan, pembayaran, dan status pesanan',
      icon: Icons.shopping_bag_outlined,
      articleCount: 15,
      articles: [
        HelpArticle(
          title: 'Cara melakukan pemesanan',
          content: '''
1. Pilih produk yang ingin Anda beli
2. Klik tombol "Tambah ke Keranjang"
3. Buka halaman keranjang belanja Anda
4. Periksa kembali pesanan Anda
5. Klik "Lanjut ke Pembayaran"
6. Isi informasi pengiriman dengan lengkap
7. Pilih metode pengiriman yang diinginkan
8. Pilih metode pembayaran
9. Periksa kembali total pembayaran
10. Klik "Konfirmasi Pesanan"

Setelah pesanan dikonfirmasi, Anda akan menerima email konfirmasi pesanan yang berisi detail pesanan dan instruksi pembayaran (jika menggunakan transfer bank).

Tips:
- Pastikan alamat pengiriman sudah benar
- Simpan nomor pesanan untuk melacak status pesanan
- Selesaikan pembayaran sesuai batas waktu yang ditentukan''',
          isPinned: true,
          lastUpdated: DateTime.now(),
        ),
        HelpArticle(
          title: 'Metode pembayaran yang tersedia',
          content: '''
Kami menyediakan berbagai metode pembayaran untuk kemudahan Anda:

1. Transfer Bank
   - BCA
   - Mandiri
   - BNI
   - BRI
   Pembayaran harus dilakukan dalam waktu 24 jam setelah pesanan dibuat.

2. E-Wallet
   - GoPay
   - OVO
   - DANA
   - ShopeePay
   Pembayaran langsung diverifikasi secara otomatis.

3. Virtual Account
   - BCA Virtual Account
   - Mandiri Virtual Account
   - BNI Virtual Account
   Nomor Virtual Account akan diberikan setelah checkout.

4. Kartu Kredit
   - Visa
   - Mastercard
   - JCB
   Transaksi aman dengan enkripsi SSL.

5. Cicilan
   - Cicilan 0% tersedia untuk pembelian minimal Rp 1.000.000
   - Tersedia untuk kartu kredit bank tertentu
   - Tenor 3, 6, dan 12 bulan

Catatan Penting:
- Pastikan melakukan pembayaran sesuai nominal yang tertera
- Simpan bukti pembayaran sampai pesanan diterima
- Pembayaran yang sudah diverifikasi tidak dapat dibatalkan''',
          lastUpdated: DateTime.now(),
        ),
      ],
    ),
    HelpCategory(
      title: 'Pengiriman',
      description: 'Informasi pengiriman dan tracking',
      icon: Icons.local_shipping_outlined,
      articleCount: 10,
      articles: [
        HelpArticle(
          title: 'Cara melacak pesanan',
          content: '''
Anda dapat melacak status pengiriman pesanan Anda dengan cara berikut:

1. Melalui Website/Aplikasi
   - Login ke akun Anda
   - Buka menu "Pesanan Saya"
   - Pilih pesanan yang ingin dilacak
   - Klik "Lacak Pesanan"
   - Nomor resi akan muncul beserta status terkini

2. Melalui Ekspedisi Langsung
   - Catat nomor resi pengiriman Anda
   - Kunjungi website ekspedisi terkait:
     * JNE: www.jne.co.id
     * J&T: www.jet.co.id
     * SiCepat: www.sicepat.com
     * Anteraja: www.anteraja.id
   - Masukkan nomor resi pada kolom pelacakan

Status Pengiriman:
- Pesanan Dikemas: Barang sedang disiapkan
- Diserahkan ke Kurir: Barang dalam perjalanan ke gudang ekspedisi
- Dalam Pengiriman: Barang sedang diantar ke alamat Anda
- Sampai Tujuan: Barang sudah diterima

Tips Pelacakan:
- Simpan nomor resi dengan baik
- Cek status secara berkala
- Pastikan nomor telepon aktif untuk menerima notifikasi
- Hubungi CS jika status tidak update dalam 24 jam''',
          isPinned: true,
          lastUpdated: DateTime.now(),
        ),
      ],
    ),
    HelpCategory(
      title: 'Pengembalian & Refund',
      description: 'Kebijakan retur dan proses refund',
      icon: Icons.replay_outlined,
      articleCount: 8,
      articles: [
        HelpArticle(
          title: 'Syarat dan ketentuan pengembalian',
          content: '''
Kebijakan Pengembalian Barang:

1. Syarat Pengembalian
   - Barang belum digunakan/masih tersegel
   - Kemasan utuh dan tidak rusak
   - Masih dalam periode 7 hari setelah diterima
   - Menyertakan nota pembelian asli
   - Lengkap dengan aksesoris dan hadiah (jika ada)

2. Alasan Pengembalian yang Diterima
   - Barang rusak saat diterima
   - Barang tidak sesuai deskripsi
   - Kesalahan pengiriman barang
   - Ukuran tidak sesuai (khusus fashion)
   - Cacat produksi

3. Proses Pengembalian
   a. Ajukan komplain melalui aplikasi/website
   b. Foto bukti kerusakan/ketidaksesuaian
   c. Tunggu persetujuan dari tim kami
   d. Kemas barang dengan aman
   e. Kirim barang menggunakan ekspedisi yang ditentukan
   f. Sertakan nomor return yang diberikan

4. Proses Refund
   - Pengembalian dana 2-14 hari kerja
   - Metode refund sesuai pembayaran awal
   - Transfer bank: 2-3 hari kerja
   - E-wallet: 1-2 hari kerja
   - Kartu kredit: 7-14 hari kerja

5. Biaya Pengembalian
   - Kesalahan toko: gratis
   - Kesalahan pembeli: ditanggung pembeli
   - Ongkir refund sesuai kebijakan toko

Catatan Penting:
- Simpan selalu bukti pengiriman barang return
- Foto kondisi barang sebelum dikemas
- Pastikan mengemas dengan aman untuk menghindari kerusakan
- Proses refund dimulai setelah barang diterima dan dicek''',
          isPinned: true,
          lastUpdated: DateTime.now(),
        ),
      ],
    ),
    HelpCategory(
      title: 'Akun & Keamanan',
      description: 'Pengaturan akun dan keamanan',
      icon: Icons.security_outlined,
      articleCount: 12,
      articles: [
        HelpArticle(
          title: 'Cara mengubah password',
          content: '''
Panduan Mengubah Password Akun:

1. Melalui Website/Aplikasi
   a. Login ke akun Anda
   b. Buka menu "Pengaturan Akun"
   c. Pilih "Keamanan"
   d. Klik "Ubah Password"
   e. Masukkan password lama
   f. Masukkan password baru
   g. Konfirmasi password baru
   h. Klik "Simpan"

2. Melalui Lupa Password
   a. Klik "Lupa Password" di halaman login
   b. Masukkan email terdaftar
   c. Cek email untuk link reset password
   d. Klik link yang diterima
   e. Masukkan password baru
   f. Konfirmasi password baru

Ketentuan Password:
- Minimal 8 karakter
- Kombinasi huruf besar dan kecil
- Minimal 1 angka
- Minimal 1 karakter khusus
- Tidak boleh sama dengan password sebelumnya
- Tidak mengandung informasi pribadi

Tips Keamanan Password:
- Ganti password secara berkala
- Jangan gunakan password yang sama dengan akun lain
- Hindari menggunakan wifi publik saat mengganti password
- Aktifkan autentikasi 2 langkah
- Jangan bagikan password dengan siapapun
- Logout dari perangkat yang tidak digunakan

Catatan Penting:
- Password baru aktif setelah logout dan login ulang
- Simpan password di tempat yang aman
- Hubungi CS jika mengalami kesulitan''',
          isPinned: true,
          lastUpdated: DateTime.now(),
        ),
      ],
    ),
    HelpCategory(
      title: 'Promo & Voucher',
      description: 'Informasi promo dan penggunaan voucher',
      icon: Icons.card_giftcard_outlined,
      articleCount: 6,
      articles: [
        HelpArticle(
          title: 'Cara menggunakan voucher',
          content: '''
Panduan Penggunaan Voucher:

1. Jenis-Jenis Voucher
   - Voucher Diskon: Potongan harga produk
   - Voucher Ongkir: Potongan/gratis ongkos kirim
   - Voucher Cashback: Pengembalian dana setelah transaksi
   - Voucher Khusus: Promo merchant tertentu

2. Cara Mendapatkan Voucher
   - Login setiap hari untuk voucher harian
   - Ikuti social media untuk info voucher terbaru
   - Subscription member untuk voucher eksklusif
   - Rewards point dapat ditukar voucher
   - Flash sale dan event khusus

3. Cara Menggunakan Voucher
   a. Pilih produk yang ingin dibeli
   b. Masuk ke halaman keranjang
   c. Klik "Gunakan Voucher"
   d. Pilih voucher yang sesuai
   e. Klik "Terapkan"
   f. Lanjutkan ke pembayaran

4. Syarat dan Ketentuan
   - Minimal pembelian tertentu
   - Periode validitas voucher
   - Kategori produk yang berlaku
   - Maksimal potongan
   - Tidak dapat digabung dengan promo lain
   - Satu voucher per transaksi

5. Tips Menggunakan Voucher
   - Cek tanggal kadaluarsa
   - Baca syarat dan ketentuan
   - Pilih voucher dengan potongan terbesar
   - Simpan voucher di wishlist
   - Aktifkan notifikasi promo

Catatan Penting:
- Voucher tidak dapat diuangkan
- Voucher yang sudah digunakan tidak dapat dikembalikan
- Voucher kadaluarsa tidak dapat diperpanjang
- Hubungi CS untuk kendala penggunaan voucher''',
          isPinned: true,
          lastUpdated: DateTime.now(),
        ),
      ],
    ),
  ];

  final List<String> quickHelp = [
    'Cara melacak pesanan',
    'Cara membatalkan pesanan',
    'Cara menggunakan voucher',
    'Cara menghubungi penjual',
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final List<HelpArticle> results = [];
    for (var category in categories) {
      for (var article in category.articles) {
        if (article.title.toLowerCase().contains(query.toLowerCase())) {
          results.add(article);
        }
      }
    }

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  void _showArticleDetail(BuildContext context, HelpArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to live chat
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(),
              if (_isSearching)
                _buildSearchResults()
              else
                Column(
                  children: [
                    _buildQuickHelp(),
                    _buildCategories(),
                    _buildContactSupport(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Component Methods
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kprimaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hai, ada yang bisa kami bantu?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.black87),
            onChanged: _performSearch,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Cari bantuan...",
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil Pencarian (${_searchResults.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_searchResults.isEmpty)
            _buildEmptySearchResults()
          else
            _buildSearchResultsList(),
        ],
      ),
    );
  }

  Widget _buildEmptySearchResults() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.search_off_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil yang ditemukan',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final article = _searchResults[index];
        return ListTile(
          title: Text(article.title),
          leading: const Icon(Icons.article_outlined),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showArticleDetail(context, article),
        );
      },
    );
  }

  Widget _buildQuickHelp() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bantuan Cepat",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickHelp.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      for (var category in categories) {
                        for (var article in category.articles) {
                          if (article.title
                              .toLowerCase()
                              .contains(quickHelp[index].toLowerCase())) {
                            _showArticleDetail(context, article);
                            return;
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(quickHelp[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kategori Bantuan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpCategoryScreen(
                          category: category,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kprimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category.icon,
                            color: kprimaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${category.articleCount} artikel',
                                style: TextStyle(
                                  color: Colors.grey[400],
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupport() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: InkWell(
          onTap: () => _showContactSupportDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kprimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.headset_mic_outlined,
                    color: kprimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hubungi Customer Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Butuh bantuan lebih lanjut? Hubungi kami',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
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
        ),
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Kami'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Live Chat'),
              subtitle: const Text('Respon cepat 24/7'),
              onTap: () {
                Navigator.pop(context);
                // Implement live chat navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('cs@example.com'),
              onTap: () {
                Navigator.pop(context);
                // Implement email functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Telepon'),
              subtitle: const Text('0800-1234-5678'),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call functionality
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Help Category Screen
class HelpCategoryScreen extends StatelessWidget {
  final HelpCategory category;

  const HelpCategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader(),
              const SizedBox(height: 24),
              _buildPinnedArticles(),
              const SizedBox(height: 24),
              _buildAllArticles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            category.icon,
            color: kprimaryColor,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.articleCount} artikel tersedia',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedArticles() {
    final pinnedArticles =
        category.articles.where((article) => article.isPinned).toList();
    if (pinnedArticles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artikel Populer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pinnedArticles.length,
          itemBuilder: (context, index) {
            final article = pinnedArticles[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.star_outline, color: Colors.amber),
                title: Text(article.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArticleDetailScreen(article: article),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAllArticles() {
    final regularArticles =
        category.articles.where((article) => !article.isPinned).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Semua Artikel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: regularArticles.length,
          itemBuilder: (context, index) {
            final article = regularArticles[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(article.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArticleDetailScreen(article: article),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Article Detail Screen
class ArticleDetailScreen extends StatelessWidget {
  final HelpArticle article;

  const ArticleDetailScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Artikel',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kprimaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.isPinned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Artikel Populer',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terakhir diperbarui: ${_formatDate(article.lastUpdated)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Apakah artikel ini membantu?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeedbackButton(
                        context,
                        icon: Icons.thumb_up_outlined,
                        label: 'Ya',
                        onTap: () => _handleFeedback(context, true),
                      ),
                      const SizedBox(width: 16),
                      _buildFeedbackButton(
                        context,
                        icon: Icons.thumb_down_outlined,
                        label: 'Tidak',
                        onTap: () => _handleFeedback(context, false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Implement chat with support
          },
          icon: const Icon(Icons.chat_outlined),
          label: const Text('Hubungi Support'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kprimaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _handleFeedback(BuildContext context, bool isHelpful) {
    // Implement feedback handling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHelpful
              ? 'Terima kasih atas feedback positif Anda!'
              : 'Maaf artikel ini kurang membantu. Kami akan terus meningkatkan konten kami.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
