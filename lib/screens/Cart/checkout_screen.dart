import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Cart/shipping_details_screen.dart';
import 'package:ecommerce_mobile_app/screens/Payment/bri_virtual_account_screen.dart';
import 'package:ecommerce_mobile_app/screens/Payment/mandiri_virtual_account_screen.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

// StatefulWidget untuk layar checkout
class CheckoutScreen extends StatefulWidget {
  // Parameter konstruktor untuk subtotal, status diskon, dan total harga
  final double subtotal;
  final bool discountApplied;
  final double total;

  const CheckoutScreen({
    required this.subtotal,
    required this.discountApplied,
    required this.total,
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Controller untuk input teks nama, alamat, dan nomor telepon
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variabel untuk menyimpan metode pembayaran dan detail terkait
  String _selectedPaymentMethod = 'cod';
  String? _selectedBank;
  bool _showBankOptions = false;
  String? _virtualAccountNumber;
  DateTime? _paymentDueDate;
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk memformat mata uang dalam Rupiah
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Fungsi untuk memformat tanggal jatuh tempo
  String formatDueDate(DateTime date) {
    return DateFormat('HH:mm, d MMM yyyy').format(date);
  }

  // Metode untuk menangani perubahan metode pembayaran
  void _handlePaymentMethodChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedPaymentMethod = value;
        if (value == 'virtual_account') {
          _showBankOptions = true;
          _virtualAccountNumber = null;
          _paymentDueDate = DateTime.now().add(const Duration(hours: 24));
        } else {
          _showBankOptions = false;
          _selectedBank = null;
          _virtualAccountNumber = null;
          _paymentDueDate = null;
        }
      });
    }
  }

  // Metode untuk menangani pilihan bank virtual account
  void _handleBankSelection(String bank, double totalAmount) {
    final String vaNumber = generateVirtualAccountNumber();
    final DateTime dueDate = DateTime.now().add(const Duration(hours: 24));

    setState(() {
      _selectedBank = bank;
      _virtualAccountNumber = vaNumber;
      _paymentDueDate = dueDate;
    });

    // Generate nomor pesanan unik
    String orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    // Navigasi ke layar virtual account sesuai bank yang dipilih
    if (bank == 'bri') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BRIVirtualAccountScreen(
            amount: totalAmount,
            orderNumber: orderNumber,
            onSuccess: () => _handlePaymentSuccess(totalAmount),
          ),
        ),
      );
    } else if (bank == 'mandiri') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MandiriVirtualAccountScreen(
            amount: totalAmount,
            orderNumber: orderNumber,
            onSuccess: () => _handlePaymentSuccess(totalAmount),
          ),
        ),
      );
    }
  }

  // Metode untuk menangani keberhasilan pembayaran
  void _handlePaymentSuccess(double totalAmount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingDetailsScreen(
          name: _nameController.text,
          address: _addressController.text,
          phone: _phoneController.text,
          cartItems: CartProvider.of(context).cart,
          totalPrice: totalAmount,
          paymentMethod: 'Akun Virtual ${_selectedBank?.toUpperCase()}',
          discountApplied: widget.discountApplied,
          virtualAccountNumber: _virtualAccountNumber,
          paymentDueDate:
              _paymentDueDate != null ? formatDueDate(_paymentDueDate!) : null,
        ),
      ),
    );
  }

  // Fungsi untuk menghasilkan nomor virtual account (sementara/dummy)
  String generateVirtualAccountNumber() {
    return '8810 7000 1282 4775 2';
  }

  // Widget untuk membuat judul section dengan aksen warna
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Aksen garis warna utama di samping judul
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
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun pilihan metode pembayaran
  Widget _buildPaymentMethodSelector() {
    double totalAmount =
        widget.discountApplied ? widget.total : widget.subtotal;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header metode pembayaran
            Row(
              children: [
                Icon(Icons.payment, color: kprimaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            // Opsi pembayaran COD
            _buildPaymentOption(
              'cod',
              'Bayar di tempat',
              Icons.local_shipping,
              Colors.green,
            ),
            // Opsi transfer virtual account
            _buildPaymentOption(
              'virtual_account',
              'Transfer Akun Virtual',
              Icons.account_balance,
              Colors.blue,
            ),
            // Pilihan bank jika virtual account dipilih
            if (_showBankOptions) ...[
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(left: 32),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildBankOption(
                      'mandiri',
                      'Mandiri',
                      'images/icon/mandiri.png',
                      totalAmount,
                    ),
                    _buildBankOption(
                      'bri',
                      'BRI',
                      'images/icon/bri.png',
                      totalAmount,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat opsi pembayaran (radio button)
  Widget _buildPaymentOption(
      String value, String title, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedPaymentMethod == value
              ? kprimaryColor
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: _handlePaymentMethodChange,
        activeColor: kprimaryColor,
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Widget untuk membuat pilihan bank virtual account
  Widget _buildBankOption(
      String bank, String title, String imagePath, double totalAmount) {
    bool isSelected = _selectedBank == bank;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? kprimaryColor : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        onTap: () => _handleBankSelection(bank, totalAmount),
        leading: Image.asset(
          imagePath,
          height: 32,
          width: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: kprimaryColor)
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  // Widget untuk ringkasan pesanan
  Widget _buildOrderSummary(
      List<Product> cartItems, CartProvider cartProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar item dalam keranjang
            ...cartItems.map((item) {
              // Hitung diskon per produk
              double productDiscount = widget.discountApplied
                  ? item.price * (item.discountPercentage ?? 0) / 100
                  : 0;
              double discountedPrice = item.price - productDiscount;
              double totalPrice = discountedPrice * item.quantity;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Harga dan kuantitas
                        Text(
                          '${formatCurrency(item.price)} x ${item.quantity}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        // Total harga produk
                        Text(
                          formatCurrency(totalPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Tampilkan diskon jika ada
                    if (widget.discountApplied && productDiscount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Diskon:',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                            '- ${formatCurrency(productDiscount * item.quantity)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            const Divider(thickness: 1),
            // Bagian total
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian total pembayaran
  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text(formatCurrency(widget.subtotal)),
            ],
          ),
          // Total diskon jika ada
          if (widget.discountApplied) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Diskon',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  '- ${formatCurrency(widget.subtotal - widget.total)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 16),
           // Total pembayaran akhir
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatCurrency(
                    widget.discountApplied ? widget.total : widget.subtotal),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk informasi pengiriman dengan form input
  Widget _buildShippingInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextField untuk nama lengkap
              _buildTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                icon: Icons.person,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // TextField untuk alamat lengkap
              _buildTextField(
                controller: _addressController,
                label: 'Alamat Lengkap',
                icon: Icons.location_on,
                maxLines: 2,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // TextField untuk nomor telepon
              _buildTextField(
                controller: _phoneController,
                label: 'Nomor Telepon',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat TextField kustom dengan validasi
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kprimaryColor),
        // Berbagai konfigurasi border untuk state berbeda
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kprimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(16),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 16),
    );
  }

  // Widget untuk tombol checkout di bagian bawah layar
  Widget _buildCheckoutButton(BuildContext context, CartProvider cartProvider,
      double totalWithDiscount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Baris total pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatCurrency(totalWithDiscount),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tombol untuk melanjutkan ke pengiriman atau pembayaran
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 56),
              elevation: 2,
            ),
            onPressed: () {
              // Validasi form sebelum melanjutkan
              if (!_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Mohon lengkapi semua field!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              // Navigasi ke layar pengiriman untuk metode COD
              if (_selectedPaymentMethod == 'cod') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippingDetailsScreen(
                      name: _nameController.text,
                      address: _addressController.text,
                      phone: _phoneController.text,
                      cartItems: cartProvider.cart,
                      totalPrice: totalWithDiscount,
                      paymentMethod: 'Bayar di tempat',
                      discountApplied: widget.discountApplied,
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon dan teks disesuaikan dengan metode pembayaran
                Icon(
                  _selectedPaymentMethod == 'cod'
                      ? Icons.local_shipping
                      : Icons.payment,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedPaymentMethod == 'cod'
                      ? "Lanjut ke Pengiriman"
                      : "Lanjut ke Pembayaran",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method build untuk membangun seluruh tampilan layar checkout
  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context);
    final cartItems = cartProvider.cart;
    double subtotal = widget.subtotal;
    double totalWithDiscount = widget.discountApplied ? widget.total : subtotal;

    return Scaffold(
      // AppBar dengan judul dan jumlah produk
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Check-out',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${cartItems.length} Produk',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      // Body dengan stack untuk tombol checkout di bawah
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section-section utama checkout
                _buildSectionTitle('Detail Pesanan'),
                _buildOrderSummary(cartItems, cartProvider),
                _buildSectionTitle('Informasi Pengiriman'),
                _buildShippingInfo(),
                _buildSectionTitle('Metode Pembayaran'),
                _buildPaymentMethodSelector(),
                const SizedBox(height: 100), // Spasi untuk tombol bawah
              ],
            ),
          ),
          // Posisi tombol checkout di bawah layar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCheckoutButton(
              context,
              cartProvider,
              totalWithDiscount,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}
