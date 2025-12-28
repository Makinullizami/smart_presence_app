/// Class Model - Represents a class in the system
class ClassModel {
  final int id;
  final String name;
  final String code;
  final String lecturerName;
  final List<ScheduleModel> schedules;
  final bool isActive;
  final DateTime? createdAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.code,
    required this.lecturerName,
    required this.schedules,
    this.isActive = true,
    this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      lecturerName: json['lecturer_name'] ?? json['lecturerName'] ?? '',
      schedules:
          (json['schedules'] as List<dynamic>?)
              ?.map((schedule) => ScheduleModel.fromJson(schedule))
              .toList() ??
          [],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
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
      'lecturer_name': lecturerName,
      'schedules': schedules.map((s) => s.toJson()).toList(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get schedulePreview {
    if (schedules.isEmpty) return 'Belum ada jadwal';
    final first = schedules.first;
    return '${first.dayName}, ${first.startTime} - ${first.endTime}';
  }

  String get statusText => isActive ? 'Aktif' : 'Tidak Aktif';
}

/// Schedule Model - Represents a class schedule
class ScheduleModel {
  final int id;
  final int classId;
  final String day; // 'monday', 'tuesday', etc.
  final String startTime; // '08:00'
  final String endTime; // '10:00'
  final String? room;

  ScheduleModel({
    required this.id,
    required this.classId,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.room,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? json['classId'] ?? 0,
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? json['startTime'] ?? '',
      endTime: json['end_time'] ?? json['endTime'] ?? '',
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
    };
  }

  String get dayName {
    switch (day.toLowerCase()) {
      case 'monday':
        return 'Senin';
      case 'tuesday':
        return 'Selasa';
      case 'wednesday':
        return 'Rabu';
      case 'thursday':
        return 'Kamis';
      case 'friday':
        return 'Jumat';
      case 'saturday':
        return 'Sabtu';
      case 'sunday':
        return 'Minggu';
      default:
        return day;
    }
  }

  String get timeRange => '$startTime - $endTime';
}

/// Attendance Summary Model - Represents attendance statistics for a class
class AttendanceSummaryModel {
  final int present;
  final int late;
  final int absent;
  final int totalSessions;

  AttendanceSummaryModel({
    required this.present,
    required this.late,
    required this.absent,
    required this.totalSessions,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      present: json['present'] ?? 0,
      late: json['late'] ?? 0,
      absent: json['absent'] ?? 0,
      totalSessions: json['total_sessions'] ?? json['totalSessions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'late': late,
      'absent': absent,
      'total_sessions': totalSessions,
    };
  }

  double get attendancePercentage {
    if (totalSessions == 0) return 0.0;
    return (present / totalSessions) * 100;
  }

  String get attendancePercentageText {
    return '${attendancePercentage.toStringAsFixed(1)}%';
  }
}
