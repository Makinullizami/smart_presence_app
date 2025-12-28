import 'package:flutter/material.dart';
import '../models/lecturer_dashboard_model.dart';

/// Lecturer Attendance Chart Widget - Displays attendance statistics
class LecturerAttendanceChart extends StatelessWidget {
  final AttendanceStatsModel stats;

  const LecturerAttendanceChart({super.key, required this.stats});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Kehadiran',
            style: TextStyle(
              fontSize: isTablet ? 18.0 : 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: isTablet ? 20.0 : 16.0),

          // Bar Chart Visualization
          _buildBarChart(isTablet),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          // Statistics Grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'Hadir',
                  value: stats.present.toString(),
                  percentage: stats.presentPercentage,
                  color: Colors.green,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.access_time,
                  label: 'Terlambat',
                  value: stats.late.toString(),
                  percentage: stats.latePercentage,
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
                child: _buildStatItem(
                  icon: Icons.cancel,
                  label: 'Tidak Hadir',
                  value: stats.absent.toString(),
                  percentage: stats.absentPercentage,
                  color: Colors.red,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people,
                  label: 'Total',
                  value: stats.total.toString(),
                  percentage: 100.0,
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

  Widget _buildBarChart(bool isTablet) {
    final total = stats.total > 0 ? stats.total : 1;
    final presentWidth = (stats.present / total);
    final lateWidth = (stats.late / total);
    final absentWidth = (stats.absent / total);

    return Column(
      children: [
        Row(
          children: [
            if (stats.present > 0)
              Expanded(
                flex: (presentWidth * 100).toInt(),
                child: Container(
                  height: isTablet ? 40.0 : 32.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(8),
                      right: stats.late == 0 && stats.absent == 0
                          ? const Radius.circular(8)
                          : Radius.zero,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stats.presentPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 14.0 : 12.0,
                    ),
                  ),
                ),
              ),
            if (stats.late > 0)
              Expanded(
                flex: (lateWidth * 100).toInt(),
                child: Container(
                  height: isTablet ? 40.0 : 32.0,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.horizontal(
                      left: stats.present == 0
                          ? const Radius.circular(8)
                          : Radius.zero,
                      right: stats.absent == 0
                          ? const Radius.circular(8)
                          : Radius.zero,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stats.latePercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 14.0 : 12.0,
                    ),
                  ),
                ),
              ),
            if (stats.absent > 0)
              Expanded(
                flex: (absentWidth * 100).toInt(),
                child: Container(
                  height: isTablet ? 40.0 : 32.0,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stats.absentPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 14.0 : 12.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required double percentage,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14.0 : 12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 28.0 : 24.0),
          SizedBox(height: isTablet ? 8.0 : 6.0),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 20.0 : 18.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 4.0 : 2.0),
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
