import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'profile_entry_screen.dart';
import '../Provider/auth_provider.dart';
import '../constants.dart';

// Widget StatefulWidget untuk halaman pendaftaran
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

// State untuk halaman pendaftaran
class _RegisterScreenState extends State<RegisterScreen> {
  // Key untuk form validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input teks
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Status persetujuan syarat & ketentuan
  bool _agreedToTerms = false;

  // Status loading saat proses pendaftaran
  bool _isLoading = false;

  // Status visibilitas password
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Bagian Logo
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // Gradien warna latar belakang logo
                  gradient: LinearGradient(
                    colors: [kprimaryColor, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.3, 1.0],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Image.asset(
                    'images/icon/Jenshop.png',
                    height: 230,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Bagian Formulir Pendaftaran
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  // Dekorasi container formulir dengan shadow dan rounded corner
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Halaman
                      Center(
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kprimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Nama Lengkap
                      TextFormField(
                        controller: _fullNameController,
                        decoration: _inputDecoration(
                          "Nama Lengkap",
                          Icons.person,
                        ),
                        // Validasi input nama lengkap
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Silakan masukkan nama lengkap Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Input Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          "Email",
                          Icons.email,
                        ),
                        // Validasi input email
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Silakan masukkan email Anda';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value!)) {
                            return 'Silakan masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Input Kata Sandi
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: _inputDecoration(
                          "Kata sandi",
                          Icons.lock,
                          // Tombol untuk mengubah visibilitas password
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        // Validasi input kata sandi
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Silakan masukkan kata sandi Anda';
                          }
                          if (value!.length < 6) {
                            return 'Kata sandi minimal harus 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Persetujuan Syarat & Ketentuan
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            activeColor: kprimaryColor,
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "Saya setuju dengan ",
                                style: TextStyle(color: Colors.grey[600]),
                                children: [
                                  TextSpan(
                                    text: "Syarat & Ketentuan ",
                                    style: TextStyle(
                                      color: kprimaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Dan ",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  TextSpan(
                                    text: "Kebijakan Privasi",
                                    style: TextStyle(
                                      color: kprimaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tombol Buat Akun
                      Center(
                        child: _isLoading
                            // Indikator loading saat proses pendaftaran
                            ? const CircularProgressIndicator(
                                color: kprimaryColor,
                              )
                            // Tombol untuk mendaftar
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kprimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 10),
                                ),
                                onPressed: _handleRegister,
                                child: const Text(
                                  "Buat Akun",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Pemisah dengan opsi masuk lain
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[400])),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("atau"),
                          ),
                          Expanded(child: Divider(color: Colors.grey[400])),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tombol Masuk dengan Google
                      Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: Image.asset(
                            'images/icon/google.png',
                            height: 24,
                            width: 24,
                          ),
                          label: const Text(
                            "Masuk dengan Google",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          // Fungsi untuk login dengan Google
                          onPressed: () async {
                            if (_isLoading) return;

                            setState(() => _isLoading = true);

                            try {
                              final success = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .signInWithGoogle();

                              if (success) {
                                if (!mounted) return;

                                // Navigasi ke halaman pengisian profil
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileEntryScreen()),
                                );
                              } else {
                                if (!mounted) return;

                                // Menampilkan pesan error jika login Google gagal
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Pendaftaran dengan Google gagal'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Menangani error yang tidak terduga
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Gagal mendaftar dengan Google: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tombol untuk navigasi ke halaman login
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Sudah punya akun? Masuk",
                            style: TextStyle(
                              color: kprimaryColor,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Metode untuk membuat dekorasi input field
  InputDecoration _inputDecoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      prefixIcon: Icon(icon, color: kprimaryColor),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kprimaryColor),
      ),
    );
  }

  // Metode untuk menangani proses pendaftaran
  Future<void> _handleRegister() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Cek persetujuan syarat & ketentuan
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui Syarat & Ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mulai proses loading
    setState(() => _isLoading = true);

    try {
      // Proses registrasi melalui AuthProvider
      final success =
          await Provider.of<AuthProvider>(context, listen: false).register(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success) {
        if (!mounted) return;

        // Menampilkan pesan berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Silakan masuk.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        if (!mounted) return;

        // Menampilkan pesan error jika pendaftaran gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran gagal. Email mungkin sudah terdaftar.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Menangani error yang tidak terduga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pendaftaran gagal: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Menghentikan status loading
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Membersihkan controller saat widget dihancurkan
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
