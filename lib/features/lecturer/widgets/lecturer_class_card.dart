import 'package:flutter/material.dart';
import '../models/lecturer_dashboard_model.dart';

/// Lecturer Class Card Widget - Displays class information for lecturer
class LecturerClassCard extends StatelessWidget {
  final LecturerClassModel classModel;
  final VoidCallback onTapDetail;
  final VoidCallback onTapSession;
  final VoidCallback? onDelete;

  const LecturerClassCard({
    super.key,
    required this.classModel,
    required this.onTapDetail,
    required this.onTapSession,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classModel.name,
                        style: TextStyle(
                          fontSize: isTablet ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 6.0 : 4.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12.0 : 10.0,
                          vertical: isTablet ? 6.0 : 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple.shade300),
                        ),
                        child: Text(
                          classModel.code,
                          style: TextStyle(
                            fontSize: isTablet ? 13.0 : 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 12.0 : 8.0),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade600,
                      size: isTablet ? 24.0 : 20.0,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Hapus Kelas',
                  ),
                SizedBox(width: isTablet ? 8.0 : 4.0),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 14.0 : 12.0,
                    vertical: isTablet ? 8.0 : 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: classModel.hasActiveSession
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: classModel.hasActiveSession
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        classModel.hasActiveSession
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: isTablet ? 16.0 : 14.0,
                        color: classModel.hasActiveSession
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                      SizedBox(width: isTablet ? 6.0 : 4.0),
                      Text(
                        classModel.sessionStatusText,
                        style: TextStyle(
                          fontSize: isTablet ? 13.0 : 12.0,
                          fontWeight: FontWeight.w600,
                          color: classModel.hasActiveSession
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16.0 : 12.0),

            // Student Count
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: isTablet ? 20.0 : 18.0,
                  color: Colors.blue.shade700,
                ),
                SizedBox(width: isTablet ? 10.0 : 8.0),
                Text(
                  '${classModel.studentCount} Mahasiswa',
                  style: TextStyle(
                    fontSize: isTablet ? 15.0 : 14.0,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 16.0 : 12.0),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTapDetail,
                    icon: Icon(
                      Icons.info_outline,
                      size: isTablet ? 18.0 : 16.0,
                    ),
                    label: Text(
                      'Detail',
                      style: TextStyle(fontSize: isTablet ? 14.0 : 13.0),
                    ),
                    style: OutlinedButton.styleFrom(
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
                  child: ElevatedButton.icon(
                    onPressed: onTapSession,
                    icon: Icon(
                      classModel.hasActiveSession
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_outline,
                      size: isTablet ? 18.0 : 16.0,
                    ),
                    label: Text(
                      classModel.hasActiveSession ? 'Tutup' : 'Buka',
                      style: TextStyle(fontSize: isTablet ? 14.0 : 13.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: classModel.hasActiveSession
                          ? Colors.red.shade600
                          : Colors.green.shade600,
                      foregroundColor: Colors.white,
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
      ),
    );
  }
}
