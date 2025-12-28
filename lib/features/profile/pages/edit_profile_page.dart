import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';

/// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _facultyController = TextEditingController();
  final _majorController = TextEditingController();

  late ProfileController _controller;
  bool _isLoading = false;
  bool _isMahasiswa = false;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _controller.loadProfile();
    if (_controller.user != null && mounted) {
      setState(() {
        _nameController.text = _controller.user!.name;
        _nimController.text = _controller.user!.nim ?? '';
        _facultyController.text = _controller.user!.faculty ?? '';
        _majorController.text = _controller.user!.major ?? '';
        _isMahasiswa = _controller.user!.role.toLowerCase() == 'mahasiswa';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _controller.updateProfile(
      name: _nameController.text.trim(),
      nim: _isMahasiswa ? _nimController.text.trim() : null,
      faculty: _isMahasiswa ? _facultyController.text.trim() : null,
      major: _isMahasiswa ? _majorController.text.trim() : null,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Profil berhasil diperbarui'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _controller.errorMessage ?? 'Gagal memperbarui profil',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Ensure we navigate back to profile with bottom tab
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: const Text('Edit Profil'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ),
        body: _controller.state == ProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.shade700,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: _controller.user?.photo != null
                                    ? NetworkImage(_controller.user!.photo!)
                                    : null,
                                child: _controller.user?.photo == null
                                    ? Text(
                                        _controller.user?.initials ?? 'U',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Fitur upload foto akan segera hadir',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.upload),
                          label: const Text('Ubah Foto'),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Personal Info Section
                      _buildSectionTitle('Informasi Pribadi'),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        icon: Icons.person_outline,
                        hint: 'Masukkan nama lengkap',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          if (value.trim().length < 3) {
                            return 'Nama minimal 3 karakter';
                          }
                          return null;
                        },
                      ),

                      // Academic Info Section (only for mahasiswa)
                      if (_isMahasiswa) ...[
                        const SizedBox(height: 32),
                        _buildSectionTitle('Informasi Akademik'),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _nimController,
                          label: 'NIM',
                          icon: Icons.badge,
                          hint: 'Masukkan NIM',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 5) {
                              return 'NIM minimal 5 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _facultyController,
                          label: 'Fakultas',
                          icon: Icons.business,
                          hint: 'Masukkan fakultas',
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 3) {
                              return 'Fakultas minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _majorController,
                          label: 'Jurusan / Program Studi',
                          icon: Icons.school_outlined,
                          hint: 'Masukkan jurusan',
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 3) {
                              return 'Jurusan minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Pastikan data yang Anda masukkan sesuai dengan identitas resmi',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save),
                                    SizedBox(width: 8),
                                    Text(
                                      'Simpan Perubahan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
