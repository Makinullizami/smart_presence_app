import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_model.dart';
import '../../../routes/app_routes.dart';

/// Attendance PIN Page
class AttendancePinPage extends StatefulWidget {
  const AttendancePinPage({super.key});

  @override
  State<AttendancePinPage> createState() => _AttendancePinPageState();
}

class _AttendancePinPageState extends State<AttendancePinPage> {
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    if (_pinController.text.length < 4) {
      _showError('PIN minimal 4 digit');
      return;
    }

    setState(() => _isLoading = true);

    final controller = Provider.of<AttendanceController>(
      context,
      listen: false,
    );
    controller.selectMethod(AttendanceMethod.pin);

    final success = controller.canCheckIn
        ? await controller.checkIn(additionalData: {'pin': _pinController.text})
        : await controller.checkOut(
            additionalData: {'pin': _pinController.text},
          );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      final type = controller.canCheckOut ? 'check-in' : 'check-out';
      final time = DateTime.now().toString().substring(11, 16);

      AppRoutes.toAttendanceSuccess(
        context,
        type: type,
        method: 'PIN',
        time: time,
      );
    } else {
      _showError(controller.errorMessage ?? 'PIN salah');
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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Absensi dengan PIN'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.pin, size: 80, color: Colors.purple.shade700),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Masukkan PIN Anda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'PIN yang terdaftar di sistem',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 40),

            // PIN Input
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 16,
              ),
              decoration: InputDecoration(
                hintText: '• • • •',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.purple.shade700,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Konfirmasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
