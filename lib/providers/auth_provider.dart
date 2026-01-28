import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userEmail;
  bool _isLoading = false;

  String? get user => _userEmail;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Initialize without Firebase for now
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Mock login - in real app, this would call Firebase or your backend
    await Future.delayed(const Duration(seconds: 1));
    _userEmail = email;
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _userEmail = null;
    notifyListeners();
  }
}