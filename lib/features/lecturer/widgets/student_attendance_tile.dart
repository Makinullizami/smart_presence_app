import 'package:flutter/material.dart';
import '../models/student_attendance_model.dart';

/// Student Attendance Tile
/// Shows student info with status and attendance details
class StudentAttendanceTile extends StatelessWidget {
  final StudentAttendanceModel student;

  const StudentAttendanceTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final isAbsent = student.status == 'absent';
    final isNew = student.isNew;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew
            ? Colors.blue.shade50.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNew ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isAbsent
                    ? Colors.grey.shade200
                    : Colors.blue.shade100,
                child: isAbsent
                    ? Icon(
                        Icons.person_outline,
                        color: Colors.grey.shade400,
                        size: 24,
                      )
                    : Text(
                        student.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
              ),
              // Status indicator
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(student.status),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  student.nim,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // Status and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(student.status),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  student.statusDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusTextColor(student.status),
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Time and Method
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isNew ? 'Baru saja' : student.timeDisplay,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _getMethodIcon(student.methodIcon),
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.shade500;
      case 'late':
        return Colors.amber.shade500;
      case 'absent':
        return Colors.red.shade500;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.shade100;
      case 'late':
        return Colors.amber.shade100;
      case 'absent':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green.shade800;
      case 'late':
        return Colors.amber.shade800;
      case 'absent':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  IconData _getMethodIcon(String method) {
    switch (method) {
      case 'face':
        return Icons.face;
      case 'qr_code_2':
        return Icons.qr_code_2;
      case 'pin':
        return Icons.pin;
      default:
        return Icons.help_outline;
    }
  }
}
