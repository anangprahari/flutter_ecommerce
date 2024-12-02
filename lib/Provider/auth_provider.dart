import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Initialize the provider by checking current authentication state
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Email and Password Registration
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with full name
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload();

      _currentUser = _auth.currentUser;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Kesalahan pendaftaran: ${e.message}');
      return false;
    } catch (e) {
      print('Kesalahan pendaftaran: $e');
      return false;
    }
  }

  // Email and Password Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = _auth.currentUser;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Kesalahan masuk: ${e.message}');
      return false;
    } catch (e) {
      print('Kesalahan masuk: $e');
      return false;
    }
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Canceled by user
        return false;
      }

      // Obtain the auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      await _auth.signInWithCredential(credential);

      _currentUser = _auth.currentUser;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      print('Sign-In Error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google if signed in with Google
      await GoogleSignIn().signOut();

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Get current user data
  Map<String, dynamic>? getCurrentUserData() {
    if (_currentUser == null) return null;
    return {
      'fullName': _currentUser!.displayName,
      'email': _currentUser!.email,
      'uid': _currentUser!.uid,
    };
  }
}
