/// Lecturer Dashboard Model - Represents dashboard data for lecturer
class LecturerDashboardModel {
  final int totalClasses;
  final int totalStudents;
  final int activeSessions;
  final AttendanceStatsModel? attendanceStats;

  LecturerDashboardModel({
    required this.totalClasses,
    required this.totalStudents,
    required this.activeSessions,
    this.attendanceStats,
  });

  factory LecturerDashboardModel.fromJson(Map<String, dynamic> json) {
    return LecturerDashboardModel(
      totalClasses: json['total_classes'] ?? json['totalClasses'] ?? 0,
      totalStudents: json['total_students'] ?? json['totalStudents'] ?? 0,
      activeSessions: json['active_sessions'] ?? json['activeSessions'] ?? 0,
      attendanceStats: json['attendance_stats'] != null
          ? AttendanceStatsModel.fromJson(json['attendance_stats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_classes': totalClasses,
      'total_students': totalStudents,
      'active_sessions': activeSessions,
      'attendance_stats': attendanceStats?.toJson(),
    };
  }
}

/// Attendance Statistics Model
class AttendanceStatsModel {
  final int present;
  final int late;
  final int absent;
  final int total;

  AttendanceStatsModel({
    required this.present,
    required this.late,
    required this.absent,
    required this.total,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsModel(
      present: json['present'] ?? 0,
      late: json['late'] ?? 0,
      absent: json['absent'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'present': present, 'late': late, 'absent': absent, 'total': total};
  }

  double get presentPercentage {
    if (total == 0) return 0.0;
    return (present / total) * 100;
  }

  double get latePercentage {
    if (total == 0) return 0.0;
    return (late / total) * 100;
  }

  double get absentPercentage {
    if (total == 0) return 0.0;
    return (absent / total) * 100;
  }
}

/// Lecturer Class Model - Extends basic class with lecturer-specific fields
class LecturerClassModel {
  final int id;
  final String name;
  final String code;
  final int studentCount;
  final bool hasActiveSession;
  final int? activeSessionId;
  final DateTime? createdAt;

  LecturerClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.studentCount,
    this.hasActiveSession = false,
    this.activeSessionId,
    this.createdAt,
  });

  factory LecturerClassModel.fromJson(Map<String, dynamic> json) {
    return LecturerClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      studentCount:
          json['students_count'] ??
          json['student_count'] ??
          json['studentCount'] ??
          0,
      hasActiveSession:
          json['has_active_session'] ?? json['hasActiveSession'] ?? false,
      activeSessionId: json['active_session_id'] ?? json['activeSessionId'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'student_count': studentCount,
      'has_active_session': hasActiveSession,
      'active_session_id': activeSessionId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get sessionStatusText =>
      hasActiveSession ? 'Sesi Aktif' : 'Tidak Aktif';
}

/// Attendance Session Response Model
class AttendanceSessionModel {
  final int id;
  final int classId;
  final String status;
  final DateTime? openedAt;
  final DateTime? closedAt;

  AttendanceSessionModel({
    required this.id,
    required this.classId,
    required this.status,
    this.openedAt,
    this.closedAt,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? json['classId'] ?? 0,
      status: json['status'] ?? 'closed',
      openedAt: json['opened_at'] != null
          ? DateTime.tryParse(json['opened_at'])
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'status': status,
      'opened_at': openedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active' || status == 'open';
}
