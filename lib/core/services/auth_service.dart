import '../constants/api_url.dart';
import '../storage/token_storage.dart';
import 'api_service.dart';

/// Authentication Service for handling user authentication
class AuthService {
  // Private constructor to prevent instantiation
  AuthService._();

  /// Login user with email and password
  ///
  /// [email] - User's email address
  /// [password] - User's password
  ///
  /// Returns user data from the API response
  /// Throws an exception if login fails
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Make POST request to login endpoint
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/login',
        body: {'email': email, 'password': password},
      );

      // Extract token from response
      final token = response['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Token not found in response');
      }

      // Save token to SharedPreferences
      await TokenStorage.saveToken(token);

      // Save User ID
      if (response['user'] != null && response['user']['id'] != null) {
        await TokenStorage.saveUserId(response['user']['id']);
      }

      // Set token in ApiService for subsequent requests
      ApiService.setToken(token);

      // Return user data
      final userData = response['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw Exception('User data not found in response');
      }

      return userData;
    } on Exception catch (e) {
      // Handle specific error cases
      final errorMessage = e.toString();

      if (errorMessage.contains('Unauthorized') ||
          errorMessage.contains('401')) {
        throw Exception('Email atau password salah. Silakan coba lagi.');
      } else if (errorMessage.contains('422')) {
        throw Exception('Data yang Anda masukkan tidak valid.');
      } else if (errorMessage.contains('500')) {
        throw Exception(
          'Terjadi kesalahan pada server. Silakan coba lagi nanti.',
        );
      } else if (errorMessage.contains('Failed host lookup') ||
          errorMessage.contains('SocketException')) {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      } else {
        throw Exception(
          'Login gagal: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: $e');
    }
  }

  /// Logout user
  ///
  /// Clears the authentication token from storage and ApiService
  static Future<void> logout() async {
    try {
      // Clear token from storage
      await TokenStorage.clearToken();

      // Clear token from ApiService
      ApiService.clearToken();
    } catch (e) {
      throw Exception('Logout gagal: $e');
    }
  }

  /// Check if user is authenticated
  ///
  /// Returns true if user has a valid token, false otherwise
  static Future<bool> isAuthenticated() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Set token in ApiService
        ApiService.setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
