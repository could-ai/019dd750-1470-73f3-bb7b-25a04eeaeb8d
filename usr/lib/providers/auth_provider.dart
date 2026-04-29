import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    // Mock login
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _email = email;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    // Mock signup
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _email = email;
    notifyListeners();
  }

  Future<void> logout() async {
    // Mock logout
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _email = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    // Mock account deletion
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = false;
    _email = null;
    notifyListeners();
  }
}
