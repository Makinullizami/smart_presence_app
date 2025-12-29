import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_model.dart';

/// Attendance Status Card - Display current attendance status
class AttendanceStatusCard extends StatelessWidget {
  final AttendanceModel? attendance;

  const AttendanceStatusCard({super.key, this.attendance});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Container(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white70,
                size: isTablet ? 18.0 : 16.0,
              ),
              SizedBox(width: isTablet ? 10.0 : 8.0),
              Expanded(
                child: Text(
                  dateFormat.format(now),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isTablet ? 16.0 : 14.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          // Class Info (Added)
          if (attendance?.className != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendance!.className!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18.0 : 16.0,
                    ),
                  ),
                  if (attendance!.sessionName != null)
                    Text(
                      attendance!.sessionName!,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isTablet ? 14.0 : 12.0,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16.0 : 12.0),
          ],

          // Status
          Text(
            attendance?.statusDisplay ?? 'Belum Absen',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 32.0 : 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          // Check-in & Check-out times
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo(
                  icon: Icons.login,
                  label: 'Check-in',
                  time: attendance?.checkInTimeFormatted ?? '-',
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              Expanded(
                child: _buildTimeInfo(
                  icon: Icons.logout,
                  label: 'Check-out',
                  time: attendance?.checkOutTimeFormatted ?? '-',
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: isTablet ? 18.0 : 16.0),
              SizedBox(width: isTablet ? 8.0 : 6.0),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isTablet ? 14.0 : 12.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8.0 : 6.0),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 22.0 : 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
