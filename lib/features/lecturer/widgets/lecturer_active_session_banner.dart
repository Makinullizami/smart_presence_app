import 'package:flutter/material.dart';
import '../models/lecturer_dashboard_model.dart';

/// Lecturer Active Session Banner - Displays active attendance session info
class LecturerActiveSessionBanner extends StatelessWidget {
  final LecturerClassModel? activeClass;
  final VoidCallback onViewMonitor;
  final VoidCallback onCloseSession;

  const LecturerActiveSessionBanner({
    super.key,
    this.activeClass,
    required this.onViewMonitor,
    required this.onCloseSession,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (activeClass == null || !activeClass!.hasActiveSession) {
      return _buildNoActiveSession(isTablet);
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 32.0 : 20.0,
        vertical: isTablet ? 16.0 : 12.0,
      ),
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.teal.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 18 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.radio_button_checked,
                  color: Colors.white,
                  size: isTablet ? 28.0 : 24.0,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sesi Absensi Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 18.0 : 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 4.0 : 2.0),
                    Text(
                      activeClass!.name,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isTablet ? 15.0 : 14.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),

          // Class Info
          Container(
            padding: EdgeInsets.all(isTablet ? 14.0 : 12.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tag,
                  color: Colors.white,
                  size: isTablet ? 20.0 : 18.0,
                ),
                SizedBox(width: isTablet ? 10.0 : 8.0),
                Text(
                  activeClass!.code,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 15.0 : 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: isTablet ? 20.0 : 16.0),
                Icon(
                  Icons.people,
                  color: Colors.white,
                  size: isTablet ? 20.0 : 18.0,
                ),
                SizedBox(width: isTablet ? 10.0 : 8.0),
                Text(
                  '${activeClass!.studentCount} Mahasiswa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 15.0 : 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onViewMonitor,
                  icon: Icon(Icons.monitor, size: isTablet ? 20.0 : 18.0),
                  label: Text(
                    'Monitor',
                    style: TextStyle(fontSize: isTablet ? 15.0 : 14.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 14.0 : 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 12.0 : 8.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCloseSession,
                  icon: Icon(Icons.stop_circle, size: isTablet ? 20.0 : 18.0),
                  label: Text(
                    'Tutup Sesi',
                    style: TextStyle(fontSize: isTablet ? 15.0 : 14.0),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 14.0 : 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveSession(bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 32.0 : 20.0,
        vertical: isTablet ? 16.0 : 12.0,
      ),
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(isTablet ? 18 : 16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey.shade600,
            size: isTablet ? 28.0 : 24.0,
          ),
          SizedBox(width: isTablet ? 16.0 : 12.0),
          Expanded(
            child: Text(
              'Tidak ada sesi absensi aktif',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: isTablet ? 16.0 : 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
