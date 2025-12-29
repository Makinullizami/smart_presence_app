import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/profile/controllers/profile_controller.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/classes/pages/class_list_page.dart';
import '../../features/attendance/pages/attendance_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/lecturer/pages/lecturer_home_page.dart';
import '../../features/lecturer/pages/lecturer_stats_page.dart';
import '../../features/lecturer/pages/lecturer_report_page.dart';

/// Main Scaffold with persistent bottom navigation
class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Load user profile when app starts (if not already loaded)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileController = Provider.of<ProfileController>(
        context,
        listen: false,
      );
      if (profileController.user == null &&
          profileController.state != ProfileState.loading) {
        profileController.loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Consumer<ProfileController>(
      builder: (context, profileController, _) {
        final user = profileController.user;
        final role = user?.role.toLowerCase() ?? '';
        final isLecturer = role == 'dosen' || role == 'lecturer';

        final List<Widget> pages = isLecturer
            ? [
                const LecturerHomePage(),
                const LecturerStatsPage(),
                const LecturerReportPage(),
                const ProfilePage(),
              ]
            : [
                const HomePage(),
                const ClassListPage(),
                const AttendancePage(),
                const ProfilePage(),
              ];

        final List<Map<String, dynamic>> navItems = isLecturer
            ? [
                {
                  'icon': Icons.home_outlined,
                  'active': Icons.home,
                  'label': 'Beranda',
                },
                {
                  'icon': Icons.insert_chart_outlined,
                  'active': Icons.bar_chart,
                  'label': 'Statistik',
                },
                {
                  'icon': Icons.assignment_outlined,
                  'active': Icons.assignment,
                  'label': 'Laporan',
                },
                {
                  'icon': Icons.person_outline,
                  'active': Icons.person,
                  'label': 'Profil',
                },
              ]
            : [
                {
                  'icon': Icons.home_outlined,
                  'active': Icons.home,
                  'label': 'Beranda',
                },
                {
                  'icon': Icons.class_outlined,
                  'active': Icons.class_,
                  'label': 'Kelas',
                },
                {
                  'icon': Icons.fingerprint_outlined,
                  'active': Icons.fingerprint,
                  'label': 'Absensi',
                },
                {
                  'icon': Icons.person_outline,
                  'active': Icons.person,
                  'label': 'Profil',
                },
              ];

        return PopScope(
          canPop: _currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _currentIndex != 0) {
              setState(() {
                _currentIndex = 0;
              });
            }
          },
          child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: pages),
            bottomNavigationBar: _buildBottomNav(isTablet, navItems),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(bool isTablet, List<Map<String, dynamic>> navItems) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16.0 : 8.0,
            vertical: isTablet ? 12.0 : 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              return _buildNavItem(
                icon: item['icon'] as IconData,
                activeIcon: item['active'] as IconData,
                label: item['label'] as String,
                index: index,
                isTablet: isTablet,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isTablet,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 12.0 : 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade400,
                size: isTablet ? 30.0 : 26.0,
              ),
              SizedBox(height: isTablet ? 6.0 : 4.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 14.0 : 12.0,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
