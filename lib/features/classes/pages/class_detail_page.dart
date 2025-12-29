import 'package:flutter/material.dart';
import 'add_material_page.dart';
import 'create_assignment_page.dart';
import 'package:provider/provider.dart';
import '../../profile/controllers/profile_controller.dart';
import '../widgets/material_list_widget.dart';
import '../widgets/assignment_list_widget.dart';
import '../widgets/student_list_widget.dart';
import '../widgets/class_session_widget.dart';

/// Basic Class Detail Page
/// Shows class information with tabs for Materials, Assignments, and Students
class ClassDetailPage extends StatefulWidget {
  final int classId;

  const ClassDetailPage({super.key, required this.classId});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
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
              Tab(icon: Icon(Icons.people), text: 'Mahasiswa'),
            ],
          ),
        ),
        body: Column(
          children: [
            ClassSessionWidget(classId: widget.classId),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMaterialsTab(),
                  _buildAssignmentsTab(),
                  _buildStudentsTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Consumer<ProfileController>(
          builder: (context, profileController, _) {
            final isStudent = profileController.user?.role == 'mahasiswa';

            // If student or tab index is 2 (Students tab), don't show FAB
            if (isStudent || _currentTab >= 2) {
              return const SizedBox.shrink();
            }

            return FloatingActionButton.extended(
              onPressed: () async {
                if (_currentTab == 0) {
                  // Navigate to Add Material
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddMaterialPage(classId: widget.classId),
                    ),
                  );
                  if (result == true) {
                    // Refresh materials list
                    setState(() {});
                  }
                } else if (_currentTab == 1) {
                  // Navigate to Create Assignment
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CreateAssignmentPage(classId: widget.classId),
                    ),
                  );
                  if (result == true) {
                    // Refresh assignments list
                    setState(() {});
                  }
                }
              },
              backgroundColor: Colors.blue.shade700,
              icon: const Icon(Icons.add),
              label: Text(_currentTab == 0 ? 'Tambah Materi' : 'Buat Tugas'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialsTab() {
    return MaterialListWidget(classId: widget.classId);
  }

  Widget _buildAssignmentsTab() {
    return AssignmentListWidget(classId: widget.classId);
  }

  Widget _buildStudentsTab() {
    return StudentListWidget(classId: widget.classId);
  }
}
