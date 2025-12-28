import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar Widget
/// Provides consistent navigation across all main pages
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                route: '/home',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.class_outlined,
                activeIcon: Icons.class_,
                label: 'Kelas',
                index: 1,
                route: '/classes',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.fingerprint_outlined,
                activeIcon: Icons.fingerprint,
                label: 'Absensi',
                index: 2,
                route: '/attendance',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
                route: '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required String route,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade400,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
