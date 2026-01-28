import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // ignore: unnecessary_import
import 'package:google_sign_in/google_sign_in.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.createdAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;
  late GoogleSignIn _googleSignIn;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeGoogleSignIn();
    _initializeAuth();
  }

  void _initializeGoogleSignIn() {
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId: '690282627556-u4nf9h7qgkjv5qa8v8t8vk8pv7j9k8l9.apps.googleusercontent.com',
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ],
      );
    }
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
      // Check if user was previously signed in
      _googleSignIn.signInSilently().then((account) {
        if (account != null) {
          _user = UserModel(
            id: account.id,
            email: account.email,
            displayName: account.displayName ?? 'User',
            photoURL: account.photoUrl,
            createdAt: DateTime.now(),
          );
        }
        _isLoading = false;
        notifyListeners();
      }).catchError((_) {
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      GoogleSignInAccount? account;
      
      if (kIsWeb) {
        // Mock Google sign-in for web
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
          email: 'testuser@gmail.com',
          displayName: 'Test User',
          photoURL: null,
          createdAt: DateTime.now(),
        );
      } else {
        // Real Google sign-in for mobile
        account = await _googleSignIn.signIn();
        
        if (account != null) {
          _user = UserModel(
            id: account.id,
            email: account.email,
            displayName: account.displayName ?? 'User',
            photoURL: account.photoUrl,
            createdAt: DateTime.now(),
          );
        } else {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to sign in with Google: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }

      _user = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to logout: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Test credentials fallback
      if (email == 'test@gmail.com' && password == '1234567') {
        await Future.delayed(const Duration(seconds: 1));
        _user = UserModel(
          id: 'test-user-id',
          email: email,
          displayName: 'Test User',
          photoURL: null,
          createdAt: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      _isLoading = false;
      _errorMessage = 'Invalid credentials';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      _user = UserModel(
        id: 'new-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@')[0].toUpperCase(),
        photoURL: null,
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}