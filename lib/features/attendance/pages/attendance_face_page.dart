import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Import for Uint8List
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
  Uint8List? _capturedBytes; // Use bytes for cross-platform support
  final ImagePicker _picker = ImagePicker();

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

    // Auto start camera if desired, but button press is safer for now
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startFaceScan() async {
    setState(() => _isScanning = true);

    try {
      // Capture image using camera
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 600, // Optimize size
        imageQuality: 80,
      );

      if (photo == null) {
        setState(() => _isScanning = false);
        return; // User cancelled
      }

      final bytes = await photo.readAsBytes();

      setState(() {
        _capturedBytes = bytes;
        _isScanning = true; // Keep scanning state while uploading
      });

      if (!mounted) return;

      // Proceed to Check-In
      final controller = Provider.of<AttendanceController>(
        context,
        listen: false,
      );
      controller.selectMethod(AttendanceMethod.faceRecognition);

      // Get arguments (class/session context)
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final classId = args?['class_id'];

      // perform check-in with attachment
      final success = controller.canCheckIn
          ? await controller.checkIn(
              additionalData: classId != null
                  ? {'class_room_id': classId}
                  : null,
              attachment: _capturedBytes,
              filename: photo.name,
            )
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

        // Handle "Already checked in" as success (User request)
        final errorMsg = controller.errorMessage ?? '';
        if (errorMsg.toLowerCase().contains('sudah melakukan check-in')) {
          AppRoutes.toAttendanceSuccess(
            context,
            type: 'check-in', // Assume check-in since they are already present
            method: 'Face Recognition',
            time: DateTime.now().toString().substring(11, 16),
          );
          return;
        }

        _showError(
          controller.errorMessage ?? 'Terjadi kesalahan saat verifikasi wajah',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        _showError('Gagal mengambil gambar: $e');
      }
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
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Face outline or Captured Image
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
                      image: _capturedBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_capturedBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _capturedBytes == null
                        ? Icon(
                            Icons.face,
                            size: 150,
                            color: _isScanning ? Colors.green : Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 40),

                // Status text
                Text(
                  _isScanning
                      ? 'Memproses Absensi...'
                      : 'Posisikan wajah Anda dan ambil foto',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
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
                          'Ambil Foto Wajah',
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
