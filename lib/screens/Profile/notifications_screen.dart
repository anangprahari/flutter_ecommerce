import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_mobile_app/constants.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead; // Make this mutable
  final String? imageUrl;
  final String? actionUrl;
  final double? price;
  final String? orderId;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.price,
    this.orderId,
  });
}

enum NotificationType {
  promo,
  order,
  payment,
  account,
  delivery,
  wishlist,
  review,
  restock,
  price_alert,
  reward
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  DateTime? _lastUpdated;

  final List<NotificationItem> notifications = [
    // Promo Notifications
    NotificationItem(
      title: "Flash Sale Spesial!",
      message: "Diskon hingga 70% untuk produk pilihan. Berakhir dalam 2 jam!",
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.promo,
      imageUrl: "images/FLASH.png",
      actionUrl: "/flash-sale",
    ),
    NotificationItem(
      title: "Voucher Eksklusif",
      message:
          "Selamat! Anda mendapatkan voucher diskon 100rb. Klaim sekarang!",
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.promo,
      actionUrl: "/vouchers",
    ),

    // Order Notifications
    NotificationItem(
      title: "Pesanan Dikonfirmasi",
      message:
          "Pesanan #OR789012 telah dikonfirmasi. Penjual akan segera memproses pesanan Anda.",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.order,
      orderId: "OR789012",
    ),
    NotificationItem(
      title: "Pesanan Sedang Dikemas",
      message: "Penjual sedang mengemas pesanan #OR789012 Anda.",
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.order,
      orderId: "OR789012",
    ),

    // Delivery Notifications
    NotificationItem(
      title: "Paket Dalam Perjalanan",
      message: "Kurir sedang menuju lokasi Anda. Estimasi tiba: 14:30 WIB",
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: NotificationType.delivery,
      orderId: "OR789012",
    ),
    NotificationItem(
      title: "Paket Telah Tiba",
      message:
          "Pesanan #OR654321 telah diterima oleh Budi. Terima kasih telah berbelanja!",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.delivery,
      orderId: "OR654321",
    ),

    // Payment Notifications
    NotificationItem(
      title: "Pembayaran Berhasil",
      message: "Pembayaran Rp 250.000 untuk pesanan #OR789012 telah diterima",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.payment,
      price: 250000,
      orderId: "OR789012",
    ),
    NotificationItem(
      title: "Pengembalian Dana Diproses",
      message: "Refund Rp 150.000 untuk pesanan #OR543210 sedang diproses",
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.payment,
      price: 150000,
      orderId: "OR543210",
    ),

    // Wishlist & Price Alert Notifications
    NotificationItem(
      title: "Produk Kembali Tersedia!",
      message:
          "iPhone 13 Pro Max kini tersedia kembali. Beli sekarang sebelum kehabisan!",
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.restock,
      actionUrl: "/product/iphone-13-pro-max",
    ),
    NotificationItem(
      title: "Harga Turun!",
      message:
          "Harga Samsung Galaxy S21 turun 20%. Sekarang hanya Rp 9.999.000",
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.price_alert,
      price: 9999000,
      actionUrl: "/product/samsung-s21",
    ),

    // Review Notifications
    NotificationItem(
      title: "Bagaimana dengan pesanan Anda?",
      message:
          "Berikan ulasan untuk pesanan #OR654321 dan dapatkan 10 poin reward!",
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      type: NotificationType.review,
      orderId: "OR654321",
    ),

    // Reward Notifications
    NotificationItem(
      title: "Level Member Naik!",
      message:
          "Selamat! Anda naik ke level Gold Member. Nikmati berbagai keuntungan eksklusif.",
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      type: NotificationType.reward,
    ),
  ];

  final Map<NotificationType, bool> _notificationSettings = {
    NotificationType.promo: true,
    NotificationType.order: true,
    NotificationType.payment: true,
    NotificationType.account: true,
    NotificationType.delivery: true,
    NotificationType.wishlist: true,
    NotificationType.review: true,
    NotificationType.restock: true,
    NotificationType.price_alert: true,
    NotificationType.reward: true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _lastUpdated = DateTime.now();
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.promo:
        return Icons.local_offer_outlined;
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
      case NotificationType.account:
        return Icons.person_outline;
      case NotificationType.delivery:
        return Icons.local_shipping_outlined;
      case NotificationType.wishlist:
        return Icons.favorite_border;
      case NotificationType.review:
        return Icons.star_border;
      case NotificationType.restock:
        return Icons.inventory_2_outlined;
      case NotificationType.price_alert:
        return Icons.price_change_outlined;
      case NotificationType.reward:
        return Icons.card_giftcard_outlined;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.promo:
        return Colors.orange;
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.account:
        return Colors.purple;
      case NotificationType.delivery:
        return Colors.teal;
      case NotificationType.wishlist:
        return Colors.pink;
      case NotificationType.review:
        return Colors.amber;
      case NotificationType.restock:
        return Colors.indigo;
      case NotificationType.price_alert:
        return Colors.deepOrange;
      case NotificationType.reward:
        return Colors.deepPurple;
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  // Fix the mark all as read function
  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Semua notifikasi telah ditandai sebagai dibaca')),
    );
  }

  void _deleteAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Notifikasi'),
        content: const Text('Anda yakin ingin menghapus semua notifikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi telah dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_lastUpdated != null)
              Text(
                'Terakhir diperbarui: ${DateFormat('HH:mm').format(_lastUpdated!)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.done_all_outlined,
              color: Colors.white,
            ),
            onPressed: _markAllAsRead,
            tooltip: 'Tandai semua sebagai dibaca',
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white, // Jika ada ikon tambahan, ubah warnanya juga
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_all',
                child: Text('Hapus Semua Notifikasi'),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete_all') {
                _deleteAllNotifications();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white, // Warna teks tab yang aktif
          unselectedLabelColor:
              Colors.white.withOpacity(0.7), // Warna teks tab yang tidak aktif
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pengaturan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(),
          _buildNotificationSettings(),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.timestamp.toString()),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          notifications.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifikasi dihapus'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle notification tap
                            if (notification.actionUrl != null) {
                              // Navigate to action URL
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _getNotificationColor(
                                                notification.type)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getNotificationIcon(notification.type),
                                        color: _getNotificationColor(
                                            notification.type),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification.title,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        notification.isRead
                                                            ? FontWeight.normal
                                                            : FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              if (!notification.isRead)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: kprimaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notification.message,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                          if (notification.price != null) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'id',
                                                symbol: 'Rp ',
                                                decimalDigits: 0,
                                              ).format(notification.price),
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                          if (notification.imageUrl !=
                                              null) ...[
                                            const SizedBox(height: 12),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                notification.imageUrl!,
                                                height: 120,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatTimestamp(
                                                    notification.timestamp),
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              if (notification.actionUrl !=
                                                  null)
                                                TextButton(
                                                  onPressed: () {
                                                    // Handle action button tap
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                  ),
                                                  child: Text(
                                                    'Lihat Detail',
                                                    style: TextStyle(
                                                      color: kprimaryColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (notification.orderId != null) ...[
                                  const Divider(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'No. Pesanan: ${notification.orderId}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to order details
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Lacak Pesanan',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildSettingsTile(
                  title: 'Promo & Diskon',
                  subtitle: 'Info promo, flash sale, dan voucher terbaru',
                  icon: Icons.local_offer_outlined,
                  color: Colors.orange,
                  type: NotificationType.promo,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Status Pesanan',
                  subtitle: 'Pembaruan status pesanan Anda',
                  icon: Icons.shopping_bag_outlined,
                  color: Colors.blue,
                  type: NotificationType.order,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Pengiriman',
                  subtitle: 'Status pengiriman dan info kurir',
                  icon: Icons.local_shipping_outlined,
                  color: Colors.teal,
                  type: NotificationType.delivery,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Pembayaran',
                  subtitle: 'Konfirmasi pembayaran dan pengembalian dana',
                  icon: Icons.payment_outlined,
                  color: Colors.green,
                  type: NotificationType.payment,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Wishlist & Stok',
                  subtitle: 'Info ketersediaan produk yang Anda inginkan',
                  icon: Icons.favorite_border,
                  color: Colors.pink,
                  type: NotificationType.wishlist,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Review Produk',
                  subtitle: 'Pengingat dan reward ulasan produk',
                  icon: Icons.star_border,
                  color: Colors.amber,
                  type: NotificationType.review,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Perubahan Harga',
                  subtitle: 'Info penurunan harga produk favorit',
                  icon: Icons.price_change_outlined,
                  color: Colors.deepOrange,
                  type: NotificationType.price_alert,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Reward & Member',
                  subtitle: 'Update points dan benefit member',
                  icon: Icons.card_giftcard_outlined,
                  color: Colors.deepPurple,
                  type: NotificationType.reward,
                ),
                const Divider(height: 1),
                _buildSettingsTile(
                  title: 'Akun & Keamanan',
                  subtitle: 'Aktivitas dan keamanan akun',
                  icon: Icons.person_outline,
                  color: Colors.purple,
                  type: NotificationType.account,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Pengaturan Tambahan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Notifikasi Push'),
                  subtitle: const Text('Terima notifikasi di perangkat ini'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle push notification settings
                    },
                    activeColor: kprimaryColor,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Notifikasi Email'),
                  subtitle: const Text('Terima notifikasi melalui email'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // Handle email notification settings
                    },
                    activeColor: kprimaryColor,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Notifikasi WhatsApp'),
                  subtitle: const Text('Terima notifikasi melalui WhatsApp'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle WhatsApp notification settings
                    },
                    activeColor: kprimaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Jadwal Hening'),
                  subtitle:
                      const Text('Nonaktifkan notifikasi pada waktu tertentu'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to Do Not Disturb settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Hapus Riwayat Notifikasi'),
                  subtitle: const Text('Hapus semua riwayat notifikasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _deleteAllNotifications,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required NotificationType type,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
      value: _notificationSettings[type] ?? false, // Provide default value
      onChanged: (bool value) {
        setState(() {
          _notificationSettings[type] = value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Notifikasi $title diaktifkan'
                  : 'Notifikasi $title dinonaktifkan',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      activeColor: kprimaryColor,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
