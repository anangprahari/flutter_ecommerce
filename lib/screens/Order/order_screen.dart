import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Provider/order_provider.dart';
import '../../models/product_model.dart';
import '../../constants.dart';

// Layar pesanan yang menampilkan detail dan status pesanan pengguna
class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // Variabel untuk melacak tahap pengiriman saat ini
  int currentStep = 2;
  // Flag untuk menampilkan notifikasi
  bool showNotification = false;
  // Flag untuk menunjukkan proses loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Ambil pesanan dan inisialisasi status saat layar pertama kali dimuat
    _fetchOrdersAndInitializeStatus();
  }

  // Metode untuk mengambil pesanan pengguna dan mengatur status awal
  Future<void> _fetchOrdersAndInitializeStatus() async {
    try {
      // Dapatkan pengguna saat ini yang sudah login
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Ambil pesanan pengguna menggunakan provider
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchUserOrders();

        // Ambil tahap pengiriman terakhir yang diketahui
        final orderProvider =
            Provider.of<OrderProvider>(context, listen: false);
        int lastStep = await orderProvider.retrieveLastShippingStep();

        // Perbarui state dengan tahap terakhir
        setState(() {
          currentStep = lastStep;
          _isLoading = false;
        });

        // Jika tahap belum mencapai tahap terakhir, mulai pembaruan otomatis
        if (currentStep < 5) {
          _startStatusUpdates(initialStep: currentStep);
        }
      }
    } catch (e) {
      print('Error mengambil pesanan dan status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Metode untuk memulai pembaruan status pengiriman secara otomatis
  void _startStatusUpdates({int initialStep = 0}) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Mulai dari tahap terakhir yang diketahui
    for (int step = initialStep; step < 5; step++) {
      // Jeda singkat antara setiap tahap
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      // Perbarui tahap saat ini
      setState(() {
        currentStep = step;
      });

      // Simpan tahap pengiriman saat ini
      await orderProvider.saveShippingStep(currentStep);

      // Tampilkan notifikasi pada tahap terakhir
      if (step == 4) {
        setState(() {
          showNotification = true;
        });

        // Sembunyikan notifikasi setelah 2 detik
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            showNotification = false;
          });
        }
      }
    }
  }

  // Metode untuk memformat mata uang dalam Rupiah
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Widget untuk membangun kartu pesanan dengan detail lengkap
  Widget _buildOrderCard(
      Map<String, dynamic> order,
      List<Product> products,
      bool discountApplied,
      double totalPrice,
      double totalSubtotal,
      double totalDiscount) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian-bagian detail pesanan
            _buildSectionTitle('Informasi Pengiriman'),
            _buildShippingInfo(order),
            _buildSectionTitle('Detail Pesanan'),
            _buildOrderDetails(products, discountApplied),
            _buildSectionTitle('Rincian Harga'),
            _buildPriceDetails(totalSubtotal, totalDiscount, totalPrice),
            _buildSectionTitle('Metode Pembayaran'),
            _buildPaymentMethod(order['paymentMethod']),
            _buildSectionTitle('Status Pengiriman'),
            _buildShippingStatus(order['shippingRoute']),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat judul bagian dengan garis samping berwarna
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Garis samping berwarna
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: kprimaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi pengiriman
  Widget _buildShippingInfo(Map<String, dynamic> order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail penerima, alamat, dan nomor telepon
            _buildInfoRow(Icons.person, 'Nama Penerima', order['name']),
            const Divider(height: 24),
            _buildInfoRow(
                Icons.location_on, 'Alamat Pengiriman', order['address']),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Nomor Telepon', order['phone']),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat baris informasi dengan ikon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: kprimaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan detail produk dalam pesanan
  Widget _buildOrderDetails(List<Product> products, bool discountApplied) {
    return Column(
      children: products.map((item) {
        // Hitung subtotal dan diskon untuk setiap produk
        double subtotal = item.price * item.quantity;
        double discount = discountApplied
            ? subtotal * (item.discountPercentage ?? 0) / 100
            : 0;
        return _buildProductCard(item, subtotal, discount);
      }).toList(),
    );
  }

  // Widget untuk membuat kartu produk individual
  Widget _buildProductCard(Product product, double subtotal, double discount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Gambar produk
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detail produk
                  Text(product.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                      '${formatCurrency(product.price)} × ${product.quantity}'),
                  if (product.discountPercentage != null &&
                      product.discountPercentage! > 0)
                    Text(
                      'Diskon: ${product.discountPercentage}%',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            // Total harga setelah diskon
            Text(
              formatCurrency(subtotal - discount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan rincian harga
  Widget _buildPriceDetails(
      double subtotal, double discount, double totalPrice) {
    return Column(
      children: [
        _buildPriceRow('Subtotal', subtotal),
        if (discount > 0)
          _buildPriceRow('Diskon Total', -discount, isRed: true),
        const Divider(),
        _buildPriceRow('Total Pembayaran', totalPrice, isBold: true),
      ],
    );
  }

  // Widget untuk membuat baris harga dengan format khusus
  Widget _buildPriceRow(String label, double value,
      {bool isBold = false, bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(formatCurrency(value),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isRed ? Colors.red : null,
            )),
      ],
    );
  }

  // Widget untuk menampilkan metode pembayaran
  Widget _buildPaymentMethod(String paymentMethod) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.payment, color: kprimaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                paymentMethod,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan status pengiriman dengan animasi
  Widget _buildShippingStatus(String shippingRoute) {
    const steps = [
      'Pesanan Dikonfirmasi',
      'Sedang Diproses',
      'Dalam Perjalanan',
      'Dalam Pengantaran',
      'Terkirim'
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilkan setiap tahap dengan animasi progres
            for (var i = 0; i < steps.length; i++) ...[
              if (i > 0)
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: Colors.grey.withOpacity(0.3),
                    end: i <= currentStep
                        ? kprimaryColor
                        : Colors.grey.withOpacity(0.3),
                  ),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, color, _) {
                    return Container(
                      margin: const EdgeInsets.only(left: 12),
                      height: 20,
                      width: 2,
                      color: color,
                    );
                  },
                ),
              Row(
                children: [
                  // Animasi perubahan warna untuk setiap tahap
                  TweenAnimationBuilder<Color?>(
                    tween: ColorTween(
                      begin: Colors.grey[300],
                      end: i <= currentStep ? kprimaryColor : Colors.grey[300],
                    ),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, color, _) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                        child: Icon(
                          // Tampilkan ikon centang atau lingkaran kosong
                          i <= currentStep
                              ? Icons.check
                              : Icons.circle_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: i <= currentStep ? Colors.black : Colors.grey,
                      fontWeight: i <= currentStep
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan keadaan kosong ketika tidak ada pesanan
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai belanja sekarang!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari OrderProvider untuk mendapatkan daftar pesanan
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Stack(
      children: [
        // Struktur utama halaman menggunakan Scaffold
        Scaffold(
          // Membuat AppBar dengan judul "Pesanan Saya"
          appBar: AppBar(
            title: const Text(
              'Pesanan Saya',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: kprimaryColor, // Warna latar AppBar
            centerTitle: true, // Menempatkan judul di tengah
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: kcontentColor, // Warna latar belakang halaman
          body: _isLoading
              ? Center(
                  // Menampilkan indikator loading jika sedang memuat data
                  child: CircularProgressIndicator(
                    color: kprimaryColor,
                  ),
                )
              : orders.isEmpty
                  ? _buildEmptyState() // Menampilkan state kosong jika tidak ada pesanan
                  : ListView.builder(
                      // Membuat daftar pesanan
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        var order = orders[index];

                        // Mengonversi data produk dari Firebase menjadi objek Product
                        List<Product> products = (order['products'] as List)
                            .map((productMap) => Product(
                                  title: productMap['title'] ?? '',
                                  review: productMap['review'] ?? '',
                                  description: productMap['description'] ?? '',
                                  image: productMap['image'] ?? '',
                                  price:
                                      (productMap['price'] ?? 0.0).toDouble(),
                                  seller: productMap['seller'] ?? '',
                                  colors: productMap['colors'] is List
                                      ? (productMap['colors'] as List)
                                          .map((color) => Color(color))
                                          .toList()
                                      : [],
                                  category: productMap['category'] ?? '',
                                  rate: (productMap['rate'] ?? 0.0).toDouble(),
                                  quantity: productMap['quantity'] ?? 1,
                                ))
                            .toList();

                        // Mengecek apakah diskon sudah diterapkan
                        bool discountApplied =
                            order['discountApplied'] ?? false;

                        // Menghitung total harga pesanan setelah diskon
                        double totalPrice =
                            order['totalPriceWithDiscount'].toDouble();

                        // Menghitung subtotal (harga sebelum diskon)
                        double totalSubtotal = products.fold(0,
                            (sum, item) => sum + (item.price * item.quantity));

                        // Menghitung total diskon yang diberikan
                        double totalDiscount = discountApplied
                            ? products.fold(
                                0,
                                (sum, item) =>
                                    sum +
                                    (item.price *
                                        item.quantity *
                                        (item.discountPercentage ?? 0) /
                                        100))
                            : 0;

                        // Membuat kartu untuk setiap pesanan
                        return _buildOrderCard(order, products, discountApplied,
                            totalPrice, totalSubtotal, totalDiscount);
                      },
                    ),
        ),
        // Menampilkan notifikasi jika showNotification bernilai true
        if (showNotification)
          TweenAnimationBuilder<double>(
            // Animasi notifikasi muncul
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Positioned(
                // Menentukan posisi notifikasi di layar
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                child: Opacity(
                  // Mengatur transparansi berdasarkan animasi
                  opacity: value,
                  child: Container(
                    // Membuat tampilan notifikasi
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.green, // Warna latar notifikasi
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      // Konten notifikasi
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Pesanan anda sudah diterima',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
