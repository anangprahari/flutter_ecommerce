import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/product_model.dart';
import '../../../Provider/favorite_provider.dart';
import '../../../constants.dart';

// Widget AppBar detail produk yang memungkinkan berbagi, kembali, dan menambah ke favorit
class DetailAppBar extends StatefulWidget {
  // Produk yang akan ditampilkan detailnya
  final Product product;
  const DetailAppBar({Key? key, required this.product}) : super(key: key);

  @override
  _DetailAppBarState createState() => _DetailAppBarState();
}

class _DetailAppBarState extends State<DetailAppBar> {
  // Variabel untuk menyimpan link dinamis produk
  String? _dynamicLink;

  @override
  void initState() {
    super.initState();
    // Membuat link dinamis saat widget diinisialisasi
    _createDynamicLink();
  }

  // Metode untuk membuat link dinamis menggunakan Firebase Dynamic Links
  Future<void> _createDynamicLink() async {
    try {
      // Konfigurasi parameter link dinamis
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://jenshop.page.link',
        // Membuat link unik berdasarkan judul produk
        link: Uri.parse(
            'https://jenshop.com/product/${widget.product.title.toLowerCase().replaceAll(' ', '-')}'),
        // Parameter untuk Android
        androidParameters: AndroidParameters(
          packageName: 'com.yourcompany.ecommerce_mobile_app',
          minimumVersion: 1,
        ),
        // Parameter untuk iOS
        iosParameters: IOSParameters(
          bundleId: 'com.yourcompany.ecommerceMobileApp',
          minimumVersion: '1.0.0',
        ),
        // Metadata sosial untuk link
        socialMetaTagParameters: SocialMetaTagParameters(
          title: widget.product.title,
          description: 'Lihat produk menarik di aplikasi kami!',
          imageUrl: Uri.parse(widget.product.image),
        ),
      );

      // Membuat short link dari parameter
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      setState(() {
        // Menyimpan short link
        _dynamicLink = shortLink.shortUrl.toString();
      });
    } catch (e) {
      // Mencetak error jika gagal membuat link dinamis
      print('Error creating dynamic link: $e');
    }
  }

  // Metode untuk memformat harga dalam mata uang Rupiah
  String formatRupiah(double price) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  // Widget tombol animasi dengan efek sentuh
  Widget _buildAnimatedButton({
    required VoidCallback onPressed,
    required Widget icon,
    required Color backgroundColor,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: IconButton(
            // Gaya tombol dengan background dan padding
            style: IconButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: const EdgeInsets.all(10),
              minimumSize: const Size(40, 40),
            ),
            onPressed: () {
              // Memberikan umpan balik getaran ringan saat ditekan
              HapticFeedback.lightImpact();
              onPressed();
            },
            icon: icon,
          ),
        );
      },
    );
  }

  // Metode untuk berbagi produk melalui aplikasi lain
  Future<void> _shareToApp({
    required String packageName,
    required String appName,
    required BuildContext context,
  }) async {
    // Memeriksa apakah link produk sudah tersedia
    if (_dynamicLink == null) {
      _showNotification(context, 'Link produk belum tersedia', Icons.error);
      return;
    }

    // Membuat teks untuk dibagikan
    final String shareText = '''
${widget.product.title}

Harga: ${formatRupiah(widget.product.price)}
Link Produk: $_dynamicLink

Bagikan di Aplikasi Lain
''';

    try {
      // Menggunakan paket share untuk berbagi teks
      await Share.share(shareText, subject: 'Lihat Produk Menarik!');
    } catch (e) {
      // Menampilkan notifikasi jika gagal berbagi
      _showNotification(context, 'Gagal berbagi produk', Icons.error);
    }
  }

  // Metode untuk menampilkan sidebar berbagi
  void _showShareSidebar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.60,
          child: Container(
            // Desain kontainer dengan bayangan dan radius
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar untuk indikasi dapat ditarik
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Konten dapat di-scroll
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul produk yang akan dibagikan
                        Text(
                          "Bagikan ${widget.product.title}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),

                        // Pratinjau produk yang akan dibagikan
                        _buildEnhancedSharePreview(),

                        const SizedBox(height: 24),

                        // Judul opsi berbagi
                        Text(
                          'Bagikan Ke',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Opsi berbagi modern
                        _buildModernShareOptions(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget pratinjau produk dengan desain modern
  Widget _buildEnhancedSharePreview() {
    return Container(
      padding: EdgeInsets.all(16),
      // Desain kontainer dengan gradient dan bayangan
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul produk
                Text(
                  widget.product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Harga diskon (jika ada)
                    if (widget.product.discountPercentage != null) ...[
                      Text(
                        formatRupiah(widget.product.originalPrice ?? 0),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // Harga akhir
                    Text(
                      formatRupiah(widget.product.price),
                      style: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Informasi penjual (jika tersedia)
                if (widget.product.seller.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Penjual: ${widget.product.seller}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget opsi berbagi modern
  Widget _buildModernShareOptions(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Opsi salin link
          _buildShareOptionTile(
            icon: Icons.link,
            title: 'Salin Link',
            subtitle: 'Salin tautan produk ke clipboard',
            onTap: () => _copyLinkToClipboard(context),
          ),
          Divider(color: Colors.grey[300], height: 1),

          // Opsi berbagi lainnya
          _buildShareOptionTile(
            icon: Icons.share,
            title: 'Bagikan Lainnya',
            subtitle: 'Gunakan berbagai aplikasi berbagi',
            onTap: () {
              Navigator.of(context).pop(); // Tutup bottom sheet
              _shareToApp(packageName: '', appName: '', context: context);
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk setiap opsi berbagi
  Widget _buildShareOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // Ikon dengan background berwarna
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kprimaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: kprimaryColor,
          size: 24,
        ),
      ),
      // Judul dan subjudul
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      onTap: () {
        // Getaran ringan saat ditekan
        HapticFeedback.lightImpact();
        onTap();
      },
      // Ikon panah di sebelah kanan
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[600],
      ),
    );
  }

  // Metode untuk menyalin link ke clipboard
  void _copyLinkToClipboard(BuildContext context) {
    if (_dynamicLink != null) {
      Clipboard.setData(ClipboardData(text: _dynamicLink!));
      _showNotification(context, "Link berhasil disalin", Icons.link);
    }
  }

  // Widget ikon berbagi (tidak digunakan dalam implementasi saat ini)
  Widget _buildShareIcon(
    String assetPath,
    String label,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 2,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              if (onTap != null) {
                onTap();
              }
            },
            customBorder: CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.asset(
                assetPath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Pratinjau berbagi versi sederhana (tidak digunakan dalam implementasi saat ini)
  Widget _buildSharePreview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Gambar produk dengan border radius
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul produk
                    Text(
                      widget.product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Harga asli dengan coret (jika ada diskon)
                        if (widget.product.discountPercentage != null) ...[
                          Text(
                            formatRupiah(widget.product.originalPrice ?? 0),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        // Harga akhir
                        Text(
                          formatRupiah(widget.product.price),
                          style: TextStyle(
                            color: kprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // Informasi penjual (jika tersedia)
                    if (widget.product.seller.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Penjual: ${widget.product.seller}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Metode untuk menampilkan notifikasi sementara
  void _showNotification(BuildContext context, String message, IconData icon) {
    // Membuat overlay entry untuk notifikasi
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Posisi notifikasi di bagian atas layar
        top: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              // Animasi scale untuk efek muncul
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                // Desain kontainer notifikasi
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ikon notifikasi
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    // Pesan notifikasi
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Memasukkan overlay entry ke layar
    Overlay.of(context).insert(overlayEntry);

    // Menghapus notifikasi setelah 2 detik
    Future.delayed(const Duration(milliseconds: 2000), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengakses provider favorit
    final provider = FavoriteProvider.of(context);

    // AppBar aman untuk area notch/status bar
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol kembali
            _buildAnimatedButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              backgroundColor: Colors.white,
            ),
            Row(
              children: [
                // Tombol berbagi
                _buildAnimatedButton(
                  onPressed: () => _showShareSidebar(context),
                  icon: const Icon(Icons.share_outlined, size: 20),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 8),
                // Tombol favorit
                _buildAnimatedButton(
                  onPressed: () {
                    // Toggle status favorit
                    provider.toggleFavorite(widget.product);
                    // Tampilkan notifikasi status favorit
                    _showNotification(
                      context,
                      provider.isExist(widget.product)
                          ? 'Ditambahkan ke favorit'
                          : 'Dihapus dari favorit',
                      Icons.favorite,
                    );
                  },
                  // Ubah ikon dan warna berdasarkan status favorit
                  icon: Icon(
                    provider.isExist(widget.product)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: provider.isExist(widget.product)
                        ? kprimaryColor
                        : Colors.black,
                    size: 20,
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
