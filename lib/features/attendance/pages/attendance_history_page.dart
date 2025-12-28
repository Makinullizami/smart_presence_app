import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/attendance_service.dart';
import '../models/attendance_model.dart';

/// Attendance History Page
class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<AttendanceModel> _history = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final history = await AttendanceService.getHistory(limit: 30);
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildError()
          : _history.isEmpty
          ? _buildEmpty()
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return _buildHistoryCard(_history[index]);
                },
              ),
            ),
    );
  }

  Widget _buildHistoryCard(AttendanceModel attendance) {
    final dateFormat = DateFormat('EEEE, dd MMM yyyy', 'id_ID');
    final statusColor = attendance.status == AttendanceStatusEnum.checkedOut
        ? Colors.green
        : attendance.status == AttendanceStatusEnum.checkedIn
        ? Colors.orange
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(attendance.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  attendance.statusDisplay,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Times
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo(
                  icon: Icons.login,
                  label: 'Check-in',
                  time: attendance.checkInTimeFormatted,
                  method: attendance.checkInMethod,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeInfo(
                  icon: Icons.logout,
                  label: 'Check-out',
                  time: attendance.checkOutTimeFormatted,
                  method: attendance.checkOutMethod,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo({
    required IconData icon,
    required String label,
    required String time,
    String? method,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (method != null) ...[
            const SizedBox(height: 4),
            Text(
              method,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat absensi',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadHistory,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
