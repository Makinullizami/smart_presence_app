import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/class_controller.dart';
import '../widgets/class_card.dart';

/// Class List Page - Displays list of classes for student
class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  late ClassController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ClassController()..loadClasses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: Text(
            'Kelas Saya',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 22.0 : 20.0,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey.shade800,
        ),
        body: Consumer<ClassController>(
          builder: (context, controller, _) {
            if (controller.state == ClassState.loading) {
              return _buildLoading();
            }

            if (controller.state == ClassState.error) {
              return _buildError(controller, isTablet);
            }

            if (controller.classes.isEmpty) {
              return _buildEmptyState(isTablet);
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: Colors.blue.shade700,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
                children: [
                  // Subtitle
                  Text(
                    'Daftar kelas yang Anda ikuti',
                    style: TextStyle(
                      fontSize: isTablet ? 16.0 : 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24.0 : 20.0),

                  // Class Cards
                  ...controller.classes.map((classModel) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: isTablet ? 16.0 : 12.0),
                      child: ClassCard(
                        classModel: classModel,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/classes/detail',
                            arguments: classModel.id,
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ClassController controller, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 80.0 : 64.0,
              color: Colors.red.shade300,
            ),
            SizedBox(height: isTablet ? 24.0 : 16.0),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: isTablet ? 22.0 : 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isTablet ? 12.0 : 8.0),
            Text(
              controller.errorMessage ?? 'Gagal memuat data kelas',
              style: TextStyle(
                fontSize: isTablet ? 16.0 : 14.0,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 32.0 : 24.0),
            ElevatedButton.icon(
              onPressed: () => _controller.loadClasses(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.0 : 24.0,
                  vertical: isTablet ? 16.0 : 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 40.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: isTablet ? 100.0 : 80.0,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: isTablet ? 24.0 : 16.0),
            Text(
              'Belum Ada Kelas',
              style: TextStyle(
                fontSize: isTablet ? 22.0 : 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: isTablet ? 12.0 : 8.0),
            Text(
              'Belum ada kelas yang tersedia.\nSilakan hubungi dosen untuk informasi lebih lanjut.',
              style: TextStyle(
                fontSize: isTablet ? 16.0 : 14.0,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
