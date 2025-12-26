import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

/// Class Summary Card Widget
/// Shows total classes and today's classes
class ClassSummaryCard extends StatelessWidget {
  final ClassSummary summary;
  final VoidCallback? onTap;

  const ClassSummaryCard({super.key, required this.summary, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.school_outlined,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ringkasan Kelas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  // Total Classes
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.class_outlined,
                      label: 'Total Kelas',
                      value: summary.totalClasses.toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Today's Classes
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.today_outlined,
                      label: 'Kelas Hari Ini',
                      value: summary.todayClasses.toString(),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              if (summary.lecturers.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Dosen Pengampu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: summary.lecturers.take(3).map((lecturer) {
                    return Chip(
                      label: Text(
                        lecturer,
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: Colors.blue.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
