import 'package:flutter/material.dart';
import '../widgets/material_list_widget.dart';
import '../widgets/assignment_list_widget.dart';
import '../widgets/class_session_widget.dart';

/// Student Class Detail Page
/// Shows class information with tabs for Materials, Assignments, and Attendance History
class StudentClassDetailPage extends StatefulWidget {
  final int classId;

  const StudentClassDetailPage({super.key, required this.classId});

  @override
  State<StudentClassDetailPage> createState() => _StudentClassDetailPageState();
}

class _StudentClassDetailPageState extends State<StudentClassDetailPage> {
  int _currentTab = 0;
  bool _isLoading = true;
  // bool _hasActiveSession = false; // Removed
  // int? _activeSessionId; // Removed
  // Map<String, dynamic>? _classData; // Removed

  @override
  void initState() {
    super.initState();
    _loadClassDetail();
  }

  Future<void> _loadClassDetail() async {
    // TODO: Load class detail from API
    // For now, just set loading to false
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('Detail Kelas'),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            onTap: (index) {
              setState(() => _currentTab = index);
            },
            tabs: const [
              Tab(icon: Icon(Icons.book), text: 'Materi'),
              Tab(icon: Icon(Icons.assignment), text: 'Tugas'),
              Tab(icon: Icon(Icons.history), text: 'Absensi'),
            ],
          ),
        ),
        body: Column(
          children: [
            ClassSessionWidget(classId: widget.classId),
            Expanded(
              child: TabBarView(
                children: [
                  MaterialListWidget(classId: widget.classId),
                  AssignmentListWidget(classId: widget.classId),
                  _buildAttendanceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Riwayat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat absensi Anda akan muncul di sini',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
