import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_model.dart';
import '../../../routes/app_routes.dart';

/// Attendance Face Recognition Page
class AttendanceFacePage extends StatefulWidget {
  const AttendanceFacePage({super.key});

  @override
  State<AttendanceFacePage> createState() => _AttendanceFacePageState();
}

class _AttendanceFacePageState extends State<AttendanceFacePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startFaceScan() async {
    setState(() => _isScanning = true);

    // Simulate face scanning
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // TODO: Implement actual face recognition
    // For now, simulate success
    final controller = Provider.of<AttendanceController>(
      context,
      listen: false,
    );
    controller.selectMethod(AttendanceMethod.faceRecognition);

    final success = controller.canCheckIn
        ? await controller.checkIn()
        : await controller.checkOut();

    if (!mounted) return;

    if (success) {
      final type = controller.canCheckOut ? 'check-in' : 'check-out';
      final time = DateTime.now().toString().substring(11, 16);

      AppRoutes.toAttendanceSuccess(
        context,
        type: type,
        method: 'Face Recognition',
        time: time,
      );
    } else {
      setState(() => _isScanning = false);
      _showError(controller.errorMessage ?? 'Terjadi kesalahan');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Face Recognition'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Face outline animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isScanning ? Colors.green : Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.face,
                        size: 150,
                        color: _isScanning ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Status text
                  Text(
                    _isScanning
                        ? 'Memindai wajah...'
                        : 'Posisikan wajah Anda di dalam lingkaran',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Bottom action
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (!_isScanning)
                  ElevatedButton(
                    onPressed: _startFaceScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Mulai Scan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
