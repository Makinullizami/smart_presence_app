class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // attendance, material, info
  final String time;
  final bool isRead;
  final int? classId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
    this.classId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      time: json['time'] ?? '',
      isRead: json['is_read'] ?? false,
      classId: json['class_id'],
    );
  }
}
