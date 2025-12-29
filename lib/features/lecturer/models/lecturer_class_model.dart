/// Lecturer Class Model
/// Contains class information for lecturer
class LecturerClassModel {
  final int id;
  final String name;
  final String code;
  final String? programStudi;
  final String? semester;
  final int studentCount;
  final int? activeSessionId;
  final bool hasActiveSession;

  LecturerClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.programStudi,
    this.semester,
    required this.studentCount,
    this.activeSessionId,
    required this.hasActiveSession,
  });

  factory LecturerClassModel.fromJson(Map<String, dynamic> json) {
    return LecturerClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      programStudi: json['program_studi'],
      semester: json['semester'],
      studentCount: json['student_count'] ?? 0,
      activeSessionId: json['active_session_id'],
      hasActiveSession: json['has_active_session'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'program_studi': programStudi,
      'semester': semester,
      'student_count': studentCount,
      'active_session_id': activeSessionId,
      'has_active_session': hasActiveSession,
    };
  }
}
