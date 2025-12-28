import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../models/attendance_model.dart';

/// Attendance Service - Handle API calls for attendance
class AttendanceService {
  AttendanceService._();

  /// Get today's attendance status
  static Future<AttendanceModel?> getTodayAttendance() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/attendance/today',
      );

      if (response['attendance'] != null) {
        return AttendanceModel.fromJson(
          response['attendance'] as Map<String, dynamic>,
        );
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Check-in attendance
  static Future<AttendanceModel> checkIn({
    required AttendanceMethod method,
    String? location,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final body = <String, dynamic>{
        'method': method.value,
        if (location != null) 'location': location,
        if (additionalData != null) ...additionalData,
      };

      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/attendance/check-in',
        body: body,
      );

      return AttendanceModel.fromJson(
        response['attendance'] as Map<String, dynamic>,
      );
    } catch (e) {
      // Handle specific errors
      final errorMessage = e.toString();

      if (errorMessage.contains('already checked in')) {
        throw Exception('Anda sudah melakukan check-in hari ini');
      } else if (errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('validation')) {
        throw Exception('Data tidak valid. Periksa kembali input Anda.');
      } else {
        throw Exception(errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  /// Check-out attendance
  static Future<AttendanceModel> checkOut({
    required AttendanceMethod method,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final body = <String, dynamic>{
        'method': method.value,
        if (additionalData != null) ...additionalData,
      };

      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/attendance/check-out',
        body: body,
      );

      return AttendanceModel.fromJson(
        response['attendance'] as Map<String, dynamic>,
      );
    } catch (e) {
      // Handle specific errors
      final errorMessage = e.toString();

      if (errorMessage.contains('not checked in')) {
        throw Exception('Anda belum melakukan check-in');
      } else if (errorMessage.contains('already checked out')) {
        throw Exception('Anda sudah melakukan check-out hari ini');
      } else if (errorMessage.contains('401')) {
        throw Exception('Sesi Anda telah berakhir. Silakan login kembali.');
      } else if (errorMessage.contains('validation')) {
        throw Exception('Data tidak valid. Periksa kembali input Anda.');
      } else {
        throw Exception(errorMessage.replaceAll('Exception: ', ''));
      }
    }
  }

  /// Get attendance history
  static Future<List<AttendanceModel>> getHistory({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Build query string
      final queryParts = <String>[];

      if (limit != null) queryParts.add('limit=$limit');
      if (startDate != null) {
        queryParts.add('start_date=${startDate.toIso8601String()}');
      }
      if (endDate != null) {
        queryParts.add('end_date=${endDate.toIso8601String()}');
      }

      final queryString = queryParts.isNotEmpty
          ? '?${queryParts.join('&')}'
          : '';
      final url = '${ApiUrl.baseUrl}/attendance/history$queryString';

      final response = await ApiService.get(url);

      final List<dynamic> attendances = response['attendances'] as List;
      return attendances
          .map((json) => AttendanceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
