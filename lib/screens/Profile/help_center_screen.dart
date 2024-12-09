import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Model untuk kategori bantuan
class HelpCategory {
  final String title; // Judul kategori
  final String description; // Deskripsi kategori
  final IconData icon; // Ikon kategori
  final int articleCount; // Jumlah artikel dalam kategori
  final List<HelpArticle> articles; // Daftar artikel dalam kategori

  HelpCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.articleCount,
    required this.articles,
  });
}

// Model untuk artikel bantuan
class HelpArticle {
  final String title; // Judul artikel
  final String content; // Konten artikel
  final bool isPinned; // Menandakan apakah artikel dipin
  final DateTime lastUpdated; // Tanggal terakhir artikel diperbarui

  HelpArticle({
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.lastUpdated,
  });
}

// Widget utama untuk layar pusat bantuan
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

// State untuk HelpCenterScreen
class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Kontroler untuk input pencarian
  bool _isSearching = false; // Menandakan apakah sedang dalam mode pencarian
  List<HelpArticle> _searchResults = []; // Hasil pencarian artikel

  // Daftar kategori bantuan
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

  // Daftar bantuan cepat
  final List<String> quickHelp = [
    'Cara melacak pesanan',
    'Cara membatalkan pesanan',
    'Cara menggunakan voucher',
    'Cara menghubungi penjual',
  ];

  // Fungsi untuk melakukan pencarian artikel berdasarkan query
  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false; // Matikan mode pencarian jika query kosong
        _searchResults = []; // Kosongkan hasil pencarian
      });
      return;
    }

    final List<HelpArticle> results = []; // Daftar hasil pencarian
    for (var category in categories) {
      for (var article in category.articles) {
        // Cek apakah judul artikel mengandung query pencarian
        if (article.title.toLowerCase().contains(query.toLowerCase())) {
          results.add(article); // Tambahkan artikel ke hasil pencarian
        }
      }
    }

    setState(() {
      _isSearching = true; // Aktifkan mode pencarian
      _searchResults = results; // Simpan hasil pencarian
    });
  }

  // Fungsi untuk menampilkan detail artikel
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

  // Metode untuk membangun bagian pencarian
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16), // Padding untuk kontainer
      decoration: BoxDecoration(
        color: kprimaryColor, // Warna latar belakang
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24), // Radius sudut kiri bawah
          bottomRight: Radius.circular(24), // Radius sudut kanan bawah
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hai, ada yang bisa kami bantu?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9), // Warna teks
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16), // Jarak vertikal
          TextField(
            controller: _searchController, // Kontroler untuk input pencarian
            style: const TextStyle(color: Colors.black87), // Warna teks input
            onChanged:
                _performSearch, // Panggil fungsi pencarian saat teks berubah
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // Warna latar belakang input
              hintText: "Cari bantuan...", // Teks petunjuk
              hintStyle:
                  TextStyle(color: Colors.grey[400]), // Warna teks petunjuk
              prefixIcon: const Icon(Icons.search,
                  color: Colors.grey), // Ikon pencarian
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon:
                          const Icon(Icons.clear), // Ikon untuk menghapus input
                      onPressed: () {
                        _searchController.clear(); // Kosongkan input
                        _performSearch(
                            ''); // Lakukan pencarian dengan query kosong
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Radius sudut input
                borderSide: BorderSide.none, // Tidak ada garis tepi
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

  // Metode untuk membangun hasil pencarian
  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(16), // Padding untuk hasil pencarian
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil Pencarian (${_searchResults.length})', // Menampilkan jumlah hasil pencarian
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12), // Jarak vertikal
          if (_searchResults.isEmpty)
            _buildEmptySearchResults() // Tampilkan pesan jika tidak ada hasil
          else
            _buildSearchResultsList(), // Tampilkan daftar hasil pencarian
        ],
      ),
    );
  }

  // Metode untuk membangun pesan jika tidak ada hasil pencarian
  Widget _buildEmptySearchResults() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32), // Jarak vertikal
          Icon(
            Icons.search_off_outlined,
            size: 48,
            color: Colors.grey[400], // Warna ikon
          ),
          const SizedBox(height: 16), // Jarak vertikal
          Text(
            'Tidak ada hasil yang ditemukan', // Pesan tidak ada hasil
            style: TextStyle(
              color: Colors.grey[600], // Warna teks
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk membangun daftar hasil pencarian
  Widget _buildSearchResultsList() {
    return ListView.builder(
      shrinkWrap: true, // Mengatur ukuran daftar
      physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll
      itemCount: _searchResults.length, // Jumlah item dalam daftar
      itemBuilder: (context, index) {
        final article =
            _searchResults[index]; // Ambil artikel dari hasil pencarian
        return ListTile(
          title: Text(article.title), // Judul artikel
          leading: const Icon(Icons.article_outlined),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showArticleDetail(context, article),
        );
      },
    );
  }

  // Metode untuk membangun bagian bantuan cepat
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

  // Widget untuk membangun kategori bantuan
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Padding horizontal
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Mengatur alignment ke kiri
        children: [
          const Text(
            "Kategori Bantuan", // Judul kategori
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16), // Jarak vertikal
          ListView.builder(
            shrinkWrap: true, // Mengatur ukuran ListView
            physics:
                const NeverScrollableScrollPhysics(), // Menonaktifkan scroll
            itemCount: categories.length, // Jumlah kategori
            itemBuilder: (context, index) {
              final category =
                  categories[index]; // Mengambil kategori berdasarkan index
              return Card(
                elevation: 0, // Mengatur elevasi kartu
                margin: const EdgeInsets.only(bottom: 12), // Margin bawah
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Mengatur sudut kartu
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: InkWell(
                  onTap: () {
                    // Navigasi ke layar kategori bantuan saat diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpCategoryScreen(
                          category: category, // Mengirim kategori ke layar baru
                        ),
                      ),
                    );
                  },
                  borderRadius:
                      BorderRadius.circular(12), // Mengatur sudut InkWell
                  child: Padding(
                    padding: const EdgeInsets.all(16), // Padding dalam kartu
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(12), // Padding dalam ikon
                          decoration: BoxDecoration(
                            color: kprimaryColor
                                .withOpacity(0.1), // Warna latar belakang
                            borderRadius:
                                BorderRadius.circular(12), // Sudut bulat
                          ),
                          child: Icon(
                            category.icon, // Ikon kategori
                            color: kprimaryColor, // Warna ikon
                            size: 24, // Ukuran ikon
                          ),
                        ),
                        const SizedBox(width: 16), // Jarak horizontal
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Mengatur alignment ke kiri
                            children: [
                              Text(
                                category.title, // Judul kategori
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4), // Jarak vertikal
                              Text(
                                category.description, // Deskripsi kategori
                                style: TextStyle(
                                  color:
                                      Colors.grey[600], // Warna teks deskripsi
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4), // Jarak vertikal
                              Text(
                                '${category.articleCount} artikel', // Jumlah artikel
                                style: TextStyle(
                                  color: Colors
                                      .grey[400], // Warna teks jumlah artikel
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios, // Ikon panah
                          size: 16,
                          color: Colors.grey[400], // Warna ikon panah
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

  // Widget untuk membangun kontak dukungan
  Widget _buildContactSupport() {
    return Padding(
      padding: const EdgeInsets.all(16), // Padding di sekitar kartu
      child: Card(
        elevation: 0, // Mengatur elevasi kartu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sudut bulat
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: InkWell(
          onTap: () => _showContactSupportDialog(
              context), // Menampilkan dialog kontak dukungan saat diklik
          borderRadius: BorderRadius.circular(12), // Mengatur sudut InkWell
          child: Padding(
            padding: const EdgeInsets.all(16), // Padding dalam kartu
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12), // Padding dalam ikon
                  decoration: BoxDecoration(
                    color:
                        kprimaryColor.withOpacity(0.1), // Warna latar belakang
                    borderRadius: BorderRadius.circular(12), // Sudut bulat
                  ),
                  child: Icon(
                    Icons.headset_mic_outlined, // Ikon headset
                    color: kprimaryColor, // Warna ikon headset
                    size: 24, // Ukuran ikon
                  ),
                ),
                const SizedBox(width: 16), // Jarak horizontal
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Mengatur alignment ke kiri
                    children: [
                      const Text(
                        'Hubungi Layanan Pelanggan', // Judul untuk kontak dukungan
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4), // Jarak vertikal
                      Text(
                        'Butuh bantuan lebih lanjut? Hubungi kami', // Deskripsi kontak dukungan
                        style: TextStyle(
                          color: Colors.grey[600], // Warna teks deskripsi
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios, // Ikon panah
                  size: 16,
                  color: Colors.grey[400], // Warna ikon panah
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog kontak dukungan
  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Kami'), // Judul dialog
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ukuran kolom minimal
          children: [
            ListTile(
              leading: const Icon(Icons.chat), // Ikon obrolan
              title: const Text('Obrolan Langsung'), // Judul opsi obrolan
              subtitle:
                  const Text('Respon cepat 24/7'), // Subjudul opsi obrolan
              onTap: () {
                Navigator.pop(context); // Menutup dialog
                // Implementasi navigasi obrolan langsung
              },
            ),
            ListTile(
              leading: const Icon(Icons.email), // Ikon email
              title: const Text('Email'), // Judul opsi email
              subtitle: const Text('anangpraf04@gmail.com'), // Subjudul email
              onTap: () {
                Navigator.pop(context); // Menutup dialog
                // Implementasi fungsi email
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone), // Ikon telepon
              title: const Text('Telepon'), // Judul opsi telepon
              subtitle: const Text('089529717594'), // Subjudul telepon
              onTap: () {
                Navigator.pop(context); // Menutup dialog
                // Implementasi fungsi panggilan telepon
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context), // Menutup dialog saat tombol ditekan
            child: const Text('Tutup'), // Teks tombol
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Menghapus controller pencarian saat widget dibuang
    super.dispose(); // Memanggil metode dispose dari superclass
  }
}

// Kelas untuk layar kategori bantuan
class HelpCategoryScreen extends StatelessWidget {
  final HelpCategory category; // Kategori bantuan yang diterima

  const HelpCategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title, // Judul kategori
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kprimaryColor, // Warna latar belakang AppBar
        centerTitle: true, // Mengatur judul ke tengah
        iconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon di AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16), // Padding di sekitar konten
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Mengatur alignment ke kiri
            children: [
              _buildCategoryHeader(), // Memanggil fungsi untuk membangun header kategori
              const SizedBox(height: 24), // Jarak vertikal
              _buildPinnedArticles(), // Memanggil fungsi untuk membangun artikel yang dipin
              const SizedBox(height: 24), // Jarak vertikal
              _buildAllArticles(), // Memanggil fungsi untuk membangun semua artikel
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun header kategori
  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.all(16), // Padding di dalam header
      decoration: BoxDecoration(
        color: Colors.grey[100], // Warna latar belakang header
        borderRadius: BorderRadius.circular(12), // Sudut bulat
      ),
      child: Row(
        children: [
          Icon(
            category.icon, // Ikon kategori
            color: kprimaryColor, // Warna ikon
            size: 32, // Ukuran ikon
          ),
          const SizedBox(width: 16), // Jarak horizontal
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Mengatur alignment ke kiri
              children: [
                Text(
                  category.description, // Deskripsi kategori
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87, // Warna teks deskripsi
                  ),
                ),
                const SizedBox(height: 4), // Jarak vertikal
                Text(
                  '${category.articleCount} artikel tersedia', // Jumlah artikel yang tersedia
                  style: TextStyle(
                    color: Colors.grey[600], // Warna teks jumlah artikel
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

  // Widget untuk membangun artikel yang dipin
  Widget _buildPinnedArticles() {
    final pinnedArticles = category.articles
        .where((article) => article.isPinned)
        .toList(); // Mengambil artikel yang dipin
    if (pinnedArticles.isEmpty)
      return const SizedBox
          .shrink(); // Jika tidak ada artikel yang dipin, kembalikan widget kosong

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Mengatur alignment ke kiri
      children: [
        const Text(
          'Artikel Populer', // Judul untuk artikel populer
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12), // Jarak vertikal
        ListView.builder(
          shrinkWrap: true, // Mengatur ukuran ListView
          physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll
          itemCount: pinnedArticles.length, // Jumlah artikel yang dipin
          itemBuilder: (context, index) {
            final article =
                pinnedArticles[index]; // Mengambil artikel berdasarkan index
            return Card(
              elevation: 0, // Mengatur elevasi kartu
              margin: const EdgeInsets.only(bottom: 8), // Margin bawah
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Sudut bulat
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.star_outline,
                    color: Colors.amber), // Ikon bintang
                title: Text(article.title), // Judul artikel
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16), // Ikon panah
                onTap: () {
                  // Navigasi ke layar detail artikel saat diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                          article: article), // Mengirim artikel ke layar detail
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

  // Widget untuk membangun semua artikel
  Widget _buildAllArticles() {
    final regularArticles = category.articles
        .where((article) => !article.isPinned)
        .toList(); // Mengambil artikel yang tidak dipin

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Mengatur alignment ke kiri
      children: [
        const Text(
          'Semua Artikel', // Judul untuk semua artikel
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12), // Jarak vertikal
        ListView.builder(
          shrinkWrap: true, // Mengatur ukuran ListView
          physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll
          itemCount: regularArticles.length, // Jumlah artikel reguler
          itemBuilder: (context, index) {
            final article =
                regularArticles[index]; // Mengambil artikel berdasarkan index
            return Card(
              elevation: 0, // Mengatur elevasi kartu
              margin: const EdgeInsets.only(bottom: 8), // Margin bawah
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Sudut bulat
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.article_outlined), // Ikon artikel
                title: Text(article.title), // Judul artikel
                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 16), // Ikon panah
                onTap: () {
                  // Navigasi ke layar detail artikel saat diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                          article: article), // Mengirim artikel ke layar detail
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

// Kelas untuk layar detail artikel
class ArticleDetailScreen extends StatelessWidget {
  final HelpArticle article; // Artikel yang diterima

  const ArticleDetailScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Artikel', // Judul layar detail artikel
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kprimaryColor, // Warna latar belakang AppBar
        centerTitle: true, // Mengatur judul ke tengah
        iconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon di AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Mengatur alignment ke kiri
          children: [
            Container(
              width: double.infinity, // Lebar penuh
              padding: const EdgeInsets.all(16), // Padding di dalam konten
              decoration: BoxDecoration(
                color: Colors.white, // Warna latar belakang konten
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.1), // Bayangan di bawah konten
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Mengatur alignment ke kiri
                children: [
                  if (article.isPinned) // Jika artikel dipin
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 8), // Margin bawah
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(
                            0.1), // Warna latar belakang untuk artikel populer
                        borderRadius: BorderRadius.circular(4), // Sudut bulat
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Ukuran baris minimal
                        children: [
                          Icon(
                            Icons.star, // Ikon bintang
                            size: 16,
                            color: Colors.amber, // Warna ikon bintang
                          ),
                          SizedBox(width: 4), // Jarak horizontal
                          Text(
                            'Artikel Populer', // Teks untuk artikel populer
                            style: TextStyle(
                              color: Colors.amber, // Warna teks
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    article.title, // Judul artikel
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak vertikal
                  Text(
                    'Terakhir diperbarui: ${_formatDate(article.lastUpdated)}', // Tanggal terakhir diperbarui
                    style: TextStyle(
                      color: Colors.grey[600], // Warna teks tanggal
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(16), // Padding di sekitar konten artikel
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Mengatur alignment ke kiri
                children: [
                  Text(
                    article.content, // Konten artikel
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6, // Jarak antar baris
                    ),
                  ),
                  const SizedBox(height: 32), // Jarak vertikal
                  const Text(
                    'Apakah artikel ini membantu?', // Pertanyaan untuk umpan balik
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16), // Jarak vertikal
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Mengatur alignment ke tengah
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
      // Widget untuk bottom navigation bar dengan tombol kontak support
      bottomNavigationBar: Container(
        // Padding di sekitar tombol
        padding: const EdgeInsets.all(16),

        // Dekorasi container dengan bayangan dan warna putih
        decoration: BoxDecoration(
          color: Colors.white,
          // Membuat bayangan ringan di sekitar container
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),

        // Tombol elevated dengan ikon chat
        child: ElevatedButton.icon(
          // Aksi yang akan dijalankan saat tombol ditekan
          onPressed: () {
            // TODO: Implementasikan fungsi chat dengan support
          },

          // Ikon chat di sebelah kiri teks
          icon: const Icon(Icons.chat_outlined),

          // Label teks tombol
          label: const Text('Hubungi Support'),

          // Gaya tombol dengan warna dan desain khusus
          style: ElevatedButton.styleFrom(
            backgroundColor: kprimaryColor, // Warna latar belakang tombol
            foregroundColor: Colors.white, // Warna teks dan ikon
            padding:
                const EdgeInsets.symmetric(vertical: 12), // Padding vertikal
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Sudut melengkung
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

  // Fungsi untuk menangani feedback dari pengguna
  void _handleFeedback(BuildContext context, bool isHelpful) {
    // Menampilkan snackbar sebagai respon feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Konten pesan berbeda berdasarkan jenis feedback
        content: Text(
          isHelpful
              ? 'Terima kasih atas feedback positif Anda!'
              : 'Maaf artikel ini kurang membantu. Kami akan terus meningkatkan konten kami.',
        ),

        // Gaya snackbar mengambang
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

// Fungsi untuk memformat tanggal ke dalam format dd/mm/yyyy
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
