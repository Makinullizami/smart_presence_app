import 'package:flutter/material.dart';

/// Attendance Action Button - Large primary button for check-in/check-out
class AttendanceActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData icon;
  final Color? color;

  const AttendanceActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon = Icons.fingerprint,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.blue.shade700;
    final isEnabled = onPressed != null && !isLoading;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: [buttonColor, buttonColor.withValues(alpha: 0.8)],
              )
            : null,
        color: isEnabled ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: buttonColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isEnabled ? Colors.white : Colors.grey.shade500,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          color: isEnabled
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
