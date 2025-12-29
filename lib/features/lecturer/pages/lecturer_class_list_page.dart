import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lecturer_class_controller.dart';
import '../services/lecturer_class_service.dart';
import '../models/lecturer_dashboard_model.dart';
import '../widgets/lecturer_info_card.dart';
import '../widgets/lecturer_class_card.dart';
import '../widgets/empty_class_state.dart';
import '../../profile/controllers/profile_controller.dart';

/// Lecturer Class List Page
/// Shows all classes taught by the lecturer
class LecturerClassListPage extends StatefulWidget {
  const LecturerClassListPage({super.key});

  @override
  State<LecturerClassListPage> createState() => _LecturerClassListPageState();
}

class _LecturerClassListPageState extends State<LecturerClassListPage> {
  late LecturerClassController _controller;
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _controller = LecturerClassController();
    _profileController = ProfileController();
    _loadData();
  }

  Future<void> _loadData() async {
    await _profileController.loadProfile();
    await _controller.loadClasses();
  }

  @override
  void dispose() {
    _controller.dispose();
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _controller.refresh();
  }

  Future<void> _navigateToCreateClass() async {
    final result = await Navigator.pushNamed(
      context,
      '/lecturer/classes/create',
    );
    if (result == true) {
      // Refresh list after creating new class
      _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _controller),
        ChangeNotifierProvider.value(value: _profileController),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Kelas Saya',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(onPressed: _onRefresh, icon: const Icon(Icons.refresh)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navigateToCreateClass,
          backgroundColor: Colors.blue.shade700,
          icon: const Icon(Icons.add),
          label: const Text('Buat Kelas'),
        ),
        body: Consumer2<LecturerClassController, ProfileController>(
          builder: (context, controller, profileController, _) {
            if (controller.state == LecturerClassState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.state == LecturerClassState.error) {
              return _buildError(controller);
            }

            if (controller.state == LecturerClassState.empty) {
              return const EmptyClassState();
            }

            final classes = controller.classes;
            final user = profileController.user;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // Lecturer Info Card
                  LecturerInfoCard(
                    lecturerName: user?.name ?? 'Dosen',
                    totalClasses: classes.length,
                    semester: 'Semester Genap 2023/2024',
                  ),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Kelas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          '${classes.length} Kelas',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Class List
                  ...classes.map((classModel) {
                    return LecturerClassCard(
                      classModel: classModel,
                      onTapDetail: () {
                        Navigator.pushNamed(
                          context,
                          '/lecturer/class/detail',
                          arguments: classModel.id,
                        );
                      },
                      onTapSession: () async {
                        if (classModel.hasActiveSession) {
                          // Stop session with confirmation
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Tutup Sesi'),
                              content: const Text(
                                'Apakah Anda yakin ingin menutup sesi absensi?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await _handleStopSession(classModel.id);
                          }
                        } else {
                          // Start session
                          await _handleStartSession(classModel.id);
                        }
                      },
                      onDelete: () =>
                          _showDeleteConfirmation(context, classModel),
                    );
                  }),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(LecturerClassController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? 'Gagal memuat daftar kelas',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _controller.loadClasses(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    LecturerClassModel classModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kelas'),
        content: Text(
          'Apakah Anda yakin ingin menghapus kelas "${classModel.name}"?\n\nSemua data terkait kelas ini akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleDelete(classModel.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(int classId) async {
    try {
      await LecturerClassService.deleteClass(classId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kelas berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        _onRefresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleStartSession(int classId) async {
    try {
      await LecturerClassService.startSession(classId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi absensi dimulai'),
            backgroundColor: Colors.green,
          ),
        );
        _onRefresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleStopSession(int classId) async {
    try {
      await LecturerClassService.stopSession(classId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi absensi ditutup'),
            backgroundColor: Colors.green,
          ),
        );
        _onRefresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
