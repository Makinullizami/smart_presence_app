import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

/// Attendance Success Page
class AttendanceSuccessPage extends StatelessWidget {
  const AttendanceSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final type = args?['type'] as String? ?? 'check-in';
    final method = args?['method'] as String? ?? 'Unknown';
    final time = args?['time'] as String? ?? '-';

    final isCheckIn = type == 'check-in';

    return Scaffold(
      backgroundColor: isCheckIn ? Colors.blue.shade50 : Colors.orange.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isCheckIn ? Colors.blue : Colors.orange)
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 100,
                  color: isCheckIn
                      ? Colors.blue.shade700
                      : Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 40),

              // Title
              Text(
                isCheckIn ? 'Check-in Berhasil!' : 'Check-out Berhasil!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Info Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: 'Waktu',
                      value: time,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.fingerprint,
                      label: 'Metode',
                      value: method,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.check_circle_outline,
                      label: 'Status',
                      value: isCheckIn ? 'Hadir' : 'Selesai',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => AppRoutes.toHome(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCheckIn
                        ? Colors.blue.shade700
                        : Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () => AppRoutes.toAttendanceHistory(context),
                child: Text(
                  'Lihat Riwayat Absensi',
                  style: TextStyle(
                    fontSize: 16,
                    color: isCheckIn
                        ? Colors.blue.shade700
                        : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
