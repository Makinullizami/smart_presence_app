import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_controller.dart';
import '../models/attendance_model.dart';
import '../widgets/attendance_status_card.dart';
import '../widgets/attendance_method_card.dart';

/// Attendance Page - Main attendance screen
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late AttendanceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AttendanceController()..loadTodayAttendance();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = screenWidth > 900 ? 4 : (isTablet ? 3 : 3);

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: Text(
            'Absensi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 22.0 : 20.0,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey.shade800,
        ),
        body: Consumer<AttendanceController>(
          builder: (context, controller, _) {
            if (controller.state == AttendanceState.initial ||
                controller.state == AttendanceState.loading) {
              return _buildLoading();
            }

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Card
                    AttendanceStatusCard(attendance: controller.attendance),
                    SizedBox(height: isTablet ? 40.0 : 32.0),

                    // Section Title
                    Text(
                      'Pilih Metode Absensi',
                      style: TextStyle(
                        fontSize: isTablet ? 20.0 : 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: isTablet ? 20.0 : 16.0),

                    // Method Cards - Responsive Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: isTablet ? 16.0 : 12.0,
                          crossAxisSpacing: isTablet ? 16.0 : 12.0,
                          childAspectRatio: isTablet ? 0.9 : 0.85,
                          children: [
                            AttendanceMethodCard(
                              method: AttendanceMethod.faceRecognition,
                              isSelected:
                                  controller.selectedMethod ==
                                  AttendanceMethod.faceRecognition,
                              enabled: !controller.isCompleted,
                              onTap: () {
                                if (!controller.isCompleted) {
                                  Navigator.pushNamed(
                                    context,
                                    '/attendance/face',
                                  );
                                }
                              },
                            ),
                            AttendanceMethodCard(
                              method: AttendanceMethod.pin,
                              isSelected:
                                  controller.selectedMethod ==
                                  AttendanceMethod.pin,
                              enabled: !controller.isCompleted,
                              onTap: () {
                                if (!controller.isCompleted) {
                                  Navigator.pushNamed(
                                    context,
                                    '/attendance/pin',
                                  );
                                }
                              },
                            ),
                            AttendanceMethodCard(
                              method: AttendanceMethod.qrCode,
                              isSelected:
                                  controller.selectedMethod ==
                                  AttendanceMethod.qrCode,
                              enabled: !controller.isCompleted,
                              onTap: () {
                                if (!controller.isCompleted) {
                                  Navigator.pushNamed(
                                    context,
                                    '/attendance/qr',
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: isTablet ? 40.0 : 32.0),

                    // History Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/attendance/history'),
                        icon: Icon(Icons.history, size: isTablet ? 22.0 : 20.0),
                        label: Text(
                          'Lihat Riwayat Absensi',
                          style: TextStyle(fontSize: isTablet ? 16.0 : 14.0),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 32.0 : 24.0,
                            vertical: isTablet ? 20.0 : 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 28.0 : 20.0),

                    // Info Text
                    if (!controller.isCompleted)
                      Center(
                        child: Text(
                          'Pilih metode absensi di atas',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isTablet ? 16.0 : 14.0,
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20.0 : 16.0,
                            vertical: isTablet ? 12.0 : 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade700,
                                size: isTablet ? 24.0 : 20.0,
                              ),
                              SizedBox(width: isTablet ? 12.0 : 8.0),
                              Text(
                                'Absensi hari ini sudah selesai',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: isTablet ? 16.0 : 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }
}
