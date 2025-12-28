import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/user_model.dart';

/// Profile Service - Handle API calls for user profile
class ProfileService {
  ProfileService._();

  /// Get current user profile
  static Future<UserModel> getProfile() async {
    try {
      final response = await ApiService.get('${ApiUrl.baseUrl}/user');

      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  static Future<UserModel> updateProfile({
    required String name,
    String? photo,
    String? nim,
    String? faculty,
    String? major,
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        if (photo != null) 'photo': photo,
        if (nim != null) 'nim': nim,
        if (faculty != null) 'faculty': faculty,
        if (major != null) 'major': major,
      };

      final response = await ApiService.put(
        '${ApiUrl.baseUrl}/user',
        body: body,
      );

      // Response bisa langsung user object atau wrapped dalam 'user' key
      if (response.containsKey('user')) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
        return UserModel.fromJson(response);
      }
    } catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('404')) {
        throw Exception('Endpoint tidak ditemukan. Hubungi administrator.');
      } else if (errorMessage.contains('validation')) {
        throw Exception('Data tidak valid. Periksa kembali input Anda.');
      } else {
        throw Exception(errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  /// Change user password
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final body = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      await ApiService.put('${ApiUrl.baseUrl}/user/password', body: body);
    } catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('current password')) {
        throw Exception('Password lama tidak sesuai');
      } else if (errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('validation')) {
        throw Exception('Password baru minimal 6 karakter');
      } else {
        throw Exception(errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      await ApiService.post('${ApiUrl.baseUrl}/logout');

      // Clear local token
      ApiService.clearToken();
    } catch (e) {
      // Even if API fails, clear local token
      ApiService.clearToken();
      rethrow;
    }
  }
}
