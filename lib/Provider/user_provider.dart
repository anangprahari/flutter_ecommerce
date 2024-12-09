import 'package:flutter/material.dart';

// Provider untuk mengelola data pengguna
class UserProvider with ChangeNotifier {
  // Variabel untuk menyimpan informasi pribadi pengguna
  String _name = "";
  String _address = "";
  String _bio = "";
  String _gender = "";
  String _birthDate = "";
  String _phoneNumber = "";
  String _email = "";
  String _profileImagePath = ""; // Tambahan untuk menyimpan path gambar profil

  // Getter untuk mengakses variabel privat
  String get name => _name;
  String get address => _address;
  String get bio => _bio;
  String get gender => _gender;
  String get birthDate => _birthDate;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get profileImagePath => _profileImagePath;

  // Metode untuk mengatur data pengguna sekaligus
  void setUserData({
    required String name,
    required String address,
    required String bio,
    required String gender,
    required String birthDate,
    required String phoneNumber,
    required String email,
    String? profileImagePath, // Parameter opsional untuk path gambar profil
  }) {
    // Memperbarui semua informasi pengguna
    _name = name;
    _address = address;
    _bio = bio;
    _gender = gender;
    _birthDate = birthDate;
    _phoneNumber = phoneNumber;
    _email = email;

    // Memperbarui path gambar profil jika disediakan
    if (profileImagePath != null) {
      _profileImagePath = profileImagePath;
    }

    notifyListeners(); // Memberi tahu pendengar bahwa data telah berubah
  }

  // Metode untuk menghapus semua data pengguna
  void clearUserData() {
    _name = '';
    _address = '';
    _bio = '';
    _gender = '';
    _birthDate = '';
    _phoneNumber = '';
    _email = '';
    _profileImagePath = '';
    notifyListeners();
  }

  // Metode untuk memperbarui hanya gambar profil
  void updateProfileImage(String path) {
    _profileImagePath = path;
    notifyListeners();
  }
}
