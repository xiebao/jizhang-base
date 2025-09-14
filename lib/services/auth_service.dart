import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import '../database/database_helper.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Hash password
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Public method for hashing password (for test data initialization)
  static String hashPassword(String password) {
    return _hashPassword(password);
  }

  // Register user
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String verificationCode,
  }) async {
    try {
      // Check if username already exists
      final existingUser = await DatabaseHelper().getUserByUsername(username);
      if (existingUser != null) {
        return false;
      }

      // Check if email already exists
      final existingEmail = await DatabaseHelper().getUserByEmail(email);
      if (existingEmail != null) {
        return false;
      }

      // Create new user
      final user = User(
        username: username,
        email: email,
        password: _hashPassword(password),
        createdAt: DateTime.now(),
      );

      final userId = await DatabaseHelper().insertUser(user);
      return userId > 0;
    } catch (e) {
      return false;
    }
  }

  // Login user
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = await DatabaseHelper().getUserByUsername(username);
      if (user == null) {
        return false;
      }

      final hashedPassword = _hashPassword(password);
      if (user.password != hashedPassword) {
        return false;
      }

      // Store login state
      await _storage.write(key: _isLoggedInKey, value: 'true');
      await _storage.write(key: _userKey, value: user.username);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  static Future<void> logout() async {
    await _storage.delete(key: _isLoggedInKey);
    await _storage.delete(key: _userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final isLoggedIn = await _storage.read(key: _isLoggedInKey);
    return isLoggedIn == 'true';
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final username = await _storage.read(key: _userKey);
      if (username == null) {
        return null;
      }
      return await DatabaseHelper().getUserByUsername(username);
    } catch (e) {
      return null;
    }
  }

  // Get current username
  static Future<String?> getCurrentUsername() async {
    return await _storage.read(key: _userKey);
  }
}
