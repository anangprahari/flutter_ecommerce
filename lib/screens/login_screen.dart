import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_entry_screen.dart';
import '../Provider/auth_provider.dart';
import '../constants.dart';

// Widget LoginScreen sebagai halaman login
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// State untuk widget LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Key untuk form validation
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State untuk loading dan visibility password
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: ConstrainedBox(
          // Constraint untuk memastikan tinggi minimum sesuai layar
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Bagian logo dengan gradient background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
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

                // Bagian form login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    // Dekorasi container form
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
                        // Judul form login
                        Center(
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kprimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Field input email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            "Email",
                            Icons.email,
                          ),
                          // Validasi email
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

                        // Field input password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: _inputDecoration(
                            "Kata sandi",
                            Icons.lock,
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
                          // Validasi password
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Silakan masukkan kata sandi Anda';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Tombol login
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: kprimaryColor,
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kprimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 10),
                                  ),
                                  onPressed: _handleLogin,
                                  child: const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),

                        // Pembatas dengan teks "atau"
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

                        // Tombol login dengan Google
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
                            // Handler untuk login Google
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

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfileEntryScreen()),
                                  );
                                } else {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Masuk dengan Google gagal'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Gagal masuk dengan Google: ${e.toString()}'),
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

                        // Link ke halaman registrasi
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Belum punya akun? Daftar Sekarang",
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
      ),
    );
  }

  // Method untuk membuat dekorasi input field
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

  // Method untuk menangani proses login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success =
          await Provider.of<AuthProvider>(context, listen: false).login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileEntryScreen()),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau kata sandi tidak valid'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal masuk: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Method untuk membersihkan controller saat widget di dispose
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
