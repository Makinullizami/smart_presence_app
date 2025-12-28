import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';

/// Profile Page - Main profile screen with modern responsive UI
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController()..loadProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout, color: Colors.red.shade700, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Konfirmasi Logout', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await _controller.logout();

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Consumer<ProfileController>(
          builder: (context, controller, _) {
            if (controller.state == ProfileState.loading ||
                controller.state == ProfileState.initial) {
              return _buildLoading();
            }

            if (controller.state == ProfileState.error) {
              return _buildError(controller);
            }

            final user = controller.user!;

            return RefreshIndicator(
              onRefresh: controller.refresh,
              color: Colors.blue.shade700,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Profile Header
                    _buildProfileHeader(user),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Cards
                          _buildStatsCards(user),
                          const SizedBox(height: 24),

                          // Personal Info Section
                          _buildSectionHeader(
                            'Informasi Pribadi',
                            Icons.person,
                          ),
                          const SizedBox(height: 12),
                          _buildPersonalInfoCard(user),
                          const SizedBox(height: 24),

                          // Academic Info Section (only for mahasiswa)
                          if (user.role.toLowerCase() == 'mahasiswa') ...[
                            _buildSectionHeader(
                              'Informasi Akademik',
                              Icons.school,
                            ),
                            const SizedBox(height: 12),
                            _buildAcademicInfoCard(user),
                            const SizedBox(height: 24),
                          ],

                          // Menu Section
                          _buildSectionHeader('Pengaturan', Icons.settings),
                          const SizedBox(height: 12),
                          _buildMenuCard(),
                          const SizedBox(height: 80), // Space for bottom nav
                        ],
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

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
            Colors.purple.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: user.photo != null
                          ? NetworkImage(user.photo!)
                          : null,
                      child: user.photo == null
                          ? Text(
                              user.initials,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/profile/edit');
                        _controller.loadProfile();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue.shade700,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Email
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      user.role.toLowerCase() == 'mahasiswa'
                          ? Icons.school
                          : user.role.toLowerCase() == 'dosen'
                          ? Icons.person
                          : Icons.admin_panel_settings,
                      color: Colors.blue.shade700,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.roleDisplay,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_today,
                label: 'Bergabung',
                value: user.createdAt != null
                    ? '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                    : '-',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.verified_user,
                label: 'Status',
                value: 'Aktif',
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue.shade700, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Nama Lengkap',
            value: user.name,
            iconColor: Colors.blue,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            iconColor: Colors.orange,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            label: 'Role',
            value: user.roleDisplay,
            iconColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.badge,
            label: 'NIM',
            value: user.nim ?? 'Belum diisi',
            iconColor: Colors.green,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.business,
            label: 'Fakultas',
            value: user.faculty ?? 'Belum diisi',
            iconColor: Colors.teal,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'Jurusan',
            value: user.major ?? 'Belum diisi',
            iconColor: Colors.indigo,
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
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
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

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit_outlined,
            label: 'Edit Profil',
            onTap: () async {
              await Navigator.pushNamed(context, '/profile/edit');
              _controller.loadProfile();
            },
            iconColor: Colors.blue,
            showDivider: true,
          ),
          _buildMenuItem(
            icon: Icons.lock_outline,
            label: 'Ganti Password',
            onTap: () => Navigator.pushNamed(context, '/profile/password'),
            iconColor: Colors.orange,
            showDivider: true,
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            label: 'Bantuan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Fitur bantuan akan segera hadir'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            iconColor: Colors.green,
            showDivider: true,
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Smart Presence',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 48,
                    color: Colors.blue.shade700,
                  ),
                ),
              );
            },
            iconColor: Colors.purple,
            showDivider: true,
          ),
          _buildMenuItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: _handleLogout,
            isDestructive: true,
            iconColor: Colors.red,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconColor,
    required bool showDivider,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDestructive ? Colors.red : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.grey.shade200),
          ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat profil...',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ProfileController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.loadProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
