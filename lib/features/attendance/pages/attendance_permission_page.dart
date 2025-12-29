import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendancePermissionPage extends StatefulWidget {
  const AttendancePermissionPage({super.key});

  @override
  State<AttendancePermissionPage> createState() =>
      _AttendancePermissionPageState();
}

class _AttendancePermissionPageState extends State<AttendancePermissionPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = 'permission'; // permission or sick
  final _reasonController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStatus == 'sick' && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lampirkan foto bukti sakit (surat dokter/obat)'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final classId = args?['class_id'];

      // Additional data with class_room_id for session validation
      final additionalData = <String, dynamic>{
        'status': _selectedStatus,
        'notes': _reasonController.text,
        if (classId != null) 'class_room_id': classId,
      };

      await AttendanceService.checkIn(
        method: AttendanceMethod
            .manual, // or a specific permission method? Using manual for now
        location: null, // Permission doesn't strictly need location
        additionalData: additionalData,
        attachment: _selectedImage,
      );

      if (mounted) {
        // Show success and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengajuan berhasil dikirim')),
        );
        Navigator.pop(context); // Back to class detail
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Izin / Sakit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'permission', child: Text('Izin')),
                  DropdownMenuItem(value: 'sick', child: Text('Sakit')),
                ],
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan / Alasan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Mohon isi keterangan'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Lampiran (Foto)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ketuk untuk ambil foto',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            if (_selectedStatus == 'sick')
                              Text(
                                '*Wajib untuk Sakit',
                                style: TextStyle(
                                  color: Colors.red.shade400,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kirim Pengajuan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
