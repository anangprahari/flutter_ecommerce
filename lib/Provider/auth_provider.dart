import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  List<User> _users = [];
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (_users.any((user) => user.email == email)) {
        return false;
      }

      final newUser = User(
        fullName: fullName,
        email: email,
        password: password,
      );

      _users.add(newUser);
      _currentUser = newUser;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Kesalahan pendaftaran: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );

      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Kesalahan masuk: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  bool checkAuthState() => _isAuthenticated;

  Map<String, dynamic>? getCurrentUserData() {
    if (_currentUser == null) return null;
    return {
      'fullName': _currentUser!.fullName,
      'email': _currentUser!.email,
    };
  }
}
