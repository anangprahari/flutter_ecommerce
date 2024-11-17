import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = "";
  String _address = "";
  String _bio = "";
  String _gender = "";
  String _birthDate = "";
  String _phoneNumber = "";
  String _email = "";
  String _profileImagePath = ""; // Add this line

  String get name => _name;
  String get address => _address;
  String get bio => _bio;
  String get gender => _gender;
  String get birthDate => _birthDate;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get profileImagePath => _profileImagePath; // Add this line

  void setUserData({
    required String name,
    required String address,
    required String bio,
    required String gender,
    required String birthDate,
    required String phoneNumber,
    required String email,
    String? profileImagePath, // Add this line
  }) {
    _name = name;
    _address = address;
    _bio = bio;
    _gender = gender;
    _birthDate = birthDate;
    _phoneNumber = phoneNumber;
    _email = email;
    if (profileImagePath != null) {
      // Add this block
      _profileImagePath = profileImagePath;
    }
    notifyListeners();
  }

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

  // Add a separate method for updating just the profile image
  void updateProfileImage(String path) {
    _profileImagePath = path;
    notifyListeners();
  }
}
