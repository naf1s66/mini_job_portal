import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;

  void bootstrap() {
    final user = StorageService.currentUser;
    if (user != null) {
      _email = user;
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  static String _hash(String plain) {
    final bytes = utf8.encode(plain);
    return sha256.convert(bytes).toString();
  }

  Future<String?> signUp(String email, String password) async {
    if (StorageService.userExists(email)) {
      return 'User already exists';
    }
    final hash = _hash(password);
    StorageService.saveUser(email, hash);
    StorageService.setCurrentUser(email);
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    final stored = StorageService.getPasswordHash(email);
    if (stored == null) {
      return 'User not found';
    }
    final hash = _hash(password);
    if (hash != stored) {
      return 'Invalid credentials';
    }
    StorageService.setCurrentUser(email);
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
    return null;
  }

  void signOut() {
    StorageService.clearSession();
    _email = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
