/// Student Attendance Model
/// Contains student attendance information
class StudentAttendanceModel {
  final int id;
  final int studentId;
  final String name;
  final String nim;
  final String status; // present, late, absent
  final String? checkInTime;
  final String? method; // face, qr, pin
  final String? photoUrl;
  final bool isNew; // for highlight animation

  StudentAttendanceModel({
    required this.id,
    required this.studentId,
    required this.name,
    required this.nim,
    required this.status,
    this.checkInTime,
    this.method,
    this.photoUrl,
    this.isNew = false,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      nim: json['nim'] ?? '',
      status: json['status'] ?? 'absent',
      checkInTime: json['check_in_time'],
      method: json['method'],
      photoUrl: json['photo_url'],
      isNew: json['is_new'] ?? false,
    );
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'present':
        return 'Hadir';
      case 'late':
        return 'Terlambat';
      case 'absent':
        return 'Belum Hadir';
      default:
        return status;
    }
  }

  String get methodIcon {
    switch (method?.toLowerCase()) {
      case 'face':
        return 'face';
      case 'qr':
        return 'qr_code_2';
      case 'pin':
        return 'pin';
      default:
        return 'help';
    }
  }

  String get timeDisplay {
    if (checkInTime == null || checkInTime!.isEmpty) {
      return '--:--';
    }
    // Format time from "2024-01-01 08:00:00" to "08:00"
    try {
      final time = DateTime.parse(checkInTime!);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return checkInTime!;
    }
  }

  StudentAttendanceModel copyWith({
    int? id,
    int? studentId,
    String? name,
    String? nim,
    String? status,
    String? checkInTime,
    String? method,
    String? photoUrl,
    bool? isNew,
  }) {
    return StudentAttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      nim: nim ?? this.nim,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      method: method ?? this.method,
      photoUrl: photoUrl ?? this.photoUrl,
      isNew: isNew ?? this.isNew,
    );
  }
}
