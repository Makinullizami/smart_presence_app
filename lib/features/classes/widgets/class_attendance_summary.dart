import 'package:flutter/material.dart';
import '../models/class_model.dart';

/// Class Attendance Summary Widget - Displays attendance statistics
class ClassAttendanceSummary extends StatelessWidget {
  final AttendanceSummaryModel summary;

  const ClassAttendanceSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Attendance Percentage
          Container(
            padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.purple.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
            child: Column(
              children: [
                Text(
                  summary.attendancePercentageText,
                  style: TextStyle(
                    fontSize: isTablet ? 48.0 : 42.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isTablet ? 8.0 : 4.0),
                Text(
                  'Tingkat Kehadiran',
                  style: TextStyle(
                    fontSize: isTablet ? 16.0 : 14.0,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          // Statistics Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Hadir',
                  value: summary.present.toString(),
                  color: Colors.green,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  label: 'Terlambat',
                  value: summary.late.toString(),
                  color: Colors.orange,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cancel,
                  label: 'Tidak Hadir',
                  value: summary.absent.toString(),
                  color: Colors.red,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.event,
                  label: 'Total Sesi',
                  value: summary.totalSessions.toString(),
                  color: Colors.blue,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 32.0 : 28.0),
          SizedBox(height: isTablet ? 10.0 : 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 6.0 : 4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 13.0 : 12.0,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
