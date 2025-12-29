import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';

/// Student Class Model
class StudentClassModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final String teacherName;
  final int? activeSessionId;
  final bool hasActiveSession;
  final int studentCount;

  StudentClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.teacherName,
    this.activeSessionId,
    required this.hasActiveSession,
    this.studentCount = 0,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'],
      teacherName: json['teacher_name'] ?? 'Unknown',
      activeSessionId: json['active_session_id'],
      hasActiveSession: json['has_active_session'] ?? false,
      studentCount: json['students_count'] ?? 0,
    );
  }
}

/// Student Class Service
class StudentClassService {
  /// Join a class using class code
  static Future<StudentClassModel> joinClass(String code) async {
    try {
      final response = await ApiService.post(
        '${ApiUrl.baseUrl}/student/classes/join',
        body: {'code': code},
      );

      return StudentClassModel.fromJson(response['data']);
    } catch (e) {
      throw Exception('Gagal bergabung ke kelas: ${e.toString()}');
    }
  }

  /// Get all classes that student has joined
  static Future<List<StudentClassModel>> getClasses() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/student/classes',
      );

      final classList =
          (response['data'] as List?)?.map((classData) {
            return StudentClassModel.fromJson(classData);
          }).toList() ??
          [];

      return classList;
    } catch (e) {
      throw Exception('Gagal memuat daftar kelas: ${e.toString()}');
    }
  }
}
