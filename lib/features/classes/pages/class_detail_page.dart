import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/class_controller.dart';
import '../widgets/class_info_section.dart';
import '../widgets/class_schedule_section.dart';
import '../widgets/class_attendance_summary.dart';

/// Class Detail Page - Displays detailed information about a class
class ClassDetailPage extends StatefulWidget {
  final int classId;

  const ClassDetailPage({super.key, required this.classId});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  late ClassController _classController;
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _classController = ClassController();
    _profileController = ProfileController();
    _loadData();
  }

  Future<void> _loadData() async {
    await _profileController.loadProfile();
    await _classController.loadClassDetail(widget.classId);
    await _classController.loadSchedules(widget.classId);

    if (_profileController.user != null) {
      await _classController.loadAttendanceSummary(
        widget.classId,
        _profileController.user!.id,
      );
    }
  }

  @override
  void dispose() {
    _classController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _classController),
        ChangeNotifierProvider.value(value: _profileController),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Consumer<ClassController>(
          builder: (context, controller, _) {
            if (controller.state == ClassState.loading ||
                controller.selectedClass == null) {
              return _buildLoading();
            }

            if (controller.state == ClassState.error) {
              return _buildError(controller, isTablet);
            }

            final classModel = controller.selectedClass!;

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: isTablet ? 200.0 : 160.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      classModel.name,
                      style: TextStyle(
                        fontSize: isTablet ? 20.0 : 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade700,
                            Colors.purple.shade500,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverPadding(
                  padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Class Info Section
                      _buildSectionTitle('Informasi Kelas', isTablet),
                      SizedBox(height: isTablet ? 16.0 : 12.0),
                      ClassInfoSection(classModel: classModel),
                      SizedBox(height: isTablet ? 32.0 : 24.0),

                      // Schedule Section
                      _buildSectionTitle('Jadwal Kelas', isTablet),
                      SizedBox(height: isTablet ? 16.0 : 12.0),
                      ClassScheduleSection(schedules: controller.schedules),
                      SizedBox(height: isTablet ? 32.0 : 24.0),

                      // Attendance Summary Section
                      if (controller.attendanceSummary != null) ...[
                        _buildSectionTitle('Ringkasan Kehadiran', isTablet),
                        SizedBox(height: isTablet ? 16.0 : 12.0),
                        ClassAttendanceSummary(
                          summary: controller.attendanceSummary!,
                        ),
                        SizedBox(height: isTablet ? 32.0 : 24.0),

                        // View History Button
                        SizedBox(
                          width: double.infinity,
                          height: isTablet ? 56.0 : 50.0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/attendance/history',
                                arguments: {'classId': widget.classId},
                              );
                            },
                            icon: Icon(
                              Icons.history,
                              size: isTablet ? 22.0 : 20.0,
                            ),
                            label: Text(
                              'Lihat Riwayat Absensi',
                              style: TextStyle(
                                fontSize: isTablet ? 16.0 : 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: isTablet ? 32.0 : 24.0),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isTablet ? 20.0 : 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ClassController controller, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 80.0 : 64.0,
              color: Colors.red.shade300,
            ),
            SizedBox(height: isTablet ? 24.0 : 16.0),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: isTablet ? 22.0 : 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isTablet ? 12.0 : 8.0),
            Text(
              controller.errorMessage ?? 'Gagal memuat detail kelas',
              style: TextStyle(
                fontSize: isTablet ? 16.0 : 14.0,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 32.0 : 24.0),
            ElevatedButton.icon(
              onPressed: () => _loadData(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.0 : 24.0,
                  vertical: isTablet ? 16.0 : 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
