import 'package:flutter/material.dart';
import '../models/class_model.dart';

/// Class Schedule Section Widget - Displays class schedules
class ClassScheduleSection extends StatelessWidget {
  final List<ScheduleModel> schedules;

  const ClassScheduleSection({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (schedules.isEmpty) {
      return _buildEmptyState(isTablet);
    }

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
        children: schedules.asMap().entries.map((entry) {
          final index = entry.key;
          final schedule = entry.value;
          return Column(
            children: [
              if (index > 0)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 16.0 : 12.0,
                  ),
                  child: Divider(height: 1, color: Colors.grey.shade200),
                ),
              _buildScheduleItem(schedule, isTablet),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScheduleItem(ScheduleModel schedule, bool isTablet) {
    return Row(
      children: [
        // Day Icon
        Container(
          padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.calendar_today,
            color: Colors.blue.shade700,
            size: isTablet ? 22.0 : 20.0,
          ),
        ),
        SizedBox(width: isTablet ? 16.0 : 12.0),

        // Schedule Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.dayName,
                style: TextStyle(
                  fontSize: isTablet ? 17.0 : 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isTablet ? 6.0 : 4.0),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: isTablet ? 16.0 : 14.0,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: isTablet ? 6.0 : 4.0),
                  Text(
                    schedule.timeRange,
                    style: TextStyle(
                      fontSize: isTablet ? 15.0 : 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (schedule.room != null) ...[
                SizedBox(height: isTablet ? 6.0 : 4.0),
                Row(
                  children: [
                    Icon(
                      Icons.room,
                      size: isTablet ? 16.0 : 14.0,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: isTablet ? 6.0 : 4.0),
                    Text(
                      schedule.room!,
                      style: TextStyle(
                        fontSize: isTablet ? 15.0 : 14.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 40.0 : 32.0),
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
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: isTablet ? 64.0 : 56.0,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: isTablet ? 16.0 : 12.0),
            Text(
              'Belum ada jadwal',
              style: TextStyle(
                fontSize: isTablet ? 16.0 : 14.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
