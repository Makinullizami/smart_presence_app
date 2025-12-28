import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_model.dart';
import '../../../routes/app_routes.dart';

/// Attendance QR Code Page
class AttendanceQrPage extends StatefulWidget {
  const AttendanceQrPage({super.key});

  @override
  State<AttendanceQrPage> createState() => _AttendanceQrPageState();
}

class _AttendanceQrPageState extends State<AttendanceQrPage> {
  bool _isScanning = false;

  Future<void> _startQrScan() async {
    setState(() => _isScanning = true);

    // Simulate QR scanning
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // TODO: Implement actual QR code scanner
    // For now, simulate success
    final controller = Provider.of<AttendanceController>(
      context,
      listen: false,
    );
    controller.selectMethod(AttendanceMethod.qrCode);

    final success = controller.canCheckIn
        ? await controller.checkIn()
        : await controller.checkOut();

    if (!mounted) return;

    setState(() => _isScanning = false);

    if (success) {
      final type = controller.canCheckOut ? 'check-in' : 'check-out';
      final time = DateTime.now().toString().substring(11, 16);

      AppRoutes.toAttendanceSuccess(
        context,
        type: type,
        method: 'QR Code',
        time: time,
      );
    } else {
      _showError(controller.errorMessage ?? 'QR Code tidak valid');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // QR Scanner placeholder
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Frame
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isScanning ? Colors.green : Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 120,
                        color: _isScanning ? Colors.green : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Status text
                  Text(
                    _isScanning
                        ? 'Memindai QR Code...'
                        : 'Posisikan QR Code di dalam frame',
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
                    onPressed: _startQrScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
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
                        Icon(Icons.qr_code_scanner, color: Colors.white),
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
