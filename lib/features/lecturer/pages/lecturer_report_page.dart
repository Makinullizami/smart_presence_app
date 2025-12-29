import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/report_model.dart';
import '../services/lecturer_report_service.dart';

class LecturerReportPage extends StatefulWidget {
  const LecturerReportPage({super.key});

  @override
  State<LecturerReportPage> createState() => _LecturerReportPageState();
}

class _LecturerReportPageState extends State<LecturerReportPage> {
  bool _isLoading = true;
  ReportSummaryModel? _summary;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await LecturerReportService.getSummary();
      setState(() {
        _summary = data;
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
      appBar: AppBar(
        title: const Text('Laporan & Analitik'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Data',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Export akan segera hadir')),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 24),
          const Text(
            'Distribusi Kehadiran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          AspectRatio(aspectRatio: 1.5, child: _buildPieChart()),
          const SizedBox(height: 24),
          // Placeholder for "At Risk" students list or detailed class navigation
          _buildExportSection(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildSummaryCard(
          'Total Kelas',
          _summary!.totalClasses.toString(),
          Icons.class_,
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildSummaryCard(
          'Rata-rata Hadir',
          '${_summary!.attendanceRate.toStringAsFixed(1)}%',
          Icons.percent,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final distribution = _summary!.distribution;
    final total =
        distribution.present +
        distribution.sick +
        distribution.permission +
        distribution.alpha;

    if (total == 0) {
      return const Center(child: Text('Belum ada data absensi'));
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          _buildPieSection(distribution.present, Colors.green, 'Hadir'),
          _buildPieSection(distribution.sick, Colors.orange, 'Sakit'),
          _buildPieSection(distribution.permission, Colors.blue, 'Izin'),
          _buildPieSection(distribution.alpha, Colors.red, 'Alpha'),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieSection(int value, Color color, String title) {
    final total =
        _summary!.distribution.present +
        _summary!.distribution.sick +
        _summary!.distribution.permission +
        _summary!.distribution.alpha;
    final percentage = total > 0 ? (value / total * 100) : 0;

    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: '${percentage.toStringAsFixed(0)}%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildExportSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.file_download),
        title: const Text('Export Laporan Lengkap'),
        subtitle: const Text('Download data dalam format Excel/PDF'),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Export akan segera hadir')),
          );
        },
      ),
    );
  }
}
