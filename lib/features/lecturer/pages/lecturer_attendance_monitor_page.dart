import 'package:flutter/material.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/services/api_service.dart';

class LecturerAttendanceMonitorPage extends StatefulWidget {
  final int sessionId;
  final String className;

  const LecturerAttendanceMonitorPage({
    super.key,
    required this.sessionId,
    required this.className,
  });

  @override
  State<LecturerAttendanceMonitorPage> createState() =>
      _LecturerAttendanceMonitorPageState();
}

class _LecturerAttendanceMonitorPageState
    extends State<LecturerAttendanceMonitorPage> {
  bool _isLoading = true;
  List<dynamic> _attendees = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendees();
  }

  Future<void> _fetchAttendees() async {
    try {
      final response = await ApiService.get(
        '${ApiUrl.baseUrl}/session/${widget.sessionId}/attendances',
      );
      if (mounted) {
        setState(() {
          _attendees = response['data'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat kehadiran: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'sick':
        return Colors.orange;
      case 'permission':
        return Colors.blue;
      case 'alpha':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'present':
        return 'Hadir';
      case 'sick':
        return 'Sakit';
      case 'permission':
        return 'Izin';
      case 'alpha':
        return 'Alpha';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Kehadiran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchAttendees();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _attendees.isEmpty
          ? const Center(child: Text('Belum ada yang absen'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _attendees.length,
              itemBuilder: (context, index) {
                final item = _attendees[index];
                final user = item['user'];
                final status = item['status'] ?? 'present';
                final checkInTime = DateTime.parse(item['created_at']);
                final timeStr =
                    '${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}';
                final notes = item['notes'];
                final attachment = item['attachment'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(status).withAlpha(50),
                      child: Icon(
                        status == 'present'
                            ? Icons.check
                            : status == 'sick'
                            ? Icons.sick
                            : Icons.assignment,
                        color: _getStatusColor(status),
                      ),
                    ),
                    title: Text(
                      user['name'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(status),
                            style: TextStyle(
                              color: _getStatusColor(status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('@ $timeStr'),
                      ],
                    ),
                    children: [
                      if (status != 'present' &&
                          (notes != null || attachment != null))
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (notes != null) ...[
                                const Text(
                                  'Catatan:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(notes),
                                const SizedBox(height: 8),
                              ],
                              if (attachment != null) ...[
                                const Text(
                                  'Lampiran:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                // Assuming attachment is a relative path or full URL
                                // You might need to adjust BaseURL logic here if attachment is relative path
                                Image.network(
                                  attachment.startsWith('http')
                                      ? attachment
                                      : '${ApiUrl.baseUrl}/$attachment'.replaceAll(
                                          '/api/',
                                          '/',
                                        ), // Hacky URL fix depending on backend setup
                                  // Better to ensure backend returns full URL or have a helper.
                                  // Assuming simple storage link: "attachments/filename.jpg" -> "http://host/attachments/filename.jpg"
                                  // My backend setup: public/attachments
                                  // Laravel default public access.
                                  // So url is base_url (without /api) + / + attachment
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text(
                                        'Gagal memuat gambar lampiran',
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
