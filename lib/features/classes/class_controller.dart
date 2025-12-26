import '../../core/constants/api_url.dart';
import '../../core/services/api_service.dart';

/// Class Controller for managing class-related operations
class ClassController {
  // Private constructor to prevent instantiation
  ClassController._();

  /// Fetch all classes from the API
  ///
  /// Returns a list of classes
  /// Throws an exception if the request fails
  static Future<List<Map<String, dynamic>>> fetchClasses() async {
    try {
      // Make GET request to classes endpoint
      // ApiService automatically includes Authorization Bearer token if available
      final response = await ApiService.get('${ApiUrl.baseUrl}/classes');

      // Extract classes data from response
      final classes = response['data'];

      if (classes == null) {
        throw Exception('Format data tidak valid: data key not found');
      }

      // Convert to List<Map<String, dynamic>>
      if (classes is List) {
        return List<Map<String, dynamic>>.from(classes);
      }

      throw Exception('Format data tidak valid: data is not a list');
    } on Exception catch (e) {
      // Handle specific error cases
      final errorMessage = e.toString();

      if (errorMessage.contains('Unauthorized') ||
          errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('403')) {
        throw Exception('Anda tidak memiliki akses untuk melihat data kelas.');
      } else if (errorMessage.contains('404')) {
        throw Exception('Endpoint kelas tidak ditemukan.');
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
          'Gagal mengambil data kelas: ${errorMessage.replaceAll('Exception: ', '')}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: $e');
    }
  }

  /// Fetch a single class by ID
  ///
  /// [classId] - The ID of the class to fetch
  ///
  /// Returns class data
  /// Throws an exception if the request fails
  static Future<Map<String, dynamic>> fetchClassById(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/classes/$classId',
      );

      // Extract class data from response
      final classData = response['data'] as Map<String, dynamic>?;

      if (classData == null) {
        // If 'data' key doesn't exist, return response directly
        return response;
      }

      return classData;
    } on Exception catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('Unauthorized') ||
          errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('404')) {
        throw Exception('Kelas tidak ditemukan.');
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
          'Gagal mengambil data kelas: ${errorMessage.replaceAll('Exception: ', '')}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga: $e');
    }
  }
}
