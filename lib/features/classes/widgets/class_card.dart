import 'package:flutter/material.dart';
import '../models/class_model.dart';

/// Class Card Widget - Displays class information in a card
class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final VoidCallback onTap;

  const ClassCard({super.key, required this.classModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      classModel.name,
                      style: TextStyle(
                        fontSize: isTablet ? 18.0 : 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12.0 : 8.0),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12.0 : 10.0,
                      vertical: isTablet ? 6.0 : 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: classModel.isActive
                          ? Colors.green.shade50
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: classModel.isActive
                            ? Colors.green.shade300
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      classModel.statusText,
                      style: TextStyle(
                        fontSize: isTablet ? 12.0 : 11.0,
                        fontWeight: FontWeight.w600,
                        color: classModel.isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16.0 : 12.0),

              // Lecturer
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: isTablet ? 18.0 : 16.0,
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(width: isTablet ? 10.0 : 8.0),
                  Expanded(
                    child: Text(
                      classModel.lecturerName,
                      style: TextStyle(
                        fontSize: isTablet ? 15.0 : 14.0,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 10.0 : 8.0),

              // Class Code
              Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: isTablet ? 18.0 : 16.0,
                    color: Colors.purple.shade700,
                  ),
                  SizedBox(width: isTablet ? 10.0 : 8.0),
                  Text(
                    classModel.code,
                    style: TextStyle(
                      fontSize: isTablet ? 15.0 : 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 10.0 : 8.0),

              // Schedule Preview
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: isTablet ? 18.0 : 16.0,
                    color: Colors.orange.shade700,
                  ),
                  SizedBox(width: isTablet ? 10.0 : 8.0),
                  Expanded(
                    child: Text(
                      classModel.schedulePreview,
                      style: TextStyle(
                        fontSize: isTablet ? 14.0 : 13.0,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
