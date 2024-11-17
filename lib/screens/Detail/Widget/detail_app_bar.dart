import 'package:ecommerce_mobile_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Provider/favorite_provider.dart';
import '../../../constants.dart';

class DetailAppBar extends StatelessWidget {
  final Product product;
  const DetailAppBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

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
              style: IconButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.all(10),
                minimumSize: const Size(40, 40),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                onPressed();
              },
              icon: icon,
            ),
          );
        },
      );
    }

    void _showShareSidebar(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.85, // Mengurangi ruang kosong di atas
            child: Container(
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
                  // Handle Bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bagikan ${product.title}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Pilih platform untuk membagikan produk ini",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Share Icons Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: [
                              _buildShareIcon("images/icon/whatsapp.png",
                                  "WhatsApp", context),
                              _buildShareIcon("images/icon/instagram.png",
                                  "Instagram", context),
                              _buildShareIcon(
                                  "images/icon/google.png", "Google", context),
                              _buildShareIcon(
                                  "images/icon/email.png", "Email", context),
                              _buildShareIcon("images/icon/facebook.png",
                                  "Facebook", context),
                              _buildShareIcon(
                                  "images/icon/link.png", "Salin Link", context,
                                  onTap: () => _copyLinkToClipboard(context)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Preview Section
                          Text(
                            'Preview',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSharePreview(),
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAnimatedButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 20),
              backgroundColor: Colors.white,
            ),
            Row(
              children: [
                _buildAnimatedButton(
                  onPressed: () => _showShareSidebar(context),
                  icon: const Icon(Icons.share_outlined, size: 20),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 8),
                _buildAnimatedButton(
                  onPressed: () {
                    provider.toggleFavorite(product);
                    _showNotification(
                      context,
                      provider.isExist(product)
                          ? 'Ditambahkan ke favorit'
                          : 'Dihapus dari favorit',
                      Icons.favorite,
                    );
                  },
                  icon: Icon(
                    provider.isExist(product)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: provider.isExist(product)
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

  Widget _buildShareIcon(String assetPath, String label, BuildContext context,
      {VoidCallback? onTap}) {
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
              } else {
                // TODO: Implement sharing functionality for each platform
                _showNotification(context, 'Berbagi ke $label', Icons.share);
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product.image,
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
                    Text(
                      product.title,
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
                        if (product.discountPercentage != null) ...[
                          Text(
                            'Rp ${product.originalPrice?.toStringAsFixed(2)}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          'Rp ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: kprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (product.seller.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Seller: ${product.seller}',
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

  void _copyLinkToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: "https://flutter.dev/"));
    _showNotification(context, "Link berhasil disalin", Icons.link);
  }

  void _showNotification(BuildContext context, String message, IconData icon) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
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
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
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

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 2000), () {
      overlayEntry.remove();
    });
  }
}
