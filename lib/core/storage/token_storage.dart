import 'package:shared_preferences/shared_preferences.dart';

/// Token Storage for managing authentication tokens using SharedPreferences
class TokenStorage {
  // Private constructor to prevent instantiation
  TokenStorage._();

  /// Key for storing token in SharedPreferences
  static const String _tokenKey = 'auth_token';

  /// Save authentication token to local storage
  ///
  /// [token] - The authentication token to save
  /// Returns true if successful, false otherwise
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get authentication token from local storage
  ///
  /// Returns the token if exists, null otherwise
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }

  /// Clear authentication token from local storage
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tokenKey);
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }

  /// Check if token exists in local storage
  ///
  /// Returns true if token exists, false otherwise
  static Future<bool> hasToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Key for storing user ID in SharedPreferences
  static const String _userIdKey = 'user_id';

  /// Save user ID to local storage
  static Future<bool> saveUserId(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_userIdKey, userId);
    } catch (e) {
      throw Exception('Failed to save user ID: $e');
    }
  }

  /// Get user ID from local storage
  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userIdKey);
    } catch (e) {
      throw Exception('Failed to get user ID: $e');
    }
  }

  /// Clear user ID from local storage
  static Future<bool> clearUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userIdKey);
    } catch (e) {
      throw Exception('Failed to clear user ID: $e');
    }
  }
}
