import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/lecturer_home_controller.dart';
import '../models/lecturer_dashboard_model.dart';
import '../widgets/lecturer_class_card.dart';
import '../services/lecturer_class_service.dart';

/// Modern Lecturer Home Page - Redesigned Dashboard
class LecturerHomePage extends StatefulWidget {
  const LecturerHomePage({super.key});

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> {
  late LecturerHomeController _controller;
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _controller = LecturerHomeController();
    _profileController = ProfileController();
    _loadData();
  }

  Future<void> _loadData() async {
    await _profileController.loadProfile();
    await _controller.loadAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _controller),
        ChangeNotifierProvider.value(value: _profileController),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Consumer2<LecturerHomeController, ProfileController>(
          builder: (context, controller, profileController, _) {
            if (controller.state == LecturerHomeState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.state == LecturerHomeState.error) {
              return _buildError(controller);
            }

            final dashboard = controller.dashboard;
            final user = profileController.user;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Modern App Bar
                  _buildAppBar(),

                  // Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Profile Header
                        _buildProfileHeader(user?.name ?? 'Dosen'),

                        const SizedBox(height: 24),

                        // Active Session / Progress Card
                        _buildActiveSessionCard(controller),

                        const SizedBox(height: 24),

                        // Quick Access Grid
                        _buildQuickAccess(),

                        const SizedBox(height: 24),

                        // My Classes Section
                        _buildClassesSection(controller),

                        const SizedBox(height: 24),

                        // Statistics Card
                        if (dashboard?.attendanceStats != null)
                          _buildStatisticsCard(dashboard!.attendanceStats!),

                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: const Color(0xFFF8F9FA),
      automaticallyImplyLeading: false,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Color(0xFF64748B)),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade700, width: 2),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
            ),
            child: const Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),

          // Name and greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(LecturerHomeController controller) {
    final activeClass = controller.classes.firstWhere(
      (c) => c.hasActiveSession,
      orElse: () =>
          LecturerClassModel(id: 0, name: '', code: '', studentCount: 0),
    );

    final hasActiveSession = activeClass.id > 0 && activeClass.hasActiveSession;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasActiveSession
              ? [Colors.green.shade600, Colors.teal.shade500]
              : [Colors.blue.shade700, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (hasActiveSession ? Colors.green : Colors.blue).withValues(
              alpha: 0.3,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasActiveSession ? Icons.radio_button_checked : Icons.school,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasActiveSession
                          ? 'Sesi Absensi Aktif'
                          : 'Tidak Ada Sesi Aktif',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasActiveSession) ...[
                      const SizedBox(height: 4),
                      Text(
                        activeClass.name,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (hasActiveSession) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/lecturer/attendance/monitor',
                        arguments: {
                          'sessionId': activeClass.activeSessionId ?? 0,
                          'className': activeClass.name,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Monitor',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Tutup Sesi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akses Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQuickAccessItem(
                icon: Icons.school_outlined,
                label: 'Kelas Saya',
                color: Colors.blue.shade600,
                onTap: () => Navigator.pushNamed(context, '/lecturer/classes'),
              ),
              const SizedBox(width: 12),
              _buildQuickAccessItem(
                icon: Icons.assessment_outlined,
                label: 'Laporan',
                color: Colors.purple.shade600,
                onTap: () => Navigator.pushNamed(context, '/lecturer/reports'),
              ),
              const SizedBox(width: 12),
              _buildQuickAccessItem(
                icon: Icons.bar_chart,
                label: 'Statistik',
                color: Colors.green.shade600,
                onTap: () => Navigator.pushNamed(context, '/lecturer/stats'),
              ),
              const SizedBox(width: 12),
              _buildQuickAccessItem(
                icon: Icons.settings_outlined,
                label: 'Pengaturan',
                color: Colors.grey.shade600,
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassesSection(LecturerHomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kelas Saya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lecturer/classes');
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.classes.isEmpty)
            _buildEmptyState()
          else
            ...controller.classes.take(3).map((classModel) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LecturerClassCard(
                  classModel: classModel,
                  onTapDetail: () {
                    Navigator.pushNamed(
                      context,
                      '/lecturer/class/detail',
                      arguments: classModel.id,
                    );
                  },
                  onTapSession: () async {
                    if (classModel.hasActiveSession) {
                      // Stop session with confirmation
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Tutup Sesi'),
                          content: const Text(
                            'Apakah Anda yakin ingin menutup sesi absensi?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        // We need a way to stop session via controller or service
                        // LecturerClassListPage used _handleStopSession.
                        // LecturerHomeController doesn't have this method yet probably.
                        // But we can use LecturerClassService directly or add to controller.
                        // Let's use service directly for now or see if controller has it.
                        // Checking controller later. For now assume passing this logic.
                        await _handleStopSession(classModel.id);
                      }
                    } else {
                      // Start session
                      await _handleStartSession(classModel.id);
                    }
                  },
                  // onDelete: null, // No delete on Home Page
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _handleStartSession(int classId) async {
    try {
      await LecturerClassService.startSession(classId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi absensi dimulai'),
            backgroundColor: Colors.green,
          ),
        );
        _onRefresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleStopSession(int classId) async {
    try {
      await LecturerClassService.stopSession(classId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi absensi ditutup'),
            backgroundColor: Colors.green,
          ),
        );
        _onRefresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatisticsCard(AttendanceStatsModel stats) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Kehadiran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem(
                'Hadir',
                stats.present.toString(),
                Colors.green.shade600,
              ),
              _buildStatItem(
                'Terlambat',
                stats.late.toString(),
                Colors.orange.shade600,
              ),
              _buildStatItem(
                'Tidak Hadir',
                stats.absent.toString(),
                Colors.red.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Kelas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda belum membuat kelas.\nBuat kelas pertama Anda untuk memulai.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(LecturerHomeController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? 'Gagal memuat dashboard',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _controller.loadAll(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
