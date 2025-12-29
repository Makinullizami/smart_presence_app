import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';
import '../models/report_model.dart';
// import 'dart:io';
// For PDF download later

class LecturerReportService {
  static Future<ReportSummaryModel> getSummary() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/reports/summary',
      );
      return ReportSummaryModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal memuat ringkasan laporan: $e');
    }
  }

  static Future<ClassReportModel> getClassReport(int classId) async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/reports/class/$classId',
      );
      return ClassReportModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal memuat laporan kelas: $e');
    }
  }

  static Future<void> exportReport() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/lecturer/reports/export',
      );
      // For now just logging or simple handling as the backend returns a message
      // In real implementation we would handle file download here.
      print(response['message']);
    } catch (e) {
      throw Exception('Gagal export laporan: $e');
    }
  }
}
