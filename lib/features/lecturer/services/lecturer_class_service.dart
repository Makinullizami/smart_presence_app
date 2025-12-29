import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../models/lecturer_dashboard_model.dart';

/// Lecturer Class Service
/// Handles API calls for lecturer classes
class LecturerClassService {
  /// Fetch all classes for the logged-in lecturer
  static Future<List<LecturerClassModel>> fetchClasses() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/classes',
      );

      final classList =
          (response['data'] as List?)?.map((classData) {
            return LecturerClassModel.fromJson(classData);
          }).toList() ??
          [];

      return classList;
    } catch (e) {
      throw Exception('Gagal memuat daftar kelas: ${e.toString()}');
    }
  }

  /// Create a new class
  static Future<LecturerClassModel> createClass({
    required String name,
    String? code,
    String? description,
  }) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/lecturer/classes',
        body: {
          'name': name,
          if (code != null && code.isNotEmpty) 'code': code,
          if (description != null && description.isNotEmpty)
            'description': description,
        },
      );

      return LecturerClassModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal membuat kelas: ${e.toString()}');
    }
  }

  /// Delete a class
  static Future<void> deleteClass(int classId) async {
    try {
      await ApiService.delete('${ApiUrl.baseUrl}/lecturer/classes/$classId');
    } catch (e) {
      throw Exception('Gagal menghapus kelas: ${e.toString()}');
    }
  }

  /// Start attendance session
  static Future<void> startSession(int classId) async {
    try {
      await ApiService.post(
        '${ApiUrl.baseUrl}/classes/$classId/sessions/start',
      );
    } catch (e) {
      throw Exception('Gagal memulai sesi: ${e.toString()}');
    }
  }

  /// Stop attendance session
  static Future<void> stopSession(int classId) async {
    try {
      await ApiService.post('${ApiUrl.baseUrl}/classes/$classId/sessions/stop');
    } catch (e) {
      throw Exception('Gagal menutup sesi: ${e.toString()}');
    }
  }
}
