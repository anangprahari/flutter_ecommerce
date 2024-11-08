import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/Provider/add_to_cart_provider.dart';
import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:ecommerce_mobile_app/screens/Cart/shipping_details_screen.dart';
import 'package:ecommerce_mobile_app/screens/Payment/bri_virtual_account_screen.dart';
import 'package:ecommerce_mobile_app/screens/Payment/mandiri_virtual_account_screen.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedPaymentMethod = 'cod';
  String? _selectedBank;
  bool _showBankOptions = false;
  String? _virtualAccountNumber;
  DateTime? _paymentDueDate;

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String formatDueDate(DateTime date) {
    return DateFormat('HH:mm, d MMM yyyy').format(date);
  }

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

  void _handleBankSelection(String bank, double totalAmount) {
    final String vaNumber = generateVirtualAccountNumber();
    final DateTime dueDate = DateTime.now().add(const Duration(hours: 24));

    setState(() {
      _selectedBank = bank;
      _virtualAccountNumber = vaNumber;
      _paymentDueDate = dueDate;
    });

    String orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    if (bank == 'bri') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BRIVirtualAccountScreen(
            amount: totalAmount,
            orderNumber: orderNumber,
            onSuccess: () {
              _handlePaymentSuccess(totalAmount);
            },
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
            onSuccess: () {
              _handlePaymentSuccess(totalAmount);
            },
          ),
        ),
      );
    }
  }

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
          paymentMethod: 'Virtual Account ${_selectedBank?.toUpperCase()}',
          discountApplied: widget.discountApplied, // Tambahkan parameter ini
          virtualAccountNumber: _virtualAccountNumber,
          paymentDueDate:
              _paymentDueDate != null ? formatDueDate(_paymentDueDate!) : null,
        ),
      ),
    );
  }

  String generateVirtualAccountNumber() {
    return '8810 7000 1282 4775 2';
  }

  Widget _buildPaymentMethodSelector() {
    double totalAmount =
        widget.discountApplied ? widget.total : widget.subtotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Radio<String>(
              value: 'cod',
              groupValue: _selectedPaymentMethod,
              onChanged: _handlePaymentMethodChange,
              activeColor: kprimaryColor,
            ),
            title: Row(
              children: const [
                Icon(Icons.local_shipping, size: 24),
                SizedBox(width: 12),
                Text('Bayar di tempat'),
              ],
            ),
          ),
          ListTile(
            leading: Radio<String>(
              value: 'virtual_account',
              groupValue: _selectedPaymentMethod,
              onChanged: _handlePaymentMethodChange,
              activeColor: kprimaryColor,
            ),
            title: Row(
              children: const [
                Icon(Icons.account_balance, size: 24),
                SizedBox(width: 12),
                Text('Transfer Virtual Account'),
              ],
            ),
          ),
          if (_showBankOptions) ...[
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_virtualAccountNumber != null &&
                      _paymentDueDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Batas Waktu Pembayaran:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      formatDueDate(_paymentDueDate!),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ListTile(
                    onTap: () => _handleBankSelection('mandiri', totalAmount),
                    leading: Image.asset(
                      'images/icon/mandiri.png',
                      height: 24,
                      width: 24,
                    ),
                    title: const Text('Mandiri'),
                    trailing: _selectedBank == 'mandiri'
                        ? Icon(Icons.check, color: kprimaryColor)
                        : null,
                  ),
                  ListTile(
                    onTap: () => _handleBankSelection('bri', totalAmount),
                    leading: Image.asset(
                      'images/icon/bri.png',
                      height: 24,
                      width: 24,
                    ),
                    title: const Text('BRI'),
                    trailing: _selectedBank == 'bri'
                        ? Icon(Icons.check, color: kprimaryColor)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProvider.of(context);
    final cartItems = cartProvider.cart;
    double subtotal = widget.subtotal;
    double totalWithDiscount = widget.discountApplied ? widget.total : subtotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildOrderSummary(cartItems, cartProvider),
                const SizedBox(height: 16),
                const Text(
                  'Shipping Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildShippingInfo(),
                const SizedBox(height: 16),
                _buildPaymentMethodSelector(),
                const SizedBox(height: 24),
                _buildCheckoutButton(context, cartProvider, totalWithDiscount),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: kcontentColor,
    );
  }

  Widget _buildOrderSummary(
      List<Product> cartItems, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ...cartItems.map((item) {
            double productDiscount = widget.discountApplied
                ? item.price * (item.discountPercentage ?? 0) / 100
                : 0;
            double discountedPrice = item.price - productDiscount;
            double totalPrice = discountedPrice * item.quantity;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${formatCurrency(item.price)} x ${item.quantity}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      'Subtotal: ${formatCurrency(totalPrice)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                if (widget.discountApplied && productDiscount > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Diskon:',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      Text(
                        '- ${formatCurrency(productDiscount * item.quantity)}',
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                const Divider(height: 8),
              ],
            );
          }).toList(),
          const Divider(thickness: 1, height: 16),
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kprimaryColor)),
            floatingLabelStyle: const TextStyle(color: kprimaryColor),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kprimaryColor)),
            floatingLabelStyle: const TextStyle(color: kprimaryColor),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: kprimaryColor)),
            floatingLabelStyle: const TextStyle(color: kprimaryColor),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartProvider cartProvider,
      double totalWithDiscount) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kprimaryColor,
        minimumSize: const Size(double.infinity, 55),
      ),
      onPressed: () {
        if (_nameController.text.isEmpty ||
            _addressController.text.isEmpty ||
            _phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Mohon lengkapi semua field!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

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
                discountApplied:
                    widget.discountApplied, // Tambahkan parameter ini
              ),
            ),
          );
        }
      },
      child: Text(
        _selectedPaymentMethod == 'cod'
            ? "Lanjut ke Pengiriman"
            : "Lanjut ke Pembayaran",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
