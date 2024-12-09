import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/constants.dart';

// Layar keamanan untuk mengelola pengaturan keamanan akun pengguna
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  // Pengaturan visibilitas password
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Pengaturan keamanan tambahan
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _emailNotificationsEnabled = true;

  // Kunci form untuk validasi
  final _formKey = GlobalKey<FormState>();

  // Pengontrol teks untuk field password
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Indikator kekuatan password
  double _passwordStrength = 0.0;
  String _passwordStrengthText = 'Sangat Lemah';
  Color _passwordStrengthColor = Colors.red;

  @override
  void dispose() {
    // Membersihkan controller untuk mencegah memory leak
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Metode untuk menghitung kekuatan password
  void _updatePasswordStrength(String password) {
    // Kriteria kekuatan password
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    // Menghitung skor panjang dan kompleksitas
    int lengthScore = password.length;
    int complexityScore = (hasUppercase ? 1 : 0) +
        (hasLowercase ? 1 : 0) +
        (hasDigits ? 1 : 0) +
        (hasSpecialChar ? 1 : 0);

    // Menghitung kekuatan keseluruhan
    double strength = 0.0;

    if (lengthScore < 4) {
      strength = 0.1; // Sangat lemah
      _passwordStrengthText = 'Sangat Lemah';
      _passwordStrengthColor = Colors.red;
    } else if (lengthScore < 8) {
      strength = 0.3; // Lemah
      _passwordStrengthText = 'Lemah';
      _passwordStrengthColor = Colors.orange;
    } else {
      // Kombinasi panjang dan kompleksitas
      switch (complexityScore) {
        case 0: // Hanya panjang
          strength = 0.4;
          _passwordStrengthText = 'Sedang';
          _passwordStrengthColor = Colors.yellow;
          break;
        case 1: // Panjang + satu jenis kompleksitas
          strength = 0.5;
          _passwordStrengthText = 'Sedang';
          _passwordStrengthColor = Colors.yellow;
          break;
        case 2: // Panjang + dua jenis kompleksitas
          strength = 0.7;
          _passwordStrengthText = 'Kuat';
          _passwordStrengthColor = Colors.lightGreen;
          break;
        case 3: // Panjang + tiga jenis kompleksitas
        case 4: // Panjang + semua jenis kompleksitas
          strength = 0.9;
          _passwordStrengthText = 'Sangat Kuat';
          _passwordStrengthColor = Colors.green;
          break;
      }
    }

    setState(() {
      _passwordStrength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Membangun app bar
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Membangun header keamanan
            _buildSecurityHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Membangun bagian password
                    _buildPasswordSection(),
                    const SizedBox(height: 32),
                    // Membangun pengaturan keamanan
                    _buildSecuritySettings(),
                    const SizedBox(height: 32),
                    // Membangun bagian keamanan lanjutan
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

  // Membangun AppBar dengan judul dan tombol informasi
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

  // Membangun header keamanan dengan indikator tingkat keamanan
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
                      0.2, // Keamanan dasar
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

  // Mendapatkan status keamanan berdasarkan pengaturan
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

  // Membangun bagian perubahan password
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
        // Field password lama
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
        // Field password baru
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
        // Indikator kekuatan password
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),
        // Field konfirmasi password baru
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
        // Tombol perbarui password
        _buildUpdatePasswordButton(),
      ],
    );
  }

  // Membangun field password khusus dengan berbagai opsi
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

  // Membangun indikator kekuatan password
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
        Row(
          children: [
            Text(
              'Kekuatan Kata Sandi: $_passwordStrengthText',
              style: TextStyle(
                color: _passwordStrengthColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            // Detil kriteria kekuatan password
            _buildStrengthDetails(),
          ],
        ),
      ],
    );
  }

  // Membangun detail kriteria kekuatan password
  Widget _buildStrengthDetails() {
    final password = _newPasswordController.text;
    return Row(
      children: [
        _strengthIndicator('Panjang', password.length >= 8),
        const SizedBox(width: 4),
        _strengthIndicator('Huruf Besar', password.contains(RegExp(r'[A-Z]'))),
        const SizedBox(width: 4),
        _strengthIndicator('Huruf Kecil', password.contains(RegExp(r'[a-z]'))),
        const SizedBox(width: 4),
        _strengthIndicator('Angka', password.contains(RegExp(r'[0-9]'))),
        const SizedBox(width: 4),
        _strengthIndicator(
            'Simbol', password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
      ],
    );
  }

  // Membuat indikator kekuatan untuk setiap kriteria
  Widget _strengthIndicator(String type, bool isValid) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isValid ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Tooltip(
        message: type,
        child: const SizedBox(),
      ),
    );
  }

  // Membangun tombol perbarui password
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

  // Fungsi untuk membangun bagian pengaturan keamanan utama
// Menampilkan section pengaturan keamanan dasar dengan switch untuk berbagai fitur keamanan
Widget _buildSecuritySettings() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Judul section pengaturan keamanan
      const Text(
        "Pengaturan Keamanan",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      
      // Container dengan bayangan untuk tile pengaturan keamanan
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
            // Tile pengaturan autentikasi dua faktor
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
            
            // Tile pengaturan login biometrik
            _buildSecurityTile(
              title: "Login Biometrik",
              subtitle: "Gunakan sidik jari atau Face ID untuk login",
              icon: Icons.fingerprint,
              isSwitch: true,
              value: _biometricEnabled,
              onChanged: (value) => setState(() => _biometricEnabled = value),
            ),
            const Divider(height: 1),
            
            // Tile pengaturan notifikasi email
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

// Fungsi untuk membangun section keamanan lanjutan
// Menampilkan opsi-opsi keamanan tambahan yang dapat diakses pengguna
Widget _buildAdvancedSecuritySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Judul section keamanan lanjutan
      const Text(
        "Keamanan Lanjutan",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      
      // Container dengan bayangan untuk tile keamanan lanjutan
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
            // Tile untuk mengelola perangkat terpercaya
            _buildSecurityTile(
              title: "Perangkat Terpercaya",
              subtitle: "Kelola perangkat yang dapat mengakses akun",
              icon: Icons.smartphone,
              onTap: () {
                // Navigasi ke halaman perangkat terpercaya
              },
            ),
            const Divider(height: 1),
            
            // Tile untuk melihat riwayat login
            _buildSecurityTile(
              title: "Riwayat Login",
              subtitle: "Pantau aktivitas login akun Anda",
              icon: Icons.history,
              onTap: () {
                // Navigasi ke halaman riwayat login
              },
            ),
            const Divider(height: 1),
            
            // Tile untuk pengaturan backup dan pemulihan
            _buildSecurityTile(
              title: "Backup & Pemulihan",
              subtitle: "Atur opsi pemulihan akun",
              icon: Icons.backup,
              onTap: () {
                // Navigasi ke pengaturan backup
              },
            ),
          ],
        ),
      ),
    ],
  );
}

// Fungsi pembuat tile keamanan yang fleksibel
// Digunakan untuk membuat item dengan ikon, judul, subjudul, dan switch/navigasi
Widget _buildSecurityTile({
  required String title,
  required String subtitle,
  required IconData icon,
  bool isSwitch = false,
  bool? value,
  Function(bool)? onChanged,
  VoidCallback? onTap,
}) {
  // Menentukan widget trailing berdasarkan tipe (switch atau panah)
  final Widget trailing = isSwitch
      ? Switch(
          value: value ?? false,
          onChanged: onChanged,
          activeColor: kprimaryColor,
        )
      : const Icon(Icons.arrow_forward_ios, size: 16);

  return ListTile(
    // Ikon leading dengan latar belakang berwarna
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

// Fungsi untuk menampilkan dialog informasi keamanan
// Berisi tips dan praktik keamanan terbaik
void _showSecurityInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // Judul dialog dengan ikon keamanan
      title: Row(
        children: [
          Icon(Icons.security, color: kprimaryColor),
          const SizedBox(width: 8),
          const Text("Tips Keamanan"),
        ],
      ),
      // Konten dialog dengan daftar tips keamanan
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tip tentang kata sandi yang kuat
            _buildSecurityTip(
              "Kata Sandi yang Kuat",
              "• Gunakan minimal 8 karakter\n"
                  "• Kombinasikan huruf besar dan kecil\n"
                  "• Tambahkan angka dan simbol khusus\n"
                  "• Hindari informasi pribadi yang mudah ditebak",
            ),
            const SizedBox(height: 16),
            // Tip praktik keamanan terbaik
            _buildSecurityTip(
              "Praktik Keamanan Terbaik",
              "• Aktifkan autentikasi dua faktor\n"
                  "• Ganti kata sandi secara berkala\n"
                  "• Jangan menggunakan kata sandi yang sama dengan akun lain\n"
                  "• Pantau aktivitas login secara rutin",
            ),
            const SizedBox(height: 16),
            // Tip perlindungan tambahan
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
      // Tombol untuk menutup dialog
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Mengerti"),
        ),
      ],
    ),
  );
}

// Fungsi untuk membuat item tip keamanan dalam dialog
// Membuat tata letak untuk setiap tips keamanan
Widget _buildSecurityTip(String title, String content) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Judul tips
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      // Konten tips
      Text(content),
    ],
  );
}

// Fungsi untuk menampilkan dialog sukses setelah pergantian kata sandi
void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // Judul dialog dengan ikon centang hijau
      title: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          const Text("Berhasil"),
        ],
      ),
      // Konten dialog konfirmasi pergantian kata sandi
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
      // Tombol OK untuk menutup dialog dan mereset form
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Bersihkan field form
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

// Fungsi untuk mengatur autentikasi dua faktor (2FA)
// Menampilkan dialog pilihan metode verifikasi tambahan
void _setup2FA(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // Judul dialog pengaturan 2FA
      title: Row(
        children: [
          Icon(Icons.security, color: kprimaryColor),
          const SizedBox(width: 8),
          const Text("Pengaturan 2FA"),
        ],
      ),
      // Konten dialog dengan pilihan metode 2FA
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilih metode verifikasi untuk meningkatkan keamanan akun Anda:",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          // Opsi 2FA via email
          _build2FAOption(
            icon: Icons.email,
            title: "Email",
            subtitle: "Kirim kode verifikasi melalui email",
            onTap: () => _configure2FAMethod(context, "email"),
          ),
          const SizedBox(height: 8),
          // Opsi 2FA via SMS
          _build2FAOption(
            icon: Icons.phone_android,
            title: "SMS",
            subtitle: "Kirim kode verifikasi melalui SMS",
            onTap: () => _configure2FAMethod(context, "sms"),
          ),
          const SizedBox(height: 8),
          // Opsi 2FA via aplikasi authenticator
          _build2FAOption(
            icon: Icons.apps,
            title: "Authenticator App",
            subtitle: "Gunakan aplikasi authenticator",
            onTap: () => _configure2FAMethod(context, "app"),
          ),
        ],
      ),
      // Tombol batal untuk menutup dialog
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

// Fungsi untuk membuat opsi pilihan metode 2FA
// Membuat tata letak untuk setiap metode verifikasi
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
          // Ikon metode 2FA
          Icon(icon, color: kprimaryColor),
          const SizedBox(width: 12),
          // Informasi detail metode
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
          // Ikon panah untuk navigasi
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

// Fungsi untuk mengonfigurasi metode 2FA yang dipilih
// Menampilkan dialog konfirmasi dan implementasi awal
void _configure2FAMethod(BuildContext context, String method) {
  // Implementasi alur setup 2FA berdasarkan metode yang dipilih
  Navigator.pop(context); // Tutup dialog pemilihan 2FA
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

// Fungsi untuk menampilkan opsi backup
// Akan menampilkan dialog atau halaman pengaturan backup data
void _showBackupOptions() {
  // TODO: Implementasi dialog atau halaman opsi backup
  // Misalnya menampilkan pilihan backup ke cloud, lokal, dll
}

// Fungsi untuk menampilkan riwayat login
// Menampilkan daftar aktivitas login sebelumnya
void _showLoginHistory() {
  // TODO: Implementasi tampilan riwayat login
  // Menampilkan daftar waktu, lokasi, dan perangkat login
}

// Fungsi untuk mengelola perangkat terpercaya
// Memungkinkan pengguna melihat dan mengatur daftar perangkat yang dapat mengakses akun
void _manageTrustedDevices() {
  // TODO: Implementasi manajemen perangkat terpercaya
  // Misalnya menampilkan daftar perangkat, opsi hapus perangkat, dll
}
}