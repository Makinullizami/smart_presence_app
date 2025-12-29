/// Attendance Model
class AttendanceModel {
  final int? id;
  final int userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInMethod;
  final String? checkOutMethod;
  final AttendanceStatusEnum status;

  AttendanceModel({
    this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInMethod,
    this.checkOutMethod,
    required this.status,
    this.className,
    this.sessionName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      date: DateTime.parse(
        json['created_at'] as String,
      ), // Backend uses created_at
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'] as String)
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'] as String)
          : null,
      checkInMethod: json['method'] as String?,
      checkOutMethod: json['check_out_method'] as String?,
      status: _parseStatus(json['status'] as String?),
      className:
          json['class_session']?['class_room']?['name'] ??
          json['schedule']?['class_room']?['name'],
      sessionName: json['class_session'] != null
          ? 'Pertemuan ${json['class_session']['id']}' // Or use a topic field if available
          : null,
    );
  }

  final String? className;
  final String? sessionName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_in_method': checkInMethod,
      'check_out_method': checkOutMethod,
      'status': status.value,
    };
  }

  static AttendanceStatusEnum _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'checked_in':
        return AttendanceStatusEnum.checkedIn;
      case 'checked_out':
        return AttendanceStatusEnum.checkedOut;
      default:
        return AttendanceStatusEnum.notCheckedIn;
    }
  }

  String get checkInTimeFormatted {
    if (checkInTime == null) return '-';
    return '${checkInTime!.hour.toString().padLeft(2, '0')}:${checkInTime!.minute.toString().padLeft(2, '0')}';
  }

  String get checkOutTimeFormatted {
    if (checkOutTime == null) return '-';
    return '${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}';
  }

  String get statusDisplay {
    switch (status) {
      case AttendanceStatusEnum.notCheckedIn:
        return 'Belum Absen';
      case AttendanceStatusEnum.checkedIn:
        return 'Sudah Check-in';
      case AttendanceStatusEnum.checkedOut:
        return 'Sudah Check-out';
    }
  }

  bool get canCheckIn => status == AttendanceStatusEnum.notCheckedIn;
  bool get canCheckOut => status == AttendanceStatusEnum.checkedIn;
}

/// Attendance Status Enum
enum AttendanceStatusEnum {
  notCheckedIn('not_checked_in'),
  checkedIn('checked_in'),
  checkedOut('checked_out');

  final String value;
  const AttendanceStatusEnum(this.value);
}

/// Attendance Method Enum
enum AttendanceMethod {
  faceRecognition('face_recognition', 'Face Recognition', 'Gunakan wajah Anda'),
  pin('pin', 'PIN', 'Masukkan PIN'),
  qrCode('qr_code', 'QR Code', 'Scan QR Code'),
  manual('manual', 'Manual', 'Absensi Manual (Izin/Sakit)');

  final String value;
  final String title;
  final String subtitle;

  const AttendanceMethod(this.value, this.title, this.subtitle);
}
