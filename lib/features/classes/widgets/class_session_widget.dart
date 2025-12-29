import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../profile/controllers/profile_controller.dart';
import '../services/class_service.dart';
// import '../../attendance/services/attendance_service.dart';
// Note: AttendanceService might typically be in features/attendance, but for now checkIn is in AttendanceController
// Or I can use ApiService directly or create AttendanceService if needed.
// For simplicity, I might just use ClassService or a direct API call if AttendanceService isn't handy or update AttendanceService later.
// Let's assume I can add checkIn to ClassService or use AttendanceService if it exists.
// Checking file structure... I saw features/attendance.

class ClassSessionWidget extends StatefulWidget {
  final int classId;

  const ClassSessionWidget({super.key, required this.classId});

  @override
  State<ClassSessionWidget> createState() => _ClassSessionWidgetState();
}

class _ClassSessionWidgetState extends State<ClassSessionWidget> {
  bool _isLoading = true;
  bool _isSessionActive = false;
  Map<String, dynamic>? _sessionData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkSessionStatus();
    // Refresh status every 30 seconds
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkSessionStatus(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkSessionStatus() async {
    try {
      final session = await ClassService.getActiveSession(widget.classId);
      if (mounted) {
        setState(() {
          _sessionData = session;
          _isSessionActive = session != null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // don't show error on background check, just keep state
          if (_isLoading) _isLoading = false;
        });
      }
    }
  }

  Future<void> _startSession() async {
    setState(() => _isLoading = true);
    try {
      await ClassService.startSession(widget.classId);
      await _checkSessionStatus();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sesi absensi dimulai')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _stopSession() async {
    setState(() => _isLoading = true);
    try {
      await ClassService.stopSession(widget.classId);
      await _checkSessionStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi absensi dihentikan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() => _isLoading = false);
      }
    }
  }

  void _showCheckInOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Absensi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.face, color: Colors.blue),
              ),
              title: const Text('Hadir (Face Recognition)'),
              subtitle: const Text('Scan wajah untuk konfirmasi kehadiran'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/attendance/face',
                  arguments: {
                    'class_id': widget.classId,
                    'session_id': _sessionData?['id'],
                  },
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  color: Colors.orange,
                ),
              ),
              title: const Text('Izin / Sakit'),
              subtitle: const Text('Isi form keterangan dan upload bukti'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/attendance/permission',
                  arguments: {
                    'class_id': widget.classId,
                    'session_id': _sessionData?['id'],
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _goToMonitoring() {
    Navigator.pushNamed(
      context,
      '/lecturer/attendance/monitor',
      arguments: {
        'sessionId': _sessionData?['id'],
        'className': 'Session Monitoring',
      },
    );
  }

  String _formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '-';
    try {
      final dt = DateTime.parse(dateTimeStr).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get user role
    final profileController = Provider.of<ProfileController>(context);
    final isLecturer = profileController.user?.role == 'dosen';

    if (_isLoading && _sessionData == null) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Absensi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _isSessionActive
                      ? Colors.green.shade50
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isSessionActive
                        ? Colors.green.shade200
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isSessionActive ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isSessionActive ? 'Sesi Aktif' : 'Tidak Ada Sesi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isSessionActive
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (isLecturer) ...[
            if (_isSessionActive) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _goToMonitoring,
                  icon: const Icon(Icons.people_alt_outlined),
                  label: const Text('Lihat Kehadiran Mahasiswa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _stopSession,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Hentikan Sesi'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startSession,
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Mulai Sesi Absensi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ] else ...[
            // Student View
            // Student View
            if (_isSessionActive)
              if (_sessionData?['has_attended'] == true)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Anda sudah absen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (_sessionData?['attendance_time'] != null)
                        Text(
                          'Waktu: ${_formatTime(_sessionData!['attendance_time'])}',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showCheckInOptions,
                    icon: const Icon(Icons.assignment_turned_in),
                    label: const Text('Isi Absensi Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Menunggu dosen memulai sesi absensi...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
