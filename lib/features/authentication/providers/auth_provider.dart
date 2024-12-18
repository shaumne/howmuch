import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../admin/services/admin_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final AdminService _adminService = AdminService();
  final Logger _logger = Logger();
  UserModel? _user;
  bool _isLoading = false;
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  AuthProvider() {
    _initUser();
  }

  Future<void> _initUser() async {
    _user = _authService.currentUser;
    if (_user != null) {
      _isAdmin = await _adminService.isAdmin(_user!.uid);
      _logger.i('Kullanıcı Giriş Yaptı:');
      _logger.i('Email: ${_user!.email}');
      _logger.i('Admin mi?: ${_isAdmin ? "Evet" : "Hayır"}');
    }
    notifyListeners();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<UserModel?> signInWithGoogle() async {
    _setLoading(true);
    try {
      final userModel = await _authService.signInWithGoogle();
      if (userModel != null) {
        _user = userModel;
        _isAdmin = await _adminService.isAdmin(userModel.uid);
        _logger.i('Google ile Giriş Yapıldı:');
        _logger.i('Email: ${userModel.email}');
        _logger.i('Admin mi?: ${_isAdmin ? "Evet" : "Hayır"}');
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
