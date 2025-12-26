import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../../../core/storage/token_storage.dart';

/// Authentication Service for Register
class RegisterService {
  RegisterService._();

  /// Register new user
  /// Returns user data if successful
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String role = 'mahasiswa',
  }) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        },
      );

      // Extract token from response
      final token = response['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan dalam response');
      }

      // Save token to local storage
      await TokenStorage.saveToken(token);

      // Set token in API service for subsequent requests
      ApiService.setToken(token);

      // Return user data
      return response['user'] ?? response;
    } catch (e) {
      // Handle specific error cases
      final errorMessage = e.toString();

      if (errorMessage.contains('email') && errorMessage.contains('taken')) {
        throw Exception('Email sudah terdaftar. Silakan gunakan email lain.');
      } else if (errorMessage.contains('validation')) {
        throw Exception('Data tidak valid. Periksa kembali input Anda.');
      } else if (errorMessage.contains('422')) {
        throw Exception('Email sudah terdaftar atau data tidak valid.');
      } else if (errorMessage.contains('500')) {
        throw Exception('Terjadi kesalahan pada server. Coba lagi nanti.');
      } else if (errorMessage.contains('Failed host lookup') ||
          errorMessage.contains('SocketException')) {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      } else {
        throw Exception(errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }
}
