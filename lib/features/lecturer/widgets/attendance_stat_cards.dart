import 'package:flutter/material.dart';
import '../models/attendance_stats_model.dart';

/// Attendance Statistics Cards
/// Shows 3 cards: Present, Late, Absent
class AttendanceStatCards extends StatelessWidget {
  final AttendanceStatsModel stats;

  const AttendanceStatCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Hadir',
              stats.presentCount.toString(),
              Colors.green.shade600,
              Colors.green.shade50,
              Colors.green.shade100,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Terlambat',
              stats.lateCount.toString(),
              Colors.amber.shade600,
              Colors.amber.shade50,
              Colors.amber.shade100,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Belum',
              stats.absentCount.toString(),
              Colors.red.shade600,
              Colors.red.shade50,
              Colors.red.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color textColor,
    Color bgColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
