import '../../../core/services/api_service.dart';
import '../models/attendance_session_model.dart';
import '../models/student_attendance_model.dart';
import '../models/attendance_stats_model.dart';

/// Lecturer Attendance Service
/// Handles API calls for attendance monitoring
class LecturerAttendanceService {
  /// Fetch session details with students
  static Future<Map<String, dynamic>> fetchSessionDetails(int sessionId) async {
    try {
      final response = await ApiService.get(
        '/lecturer/attendance/session/$sessionId',
      );

      return response;
    } catch (e) {
      throw Exception('Gagal memuat data sesi: ${e.toString()}');
    }
  }

  /// Fetch session statistics
  static Future<AttendanceStatsModel> fetchSessionStats(int sessionId) async {
    try {
      final response = await ApiService.get(
        '/lecturer/attendance/session/$sessionId/stats',
      );

      return AttendanceStatsModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memuat statistik: ${e.toString()}');
    }
  }

  /// Close attendance session
  static Future<void> closeSession(int sessionId) async {
    try {
      await ApiService.post('/lecturer/attendance/session/$sessionId/close');
    } catch (e) {
      throw Exception('Gagal menutup sesi: ${e.toString()}');
    }
  }

  /// Parse session details response
  static Map<String, dynamic> parseSessionResponse(
    Map<String, dynamic> response,
  ) {
    final session = AttendanceSessionModel.fromJson(response['session'] ?? {});

    final studentsList =
        (response['students'] as List?)?.map((student) {
          return StudentAttendanceModel.fromJson(student);
        }).toList() ??
        [];

    final stats = AttendanceStatsModel.fromJson(response['stats'] ?? {});

    return {'session': session, 'students': studentsList, 'stats': stats};
  }
}
