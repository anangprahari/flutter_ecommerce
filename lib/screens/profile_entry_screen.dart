import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Provider/user_provider.dart';
import 'nav_bar_screen.dart';
import '../constants.dart';

// Kelas StatefulWidget untuk layar entri profil pengguna
class ProfileEntryScreen extends StatefulWidget {
  const ProfileEntryScreen({Key? key}) : super(key: key);

  @override
  _ProfileEntryScreenState createState() => _ProfileEntryScreenState();
}

class _ProfileEntryScreenState extends State<ProfileEntryScreen> {
  // Kunci global untuk form validasi
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengelola input teks berbagai field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variabel untuk menyimpan jenis kelamin yang dipilih
  String _selectedGender = '';

  // Flag untuk status validasi form
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Memuat data pengguna yang sudah ada saat inisialisasi
    _loadExistingUserData();
    // Menyiapkan validasi form
    _setupFormValidation();
  }

  // Fungsi untuk memuat data pengguna yang sudah ada dari Firestore
  Future<void> _loadExistingUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Mengambil dokumen pengguna dari Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          // Memperbarui state dengan data yang ada
          setState(() {
            _nameController.text = userData.get('name') ?? '';
            _addressController.text = userData.get('address') ?? '';
            _bioController.text = userData.get('bio') ?? '';
            _birthDateController.text = userData.get('birthDate') ?? '';
            _phoneNumberController.text = userData.get('phoneNumber') ?? '';
            _emailController.text = userData.get('email') ?? '';
            _selectedGender = userData.get('gender') ?? '';
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  // Fungsi untuk menyiapkan validasi form secara dinamis
  void _setupFormValidation() {
    void validateForm() {
      setState(() {
        // Memperbarui status validasi form
        _isFormValid = _formKey.currentState?.validate() ?? false;
      });
    }

    // Menambahkan listener untuk setiap controller
    _nameController.addListener(validateForm);
    _addressController.addListener(validateForm);
    _bioController.addListener(validateForm);
    _birthDateController.addListener(validateForm);
    _phoneNumberController.addListener(validateForm);
    _emailController.addListener(validateForm);
  }

  @override
  void dispose() {
    // Membersihkan semua controller saat widget dihapus
    _nameController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih tanggal lahir menggunakan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Kustomisasi tema date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kprimaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Memperbarui controller dengan tanggal yang dipilih
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Validasi format email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi nomor telepon
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (value.length < 10 || value.length > 13) {
      return 'Nomor telepon harus 10-13 digit';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Membangun tampilan layar entri profil
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar dengan judul
      appBar: AppBar(
        title: const Text(
          "Masukkan Data Pribadi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: kprimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Body form dengan scroll view
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(), // Kartu informasi
              const SizedBox(height: 20),
              _buildNameField(), // Field nama
              const SizedBox(height: 16),
              _buildAddressField(), // Field alamat
              const SizedBox(height: 16),
              _buildBioField(), // Field bio
              const SizedBox(height: 16),
              _buildGenderSelector(), // Selector jenis kelamin
              const SizedBox(height: 16),
              _buildDateField(), // Field tanggal lahir
              const SizedBox(height: 16),
              _buildPhoneField(), // Field nomor telepon
              const SizedBox(height: 16),
              _buildEmailField(), // Field email
              const SizedBox(height: 24),
              _buildSubmitButton(), // Tombol submit
            ],
          ),
        ),
      ),
    );
  }

  // Widget kartu informasi
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kprimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kprimaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: kprimaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Data pribadi Anda akan disimpan di halaman profil dan dapat diperbarui kapan saja.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget field nama lengkap
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _buildInputDecoration(
        "Nama Lengkap",
        Icons.person_outline,
        "Masukkan nama lengkap Anda",
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Widget field alamat
  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: _buildInputDecoration(
        "Alamat",
        Icons.location_on_outlined,
        "Masukkan alamat lengkap Anda",
      ),
      maxLines: 2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Widget field bio
  Widget _buildBioField() {
    return TextFormField(
      controller: _bioController,
      decoration: _buildInputDecoration(
        "Bio",
        Icons.edit_outlined,
        "Ceritakan sedikit tentang Anda",
      ),
      maxLines: 3,
      maxLength: 150,
    );
  }

  // Widget selector jenis kelamin
  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jenis Kelamin",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                title: "Laki-laki",
                value: "Laki-laki",
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption(
                title: "Perempuan",
                value: "Perempuan",
                icon: Icons.female,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget opsi jenis kelamin
  Widget _buildGenderOption({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _selectedGender == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? kprimaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? kprimaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? kprimaryColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? kprimaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget field tanggal lahir
  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      decoration: _buildInputDecoration(
        "Tanggal Lahir",
        Icons.calendar_today_outlined,
        "Pilih tanggal lahir Anda",
      ).copyWith(
        suffixIcon: Icon(Icons.arrow_drop_down, color: kprimaryColor),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Widget field nomor telepon
  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: _buildInputDecoration(
        "No. Handphone",
        Icons.phone_outlined,
        "Contoh: 08123456789",
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
      ],
      validator: _validatePhone,
    );
  }

  // Widget field email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: _buildInputDecoration(
        "Email",
        Icons.email_outlined,
        "Contoh: nama@email.com",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
    );
  }

  // Widget tombol submit
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kprimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isFormValid
            ? () async {
                if (_formKey.currentState!.validate()) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      // Simpan data pengguna ke Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set({
                        'name': _nameController.text,
                        'address': _addressController.text,
                        'bio': _bioController.text,
                        'gender': _selectedGender,
                        'birthDate': _birthDateController.text,
                        'phoneNumber': _phoneNumberController.text,
                        'email': _emailController.text,
                      }, SetOptions(merge: true));

                      // Perbarui UserProvider
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserData(
                        name: _nameController.text,
                        address: _addressController.text,
                        bio: _bioController.text,
                        gender: _selectedGender,
                        birthDate: _birthDateController.text,
                        phoneNumber: _phoneNumberController.text,
                        email: _emailController.text,
                      );

                      // Navigasi ke layar navbar utama dan menghapus riwayat navigasi sebelumnya
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()),
                        (route) => false,
                      );
                    } catch (e) {
                      // Menampilkan pesan error jika penyimpanan profil gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error saving profile: ${e.toString()}')),
                      );
                    }
                  }
                }
              }
            : null,
        child: const Text(
          "Simpan dan Lanjutkan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat dekorasi input standar
  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
    String hint,
  ) {
    return InputDecoration(
      // Label teks di atas input
      labelText: label,
      // Petunjuk teks di dalam input
      hintText: hint,
      // Ikon prefix di sebelah kiri input
      prefixIcon: Icon(icon, color: kprimaryColor),

      // Gaya untuk label teks
      labelStyle: TextStyle(color: Colors.grey[700]),
      // Gaya untuk petunjuk teks
      hintStyle: TextStyle(color: Colors.grey[400]),

      // Border default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),

      // Border saat input aktif namun tidak difokus
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),

      // Border saat input difokus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kprimaryColor, width: 2),
      ),

      // Border saat terjadi error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),

      // Border saat error dan difokus
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),

      // Mengisi background input
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
