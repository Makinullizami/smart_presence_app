/// Helper to safely parse integers
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

/// Dashboard Model
/// Contains all data needed for the home dashboard
class DashboardModel {
  final UserInfo user;
  final TodayAttendance? todayAttendance;
  final ClassSummary classSummary;
  final List<NotificationItem> notifications;
  final AttendanceStats stats;

  DashboardModel({
    required this.user,
    this.todayAttendance,
    required this.classSummary,
    required this.notifications,
    required this.stats,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      user: UserInfo.fromJson(json['user'] ?? {}),
      todayAttendance: json['today_attendance'] != null
          ? TodayAttendance.fromJson(json['today_attendance'])
          : null,
      classSummary: ClassSummary.fromJson(json['class_summary'] ?? {}),
      notifications:
          (json['notifications'] as List?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList() ??
          [],
      stats: AttendanceStats.fromJson(json['stats'] ?? {}),
    );
  }
}

/// User Information
class UserInfo {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatar;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: _parseInt(json['id']),
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      avatar: json['avatar'],
    );
  }

  String get roleDisplay {
    switch (role.toLowerCase()) {
      case 'student':
        return 'Mahasiswa';
      case 'lecturer':
        return 'Dosen';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }
}

/// Today's Attendance Status
class TodayAttendance {
  final String status; // present, late, absent, pending
  final String? checkInTime;
  final String date;

  TodayAttendance({required this.status, this.checkInTime, required this.date});

  factory TodayAttendance.fromJson(Map<String, dynamic> json) {
    return TodayAttendance(
      status: json['status'] ?? 'pending',
      checkInTime: json['check_in_time'],
      date: json['date'] ?? '',
    );
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'present':
        return 'Hadir';
      case 'late':
        return 'Terlambat';
      case 'absent':
        return 'Tidak Hadir';
      default:
        return 'Belum Absen';
    }
  }
}

/// Class Summary
class ClassSummary {
  final int totalClasses;
  final int todayClasses;
  final List<String> lecturers;

  ClassSummary({
    required this.totalClasses,
    required this.todayClasses,
    required this.lecturers,
  });

  factory ClassSummary.fromJson(Map<String, dynamic> json) {
    return ClassSummary(
      totalClasses: _parseInt(json['total_classes']),
      todayClasses: _parseInt(json['today_classes']),
      lecturers: (json['lecturers'] as List?)?.cast<String>() ?? [],
    );
  }
}

/// Notification Item
class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: _parseInt(json['id']),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }
}

/// Attendance Statistics
class AttendanceStats {
  final int present;
  final int late;
  final int absent; // alpha
  final int permission;
  final int sick;
  final double attendanceRate;

  AttendanceStats({
    required this.present,
    required this.late,
    required this.absent,
    required this.permission,
    required this.sick,
    required this.attendanceRate,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    int parse(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return AttendanceStats(
      present: parse(json['present']),
      late: parse(json['late']),
      absent: parse(json['absent']),
      permission: parse(json['permission']),
      sick: parse(json['sick']),
      attendanceRate: (json['attendance_rate'] is num)
          ? (json['attendance_rate'] as num).toDouble()
          : 0.0,
    );
  }

  int get total => present + late + absent + permission + sick;
}
