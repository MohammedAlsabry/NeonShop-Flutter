import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/features/auth/services/auth_service.dart';

// Authentication state management
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  User? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _user = _authService.currentUser;
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Register a new account
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.registerWithEmail(
        fullName: fullName,
        email: email,
        password: password,
      );

      await _authService.signOut();
      _user = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
