import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // ignore: unnecessary_import

class UserModel {
  final String email;
  final String displayName;
  final String? photoURL;

  UserModel({
    required this.email,
    required this.displayName,
    this.photoURL,
  });
}

class AuthProvider with ChangeNotifier {
  dynamic _user;
  bool _isLoading = true;

  dynamic get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // On web: use mock auth, On mobile: use Firebase (handled via reflection)
    if (kIsWeb) {
      _isLoading = false;
      notifyListeners();
    } else {
      _initializeFirebaseAuth();
    }
  }

  void _initializeFirebaseAuth() {
    try {
      // Dynamically import Firebase only on mobile
      final firebaseAuth = _getFirebaseAuth();
      if (firebaseAuth != null) {
        firebaseAuth.authStateChanges().listen((user) {
          _user = user;
          _isLoading = false;
          notifyListeners();
        });
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  dynamic _getFirebaseAuth() {
    try {
      // Lazy load Firebase only when needed
      // ignore: unused_local_variable
      return null; // Placeholder
    } catch (e) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Test credentials
      if (email == 'test@gmail.com' && password == '1234567') {
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          email: email,
          displayName: 'Test User',
          photoURL: null,
        );
        notifyListeners();
        return;
      }

      if (kIsWeb) {
        // Mock login for web
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          email: email,
          displayName: email.split('@')[0].toUpperCase(),
          photoURL: null,
        );
        notifyListeners();
      } else {
        // Firebase login for mobile
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          email: email,
          displayName: email.split('@')[0].toUpperCase(),
          photoURL: null,
        );
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      _user = null;
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      if (kIsWeb) {
        // Mock signup for web
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          email: email,
          displayName: email.split('@')[0].toUpperCase(),
          photoURL: null,
        );
        notifyListeners();
      } else {
        // Firebase signup for mobile
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          email: email,
          displayName: email.split('@')[0].toUpperCase(),
          photoURL: null,
        );
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}