import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider untuk mengelola otentikasi pengguna menggunakan Firebase
class AuthProvider with ChangeNotifier {
  // Instansi FirebaseAuth untuk operasi autentikasi
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variabel untuk menyimpan pengguna saat ini
  User? _currentUser;

  // Getter untuk mendapatkan pengguna saat ini
  User? get currentUser => _currentUser;

  // Getter untuk mengecek status otentikasi
  bool get isAuthenticated => _currentUser != null;

  // Konstruktor untuk menginisialisasi provider dan mengamati perubahan status autentikasi
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      // Memberi tahu listeners jika status autentikasi berubah
      notifyListeners();
    });
  }

  // Metode untuk mendaftarkan pengguna baru dengan email dan password
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // Membuat pengguna baru dengan Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Memperbarui profil pengguna dengan nama lengkap
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload();

      // Memperbarui pengguna saat ini
      _currentUser = _auth.currentUser;
      // Memberi tahu listeners
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // Menangani kesalahan dari Firebase
      print('Kesalahan pendaftaran: ${e.message}');
      return false;
    } catch (e) {
      // Menangani kesalahan umum
      print('Kesalahan pendaftaran: $e');
      return false;
    }
  }

  // Metode untuk login pengguna dengan email dan password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Login menggunakan Firebase Authentication
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Memperbarui pengguna saat ini
      _currentUser = _auth.currentUser;
      // Memberi tahu listeners
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // Menangani kesalahan dari Firebase
      print('Kesalahan masuk: ${e.message}');
      return false;
    } catch (e) {
      // Menangani kesalahan umum
      print('Kesalahan masuk: $e');
      return false;
    }
  }

  // Metode untuk login menggunakan akun Google
  Future<bool> signInWithGoogle() async {
    try {
      // Inisialisasi Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Memulai alur otentikasi Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Jika login dibatalkan oleh pengguna
        return false;
      }

      // Mendapatkan detail otentikasi Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Membuat kredensial baru
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase menggunakan kredensial
      await _auth.signInWithCredential(credential);

      // Memperbarui pengguna saat ini
      _currentUser = _auth.currentUser;
      // Memberi tahu listeners
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // Menangani kesalahan dari Firebase
      print('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      // Menangani kesalahan umum
      print('Sign-In Error: $e');
      return false;
    }
  }

  // Metode untuk logout pengguna
  Future<void> logout() async {
    try {
      // Logout dari Firebase
      await _auth.signOut();

      // Logout dari Google jika login menggunakan Google
      await GoogleSignIn().signOut();

      // Mengatur pengguna saat ini menjadi null
      _currentUser = null;
      // Memberi tahu listeners
      notifyListeners();
    } catch (e) {
      // Menangani kesalahan logout
      print('Logout error: $e');
    }
  }

  // Metode untuk mendapatkan data pengguna saat ini
  Map<String, dynamic>? getCurrentUserData() {
    if (_currentUser == null) return null;
    return {
      'fullName': _currentUser!.displayName,
      'email': _currentUser!.email,
      'uid': _currentUser!.uid,
    };
  }
}
