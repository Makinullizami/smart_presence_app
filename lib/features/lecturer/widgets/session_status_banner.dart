import 'package:flutter/material.dart';

/// Session Status Banner
/// Shows active/closed status with pulse animation
class SessionStatusBanner extends StatelessWidget {
  final bool isActive;
  final String startTime;

  const SessionStatusBanner({
    super.key,
    required this.isActive,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        border: Border(
          top: BorderSide(
            color: isActive ? Colors.green.shade100 : Colors.grey.shade200,
          ),
          bottom: BorderSide(
            color: isActive ? Colors.green.shade100 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isActive) ...[
            // Pulse animation
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade400.withValues(alpha: 0.3),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          Text(
            isActive
                ? 'Sesi Sedang Berlangsung ($startTime)'
                : 'Sesi Absensi Ditutup',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green.shade800 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
