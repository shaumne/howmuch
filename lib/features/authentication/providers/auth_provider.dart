import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final Logger _logger = Logger();
  UserModel? _user;
  bool _isLoading = false;

  AuthProvider() {
    // Başlangıçta mevcut kullanıcıyı kontrol et
    _user = _authService.currentUser;
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<UserModel?> signInWithGoogle() async {
    _setLoading(true);
    try {
      final userModel = await _authService.signInWithGoogle();
      if (userModel != null) {
        _user = userModel;
        notifyListeners();
      }
      _setLoading(false);
      return userModel;
    } catch (e) {
      _logger.e('Google giriş hatası: $e');
      _setLoading(false);
      notifyListeners();
      return null;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Oturum durumunu kontrol et
  void checkAuthState() {
    _user = _authService.currentUser;
    notifyListeners();
  }
}
