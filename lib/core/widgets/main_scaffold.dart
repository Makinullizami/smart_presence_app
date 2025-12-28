import 'package:flutter/material.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/classes/pages/class_list_page.dart';
import '../../features/attendance/pages/attendance_page.dart';
import '../../features/profile/pages/profile_page.dart';

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
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ClassListPage(),
    const AttendancePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: _buildBottomNav(isTablet),
      ),
    );
  }

  Widget _buildBottomNav(bool isTablet) {
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
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                isTablet: isTablet,
              ),
              _buildNavItem(
                icon: Icons.class_outlined,
                activeIcon: Icons.class_,
                label: 'Kelas',
                index: 1,
                isTablet: isTablet,
              ),
              _buildNavItem(
                icon: Icons.fingerprint_outlined,
                activeIcon: Icons.fingerprint,
                label: 'Absensi',
                index: 2,
                isTablet: isTablet,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
                isTablet: isTablet,
              ),
            ],
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
