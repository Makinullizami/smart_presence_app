import 'package:flutter/material.dart';
import '../models/class_model.dart';

/// Class Info Section Widget - Displays class information
class ClassInfoSection extends StatelessWidget {
  final ClassModel classModel;

  const ClassInfoSection({super.key, required this.classModel});

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
          _buildInfoRow(
            icon: Icons.person,
            label: 'Dosen Pengampu',
            value: classModel.lecturerName,
            iconColor: Colors.blue,
            isTablet: isTablet,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 12.0),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          _buildInfoRow(
            icon: Icons.tag,
            label: 'Kode Kelas',
            value: classModel.code,
            iconColor: Colors.purple,
            isTablet: isTablet,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isTablet ? 16.0 : 12.0),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: classModel.statusText,
            iconColor: classModel.isActive ? Colors.green : Colors.grey,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: isTablet ? 22.0 : 20.0),
        ),
        SizedBox(width: isTablet ? 16.0 : 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 14.0 : 13.0,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: isTablet ? 6.0 : 4.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 17.0 : 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
