import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _emailNotificationsEnabled = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password strength indicator
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Lemah';
  Color _passwordStrengthColor = Colors.red;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Calculate password strength
  void _updatePasswordStrength(String password) {
    double strength = 0;

    if (password.length >= 8) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    setState(() {
      _passwordStrength = strength;
      if (strength <= 0.2) {
        _passwordStrengthText = 'Sangat Lemah';
        _passwordStrengthColor = Colors.red;
      } else if (strength <= 0.4) {
        _passwordStrengthText = 'Lemah';
        _passwordStrengthColor = Colors.orange;
      } else if (strength <= 0.6) {
        _passwordStrengthText = 'Sedang';
        _passwordStrengthColor = Colors.yellow;
      } else if (strength <= 0.8) {
        _passwordStrengthText = 'Kuat';
        _passwordStrengthColor = Colors.lightGreen;
      } else {
        _passwordStrengthText = 'Sangat Kuat';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSecurityHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordSection(),
                    const SizedBox(height: 32),
                    _buildSecuritySettings(),
                    const SizedBox(height: 32),
                    _buildAdvancedSecuritySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Keamanan Akun',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      backgroundColor: kprimaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showSecurityInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildSecurityHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kprimaryColor.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kprimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: kprimaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tingkat Keamanan Akun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (_twoFactorEnabled ? 0.3 : 0) +
                      (_biometricEnabled ? 0.3 : 0) +
                      (_emailNotificationsEnabled ? 0.2 : 0) +
                      0.2, // Base security
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${_getSecurityStatus()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSecurityStatus() {
    double securityScore = (_twoFactorEnabled ? 0.3 : 0) +
        (_biometricEnabled ? 0.3 : 0) +
        (_emailNotificationsEnabled ? 0.2 : 0) +
        0.2;

    if (securityScore >= 0.8) return 'Sangat Baik';
    if (securityScore >= 0.6) return 'Baik';
    if (securityScore >= 0.4) return 'Cukup';
    return 'Perlu Ditingkatkan';
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ubah Kata Sandi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _oldPasswordController,
          label: "Kata Sandi Lama",
          hint: "Masukkan kata sandi lama",
          showPassword: _showOldPassword,
          onToggleVisibility: () {
            setState(() => _showOldPassword = !_showOldPassword);
          },
          icon: Icons.lock_outline,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _newPasswordController,
          label: "Kata Sandi Baru",
          hint: "Minimal 8 karakter",
          showPassword: _showNewPassword,
          onToggleVisibility: () {
            setState(() => _showNewPassword = !_showNewPassword);
          },
          icon: Icons.lock_reset,
          onChanged: _updatePasswordStrength,
        ),
        const SizedBox(height: 8),
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: "Konfirmasi Kata Sandi Baru",
          hint: "Ulangi kata sandi baru",
          showPassword: _showConfirmPassword,
          onToggleVisibility: () {
            setState(() => _showConfirmPassword = !_showConfirmPassword);
          },
          icon: Icons.check_circle_outline,
          validator: (value) {
            if (value != _newPasswordController.text) {
              return 'Kata sandi tidak cocok';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildUpdatePasswordButton(),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool showPassword,
    required Function onToggleVisibility,
    required IconData icon,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => onToggleVisibility(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      obscureText: !showPassword,
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Field ini tidak boleh kosong';
            }
            if (value.length < 8) {
              return 'Minimal 8 karakter';
            }
            return null;
          },
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Kekuatan Kata Sandi: $_passwordStrengthText',
          style: TextStyle(
            color: _passwordStrengthColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _showSuccessDialog(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kprimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Perbarui Kata Sandi",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pengaturan Keamanan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSecurityTile(
                title: "Autentikasi Dua Faktor",
                subtitle:
                    "Verifikasi tambahan saat login menggunakan SMS atau email",
                icon: Icons.security,
                isSwitch: true,
                value: _twoFactorEnabled,
                onChanged: (value) {
                  setState(() => _twoFactorEnabled = value);
                  if (value) _setup2FA(context);
                },
              ),
              const Divider(height: 1),
              _buildSecurityTile(
                title: "Login Biometrik",
                subtitle: "Gunakan sidik jari atau Face ID untuk login",
                icon: Icons.fingerprint,
                isSwitch: true,
                value: _biometricEnabled,
                onChanged: (value) => setState(() => _biometricEnabled = value),
              ),
              const Divider(height: 1),
              _buildSecurityTile(
                title: "Notifikasi Email",
                subtitle: "Dapatkan pemberitahuan untuk aktivitas mencurigakan",
                icon: Icons.email,
                isSwitch: true,
                value: _emailNotificationsEnabled,
                onChanged: (value) =>
                    setState(() => _emailNotificationsEnabled = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Keamanan Lanjutan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSecurityTile(
                title: "Perangkat Terpercaya",
                subtitle: "Kelola perangkat yang dapat mengakses akun",
                icon: Icons.smartphone,
                onTap: () {
                  // Navigate to trusted devices
                },
              ),
              const Divider(height: 1),
              _buildSecurityTile(
                title: "Riwayat Login",
                subtitle: "Pantau aktivitas login akun Anda",
                icon: Icons.history,
                onTap: () {
                  // Navigate to login history
                },
              ),
              const Divider(height: 1),
              _buildSecurityTile(
                title: "Backup & Pemulihan",
                subtitle: "Atur opsi pemulihan akun",
                icon: Icons.backup,
                onTap: () {
                  // Navigate to backup settings
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityTile({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isSwitch = false,
    bool? value,
    Function(bool)? onChanged,
    VoidCallback? onTap,
  }) {
    final Widget trailing = isSwitch
        ? Switch(
            value: value ?? false,
            onChanged: onChanged,
            activeColor: kprimaryColor,
          )
        : const Icon(Icons.arrow_forward_ios, size: 16);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kprimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: kprimaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: isSwitch ? null : onTap,
    );
  }

  void _showSecurityInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: kprimaryColor),
            const SizedBox(width: 8),
            const Text("Tips Keamanan"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSecurityTip(
                "Kata Sandi yang Kuat",
                "• Gunakan minimal 8 karakter\n"
                    "• Kombinasikan huruf besar dan kecil\n"
                    "• Tambahkan angka dan simbol khusus\n"
                    "• Hindari informasi pribadi yang mudah ditebak",
              ),
              const SizedBox(height: 16),
              _buildSecurityTip(
                "Praktik Keamanan Terbaik",
                "• Aktifkan autentikasi dua faktor\n"
                    "• Ganti kata sandi secara berkala\n"
                    "• Jangan menggunakan kata sandi yang sama dengan akun lain\n"
                    "• Pantau aktivitas login secara rutin",
              ),
              const SizedBox(height: 16),
              _buildSecurityTip(
                "Perlindungan Tambahan",
                "• Gunakan login biometrik jika tersedia\n"
                    "• Aktifkan notifikasi keamanan\n"
                    "• Kelola perangkat terpercaya\n"
                    "• Backup data penting secara rutin",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Mengerti"),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTip(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text("Berhasil"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kata sandi Anda berhasil diperbarui."),
            SizedBox(height: 8),
            Text(
              "Silakan gunakan kata sandi baru Anda untuk login berikutnya.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear form fields
              _oldPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
              setState(() {
                _passwordStrength = 0.0;
                _passwordStrengthText = 'Lemah';
                _passwordStrengthColor = Colors.red;
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _setup2FA(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: kprimaryColor),
            const SizedBox(width: 8),
            const Text("Pengaturan 2FA"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih metode verifikasi untuk meningkatkan keamanan akun Anda:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            _build2FAOption(
              icon: Icons.email,
              title: "Email",
              subtitle: "Kirim kode verifikasi melalui email",
              onTap: () => _configure2FAMethod(context, "email"),
            ),
            const SizedBox(height: 8),
            _build2FAOption(
              icon: Icons.phone_android,
              title: "SMS",
              subtitle: "Kirim kode verifikasi melalui SMS",
              onTap: () => _configure2FAMethod(context, "sms"),
            ),
            const SizedBox(height: 8),
            _build2FAOption(
              icon: Icons.apps,
              title: "Authenticator App",
              subtitle: "Gunakan aplikasi authenticator",
              onTap: () => _configure2FAMethod(context, "app"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = false;
              });
            },
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  Widget _build2FAOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: kprimaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _configure2FAMethod(BuildContext context, String method) {
    // Implement specific 2FA setup flow based on method
    Navigator.pop(context); // Close 2FA selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfigurasi 2FA"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Anda memilih metode verifikasi melalui $method."),
            const SizedBox(height: 16),
            const Text(
              "Dalam implementasi sebenarnya, di sini akan ditampilkan langkah-langkah konfigurasi spesifik untuk metode yang dipilih.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = true;
              });
            },
            child: const Text("Selesai"),
          ),
        ],
      ),
    );
  }

  // Additional helper methods for advanced features
  void _showBackupOptions() {
    // Implement backup options dialog
  }

  void _showLoginHistory() {
    // Implement login history view
  }

  void _manageTrustedDevices() {
    // Implement trusted devices management
  }
}
