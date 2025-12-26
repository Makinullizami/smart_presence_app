import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';

/// Dashboard API Service
class DashboardApi {
  DashboardApi._();

  /// Fetch complete dashboard data
  /// Since /api/dashboard doesn't exist yet, we'll build it from existing endpoints
  static Future<Map<String, dynamic>> fetchDashboard() async {
    try {
      // Fetch user data
      final userResponse = await ApiService.get('${ApiUrl.baseUrl}/user');
      final user = userResponse['data'] ?? userResponse;

      // Fetch classes data
      final classesResponse = await ApiService.get('${ApiUrl.baseUrl}/classes');
      final classes = classesResponse['data'] ?? classesResponse;

      // Build dashboard data
      final dashboard = {
        'user': user,
        'today_attendance':
            null, // Will be null until attendance endpoint is ready
        'class_summary': {
          'total_classes': classes is List ? classes.length : 0,
          'today_classes': 0, // TODO: Calculate from schedule
          'lecturers': _extractLecturers(classes),
        },
        'notifications': [], // Empty until notification endpoint is ready
        'stats': {'present': 0, 'late': 0, 'absent': 0, 'attendance_rate': 0.0},
      };

      return dashboard;
    } catch (e) {
      throw Exception('Gagal memuat data dashboard: $e');
    }
  }

  /// Extract lecturers from classes data
  static List<String> _extractLecturers(dynamic classes) {
    if (classes is! List) return [];

    final lecturers = <String>{};
    for (var classItem in classes) {
      if (classItem is Map && classItem['lecturer'] != null) {
        lecturers.add(classItem['lecturer'].toString());
      }
    }

    return lecturers.take(3).toList();
  }

  /// Fetch user profile
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await ApiService.get('${ApiUrl.baseUrl}/user');
      return response['data'] ?? response;
    } catch (e) {
      throw Exception('Gagal memuat profil user: $e');
    }
  }

  /// Fetch attendance history
  static Future<List<Map<String, dynamic>>> fetchAttendanceHistory(
    int userId,
  ) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/attendance/history/$userId',
      );
      final data = response['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      // Return empty list if endpoint doesn't exist yet
      return [];
    }
  }

  /// Fetch notifications
  static Future<List<Map<String, dynamic>>> fetchNotifications(
    int userId,
  ) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/notifications/$userId',
      );
      final data = response['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      // Return empty list if endpoint doesn't exist yet
      return [];
    }
  }
}
