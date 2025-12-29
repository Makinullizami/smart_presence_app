/// Attendance Session Model
/// Contains session information and statistics
class AttendanceSessionModel {
  final int id;
  final int classId;
  final String className;
  final String classCode;
  final String startTime;
  final String? endTime;
  final bool isActive;
  final int totalStudents;

  AttendanceSessionModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.classCode,
    required this.startTime,
    this.endTime,
    required this.isActive,
    required this.totalStudents,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      className: json['class_name'] ?? '',
      classCode: json['class_code'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'],
      isActive: json['is_active'] ?? false,
      totalStudents: json['total_students'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'class_name': className,
      'class_code': classCode,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'total_students': totalStudents,
    };
  }
}
