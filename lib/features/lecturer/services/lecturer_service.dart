import '../../../core/services/api_service.dart';
import '../../../core/constants/api_url.dart';
import '../models/lecturer_dashboard_model.dart';

/// Lecturer Service - Handles API calls for lecturer features
class LecturerService {
  /// Fetch lecturer dashboard summary
  static Future<LecturerDashboardModel> fetchDashboard() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/dashboard',
      );

      if (response['data'] != null) {
        return LecturerDashboardModel.fromJson(response['data']);
      }

      throw Exception('Data dashboard tidak ditemukan');
    } catch (e) {
      throw Exception('Gagal memuat dashboard: ${e.toString()}');
    }
  }

  /// Fetch lecturer's classes
  static Future<List<LecturerClassModel>> fetchLecturerClasses() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/classes',
      );

      if (response['data'] != null) {
        final List<dynamic> classesJson = response['data'];
        return classesJson
            .map((json) => LecturerClassModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Gagal memuat daftar kelas: ${e.toString()}');
    }
  }

  /// Fetch attendance summary for a specific class
  static Future<AttendanceStatsModel> fetchAttendanceSummary(
    int classId,
  ) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/classes/$classId/attendance-summary',
      );

      if (response['data'] != null) {
        return AttendanceStatsModel.fromJson(response['data']);
      }

      // Return empty stats if no data
      return AttendanceStatsModel(present: 0, late: 0, absent: 0, total: 0);
    } catch (e) {
      throw Exception('Gagal memuat ringkasan absensi: ${e.toString()}');
    }
  }

  /// Open attendance session for a class
  static Future<AttendanceSessionModel> openAttendanceSession(
    int classId,
  ) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/lecturer/attendance-session/open',
        body: {'class_id': classId},
      );

      if (response['data'] != null) {
        return AttendanceSessionModel.fromJson(response['data']);
      }

      throw Exception('Gagal membuka sesi absensi');
    } catch (e) {
      throw Exception('Gagal membuka sesi absensi: ${e.toString()}');
    }
  }

  /// Close attendance session
  static Future<AttendanceSessionModel> closeAttendanceSession(
    int sessionId,
  ) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/lecturer/attendance-session/close',
        body: {'session_id': sessionId},
      );

      if (response['data'] != null) {
        return AttendanceSessionModel.fromJson(response['data']);
      }

      throw Exception('Gagal menutup sesi absensi');
    } catch (e) {
      throw Exception('Gagal menutup sesi absensi: ${e.toString()}');
    }
  }
}
