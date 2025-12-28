import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

/// Attendance Method Card - Display attendance method option
class AttendanceMethodCard extends StatefulWidget {
  final AttendanceMethod method;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enabled;

  const AttendanceMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<AttendanceMethodCard> createState() => _AttendanceMethodCardState();
}

class _AttendanceMethodCardState extends State<AttendanceMethodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final color = _getMethodColor();

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.enabled ? widget.onTap : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected ? color : Colors.grey.shade300,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: widget.isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Opacity(
            opacity: widget.enabled ? 1.0 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getMethodIcon(),
                    size: isTablet ? 48.0 : 40.0,
                    color: color,
                  ),
                ),
                SizedBox(height: isTablet ? 16.0 : 12.0),

                // Title
                Text(
                  widget.method.title,
                  style: TextStyle(
                    fontSize: isTablet ? 18.0 : 16.0,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected ? color : Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isTablet ? 6.0 : 4.0),

                // Subtitle
                Text(
                  widget.method.subtitle,
                  style: TextStyle(
                    fontSize: isTablet ? 13.0 : 12.0,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMethodIcon() {
    switch (widget.method) {
      case AttendanceMethod.faceRecognition:
        return Icons.face;
      case AttendanceMethod.pin:
        return Icons.pin;
      case AttendanceMethod.qrCode:
        return Icons.qr_code_scanner;
    }
  }

  Color _getMethodColor() {
    switch (widget.method) {
      case AttendanceMethod.faceRecognition:
        return Colors.blue;
      case AttendanceMethod.pin:
        return Colors.purple;
      case AttendanceMethod.qrCode:
        return Colors.green;
    }
  }
}
