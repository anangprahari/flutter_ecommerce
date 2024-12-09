import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../../Provider/user_provider.dart';
import '../../constants.dart';

// Halaman Edit Profil sebagai StatefulWidget
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Kunci global untuk form validasi
  final _formKey = GlobalKey<FormState>();

  // Kontroler teks untuk setiap input field
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;

  // Variabel untuk menyimpan jenis kelamin yang dipilih
  late String _selectedGender;

  // Flag untuk mengecek validitas form
  bool _isFormValid = false;

  // Path gambar profil
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    // Mendapatkan data pengguna dari UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Menginisialisasi kontroler dengan data yang sudah ada
    _nameController = TextEditingController(text: userProvider.name);
    _addressController = TextEditingController(text: userProvider.address);
    _bioController = TextEditingController(text: userProvider.bio);
    _birthDateController = TextEditingController(text: userProvider.birthDate);
    _phoneNumberController =
        TextEditingController(text: userProvider.phoneNumber);
    _emailController = TextEditingController(text: userProvider.email);
    _selectedGender = userProvider.gender;

    // Menyiapkan validasi form
    _setupFormValidation();
  }

  // Metode untuk menyiapkan validasi form secara dinamis
  void _setupFormValidation() {
    void validateForm() {
      setState(() {
        // Memperbarui status validasi form
        _isFormValid = _formKey.currentState?.validate() ?? false;
      });
    }

    // Menambahkan listener untuk setiap kontroler
    _nameController.addListener(validateForm);
    _addressController.addListener(validateForm);
    _bioController.addListener(validateForm);
    _birthDateController.addListener(validateForm);
    _phoneNumberController.addListener(validateForm);
    _emailController.addListener(validateForm);
  }

  @override
  void dispose() {
    // Membersihkan semua kontroler saat widget dihapus
    _nameController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Metode untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Mengkustomisasi tema date picker
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

    // Memperbarui kontroler dengan tanggal yang dipilih
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Metode untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
        // Memperbarui path gambar profil di provider
        Provider.of<UserProvider>(context, listen: false)
            .updateProfileImage(image.path);
      }
    } catch (e) {
      // Menampilkan pesan kesalahan jika gagal memilih gambar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar')),
      );
    }
  }

  // Metode untuk menyimpan perubahan profil
  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Menyimpan data pengguna ke Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'name': _nameController.text,
            'address': _addressController.text,
            'bio': _bioController.text,
            'gender': _selectedGender,
            'birthDate': _birthDateController.text,
            'phoneNumber': _phoneNumberController.text,
            'email': _emailController.text,
          });

          // Memperbarui data pengguna di UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserData(
            name: _nameController.text,
            address: _addressController.text,
            bio: _bioController.text,
            gender: _selectedGender,
            birthDate: _birthDateController.text,
            phoneNumber: _phoneNumberController.text,
            email: _emailController.text,
            profileImagePath: _profileImagePath,
          );

          // Menampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );

          // Kembali ke halaman sebelumnya
          Navigator.pop(context);
        } catch (e) {
          // Menampilkan pesan kesalahan jika gagal memperbarui
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memperbarui profil: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar untuk halaman edit profil
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header profil dengan foto dan informasi dasar
              _buildProfileHeader(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input field untuk berbagai informasi profil
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildAddressField(),
                    const SizedBox(height: 16),
                    _buildBioField(),
                    const SizedBox(height: 16),
                    _buildGenderSelector(),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Membangun AppBar untuk halaman edit profil
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Edit Profil',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: kprimaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // Tombol simpan yang hanya aktif jika form valid
        TextButton(
          onPressed: _isFormValid ? _saveChanges : null,
          child: Text(
            'Simpan',
            style: TextStyle(
              color: _isFormValid ? Colors.white : Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // Membangun header profil dengan foto dan informasi dasar
  Widget _buildProfileHeader() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: kprimaryColor,
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                // Avatar profil dengan kemampuan untuk memilih gambar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImagePath != null
                        ? FileImage(File(_profileImagePath!))
                        : userProvider.profileImagePath.isNotEmpty
                            ? FileImage(File(userProvider.profileImagePath))
                            : const AssetImage("images/risky.jpg")
                                as ImageProvider,
                  ),
                ),
                // Tombol untuk memilih gambar
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: kprimaryColor, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt,
                          color: kprimaryColor, size: 20),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Nama dan email pengguna
            Text(
              _nameController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _emailController.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Input field untuk nama lengkap
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
        // Validasi nama tidak boleh kosong
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Input field untuk alamat
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
        // Validasi alamat tidak boleh kosong
        if (value == null || value.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Input field untuk bio
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

  // Selector untuk memilih jenis kelamin
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
            // Opsi jenis kelamin laki-laki
            Expanded(
              child: _buildGenderOption(
                title: "Laki-laki",
                value: "Laki-laki",
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 12),
            // Opsi jenis kelamin perempuan
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

  // Widget untuk setiap opsi jenis kelamin
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
          // Desain untuk opsi yang dipilih
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

  // Metode untuk membangun input field tanggal lahir
  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true, // Membuat field hanya bisa dibuka melalui date picker
      decoration: _buildInputDecoration(
        "Tanggal Lahir",
        Icons.calendar_today_outlined,
        "Pilih tanggal lahir Anda",
      ).copyWith(
        // Menambahkan ikon dropdown di sebelah kanan
        suffixIcon: Icon(Icons.arrow_drop_down, color: kprimaryColor),
      ),
      onTap: () => _selectDate(context), // Membuka date picker saat di-tap
      validator: (value) {
        // Validasi tanggal lahir tidak boleh kosong
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Metode untuk membangun input field nomor telepon
  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: _buildInputDecoration(
        "No. Handphone",
        Icons.phone_outlined,
        "Contoh: 08123456789",
      ),
      keyboardType: TextInputType.phone,
      // Membatasi input hanya untuk angka dan panjang 13 digit
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
      ],
      validator: (value) {
        // Validasi nomor telepon
        if (value == null || value.isEmpty) {
          return 'Nomor telepon tidak boleh kosong';
        }
        if (value.length < 10 || value.length > 13) {
          return 'Nomor telepon harus 10-13 digit';
        }
        return null;
      },
    );
  }

  // Metode untuk membangun input field email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: _buildInputDecoration(
        "Email",
        Icons.email_outlined,
        "Contoh: nama@email.com",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        // Validasi email
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        // Regex untuk memvalidasi format email
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  // Metode untuk membuat dekorasi input yang konsisten
  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
    String hint,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: kprimaryColor),
      labelStyle: TextStyle(color: Colors.grey[700]),
      hintStyle: TextStyle(color: Colors.grey[400]),
      // Berbagai konfigurasi border untuk kondisi berbeda
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kprimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}
