import '../../../core/services/api_service.dart';
import '../../../core/constants/api_url.dart';
import '../models/class_model.dart';
import '../../../core/models/user_model.dart';

/// Class Service - Handles API calls for class management
class ClassService {
  /// Fetch all classes for the current user (student)
  static Future<List<ClassModel>> fetchClasses() async {
    try {
      final response = await ApiService.get('${ApiUrl.baseUrl}/classes');

      if (response['data'] != null) {
        final List<dynamic> classesJson = response['data'];
        return classesJson.map((json) => ClassModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Gagal memuat daftar kelas: ${e.toString()}');
    }
  }

  /// Fetch class detail by ID
  static Future<ClassModel> fetchClassDetail(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/classes/$classId',
      );

      if (response['data'] != null) {
        return ClassModel.fromJson(response['data']);
      }

      throw Exception('Data kelas tidak ditemukan');
    } catch (e) {
      throw Exception('Gagal memuat detail kelas: ${e.toString()}');
    }
  }

  /// Fetch class schedules
  static Future<List<ScheduleModel>> fetchClassSchedule(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/schedules/$classId',
      );

      if (response['data'] != null) {
        final List<dynamic> schedulesJson = response['data'];
        return schedulesJson
            .map((json) => ScheduleModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Gagal memuat jadwal kelas: ${e.toString()}');
    }
  }

  /// Fetch attendance summary for a class
  static Future<AttendanceSummaryModel> fetchAttendanceSummary(
    int classId,
    int userId,
  ) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/attendance/history/$userId?class_id=$classId',
      );

      if (response['summary'] != null) {
        return AttendanceSummaryModel.fromJson(response['summary']);
      }

      // Return empty summary if no data
      // Return empty summary if no data
      return AttendanceSummaryModel(
        present: 0,
        late: 0,
        absent: 0,
        totalSessions: 0,
      );
    } catch (e) {
      throw Exception('Gagal memuat ringkasan absensi: ${e.toString()}');
    }
  }

  /// Fetch students in a class
  static Future<List<UserModel>> fetchClassStudents(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/classes/$classId/students',
      );

      if (response['data'] != null) {
        final List<dynamic> studentsJson = response['data'];
        return studentsJson.map((json) => UserModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Gagal memuat daftar mahasiswa: ${e.toString()}');
    }
  }

  /// Start class session
  static Future<Map<String, dynamic>> startSession(int classId) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/classes/$classId/sessions/start',
      );
      return response;
    } catch (e) {
      throw Exception('Gagal memulai sesi: ${e.toString()}');
    }
  }

  /// Stop class session
  static Future<Map<String, dynamic>> stopSession(int classId) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/classes/$classId/sessions/stop',
      );
      return response;
    } catch (e) {
      throw Exception('Gagal menghentikan sesi: ${e.toString()}');
    }
  }

  /// Get active session
  static Future<Map<String, dynamic>?> getActiveSession(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/classes/$classId/active-session',
      );

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      }
      return null;
    } catch (e) {
      // Return null instead of throwing if just checking status
      return null;
    }
  }
}
