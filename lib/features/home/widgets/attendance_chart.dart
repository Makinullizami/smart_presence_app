import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_model.dart';

/// Attendance Chart Widget
/// Displays attendance statistics in a pie chart
class AttendanceChart extends StatelessWidget {
  final AttendanceStats stats;

  const AttendanceChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.purple.shade600, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Statistik Kehadiran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            if (stats.total > 0)
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _buildSections(),
                        ),
                      ),
                    ),

                    // Legend
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            'Hadir',
                            stats.present,
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            'Terlambat',
                            stats.late,
                            Colors.orange,
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            'Tidak Hadir',
                            stats.absent,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.insert_chart_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data kehadiran',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

            if (stats.total > 0) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Attendance Rate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tingkat Kehadiran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${stats.attendanceRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getAttendanceRateColor(stats.attendanceRate),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      PieChartSectionData(
        value: stats.present.toDouble(),
        color: Colors.green,
        title: '${stats.present}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: stats.late.toDouble(),
        color: Colors.orange,
        title: '${stats.late}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: stats.absent.toDouble(),
        color: Colors.red,
        title: '${stats.absent}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$value kali',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getAttendanceRateColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.orange;
    return Colors.red;
  }
}
