// Report Summary Models

class ReportSummaryModel {
  final int totalClasses;
  final int totalSessions;
  final double attendanceRate;
  final StatusDistribution distribution;

  ReportSummaryModel({
    required this.totalClasses,
    required this.totalSessions,
    required this.attendanceRate,
    required this.distribution,
  });

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReportSummaryModel(
      totalClasses: json['total_classes'] ?? 0,
      totalSessions: json['total_sessions'] ?? 0,
      attendanceRate: (json['attendance_rate'] ?? 0).toDouble(),
      distribution: StatusDistribution.fromJson(json['distribution'] ?? {}),
    );
  }
}

class StatusDistribution {
  final int present;
  final int sick;
  final int permission;
  final int alpha;

  StatusDistribution({
    required this.present,
    required this.sick,
    required this.permission,
    required this.alpha,
  });

  factory StatusDistribution.fromJson(Map<String, dynamic> json) {
    return StatusDistribution(
      present: json['present'] ?? 0,
      sick: json['sick'] ?? 0,
      permission: json['permission'] ?? 0,
      alpha: json['alpha'] ?? 0,
    );
  }
}

// Detailed Class Report Models

class ClassReportModel {
  final int classId;
  final String className;
  final String classCode;
  final List<SessionReportModel> sessions;
  final List<StudentRiskModel> students;

  ClassReportModel({
    required this.classId,
    required this.className,
    required this.classCode,
    required this.sessions,
    required this.students,
  });

  factory ClassReportModel.fromJson(Map<String, dynamic> json) {
    return ClassReportModel(
      classId: json['class_info']['id'] ?? 0,
      className: json['class_info']['name'] ?? '',
      classCode: json['class_info']['code'] ?? '',
      sessions:
          (json['sessions'] as List?)
              ?.map((e) => SessionReportModel.fromJson(e))
              .toList() ??
          [],
      students:
          (json['students'] as List?)
              ?.map((e) => StudentRiskModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SessionReportModel {
  final int id;
  final String date;
  final int presentCount;
  final int absentCount;

  SessionReportModel({
    required this.id,
    required this.date,
    required this.presentCount,
    required this.absentCount,
  });

  factory SessionReportModel.fromJson(Map<String, dynamic> json) {
    return SessionReportModel(
      id: json['id'] ?? 0,
      date: json['created_at'] ?? '',
      presentCount: json['present_count'] ?? 0,
      absentCount: json['absent_count'] ?? 0,
    );
  }
}

class StudentRiskModel {
  final int id;
  final String name;
  final int absentCount;
  final bool isAtRisk;

  StudentRiskModel({
    required this.id,
    required this.name,
    required this.absentCount,
    required this.isAtRisk,
  });

  factory StudentRiskModel.fromJson(Map<String, dynamic> json) {
    return StudentRiskModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      absentCount: json['absent_count'] ?? 0,
      isAtRisk: json['is_at_risk'] ?? false,
    );
  }
}
