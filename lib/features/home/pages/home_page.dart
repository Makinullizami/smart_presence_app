import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../widgets/class_summary_card.dart';
import '../widgets/notification_preview.dart';
import '../widgets/attendance_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomeController _controller;
  late AnimationController _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = HomeController()..loadDashboard();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _controller.refresh();
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Consumer<HomeController>(
          builder: (context, controller, _) {
            if (controller.state == DashboardState.loading) {
              return _buildLoading();
            }

            if (controller.state == DashboardState.error) {
              return _buildError(controller);
            }

            final dashboard = controller.dashboard!;

            return FadeTransition(
              opacity: _animationController,
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(dashboard),

                  // Main Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: _buildContent(dashboard),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader(dynamic dashboard) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Info Row
          Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: dashboard.user.avatar != null
                      ? NetworkImage(dashboard.user.avatar!)
                      : null,
                  child: dashboard.user.avatar == null
                      ? Text(
                          dashboard.user.name.isNotEmpty
                              ? dashboard.user.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dashboard.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dashboard.user.roleDisplay,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Notification Icon
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur notifikasi akan segera hadir'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // ================= MAIN CONTENT =================

  Widget _buildContent(dynamic dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Card - Status Absensi
        _buildHeroCard(dashboard),
        const SizedBox(height: 24),

        // Quick Actions
        _sectionTitle('Aksi Cepat'),
        const SizedBox(height: 12),
        _buildQuickActions(context),

        const SizedBox(height: 28),
        _sectionTitle('Ringkasan Kelas'),
        const SizedBox(height: 12),
        ClassSummaryCard(
          summary: dashboard.classSummary,
          onTap: () => Navigator.pushNamed(context, '/classes'),
        ),

        const SizedBox(height: 28),
        _sectionTitle('Statistik Kehadiran'),
        const SizedBox(height: 12),
        AttendanceChart(stats: dashboard.stats),

        const SizedBox(height: 28),
        _sectionTitle('Notifikasi Terbaru'),
        const SizedBox(height: 12),
        NotificationPreview(
          notifications: dashboard.notifications,
          onViewAll: () {},
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // ================= BOTTOM NAVIGATION =================

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            // Navigate based on index
            switch (index) {
              case 0:
                // Already on home
                break;
              case 1:
                Navigator.pushNamed(context, '/classes');
                break;
              case 2:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur absensi akan segera hadir'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
              case 3:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur jadwal akan segera hadir'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
              case 4:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur profil akan segera hadir'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Kelas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint),
              activeIcon: Icon(Icons.fingerprint),
              label: 'Absensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildHeroCard(dynamic dashboard) {
    final attendance = dashboard.todayAttendance;
    final statusText = attendance?.statusDisplay ?? 'Belum Absen';
    final checkInTime = attendance?.checkInTime ?? '-';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Absensi Hari Ini',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                'Check-in: $checkInTime',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _quickAction(Icons.fingerprint, 'Absensi', Colors.blue, () {}),
      _quickAction(Icons.face, 'Face ID', Colors.purple, () {}),
      _quickAction(Icons.calendar_today, 'Jadwal', Colors.green, () {}),
      _quickAction(Icons.history, 'Riwayat', Colors.orange, () {}),
      _quickAction(Icons.assessment, 'Laporan', Colors.red, () {}),
      _quickAction(Icons.settings, 'Pengaturan', Colors.grey, () {}),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => actions[i],
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(HomeController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(controller.errorMessage ?? 'Unknown error'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.loadDashboard,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
