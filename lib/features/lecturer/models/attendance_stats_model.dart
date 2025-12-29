/// Attendance Statistics Model
/// Contains attendance statistics for a session
class AttendanceStatsModel {
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int totalStudents;

  AttendanceStatsModel({
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.totalStudents,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsModel(
      presentCount: json['present_count'] ?? 0,
      lateCount: json['late_count'] ?? 0,
      absentCount: json['absent_count'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
    );
  }

  int get attendedCount => presentCount + lateCount;

  double get attendanceRate {
    if (totalStudents == 0) return 0.0;
    return (attendedCount / totalStudents) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'present_count': presentCount,
      'late_count': lateCount,
      'absent_count': absentCount,
      'total_students': totalStudents,
    };
  }
}
