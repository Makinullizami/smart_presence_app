import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/lecturer_stats_model.dart';
import '../services/lecturer_stats_service.dart';

class LecturerStatsPage extends StatefulWidget {
  const LecturerStatsPage({super.key});

  @override
  State<LecturerStatsPage> createState() => _LecturerStatsPageState();
}

class _LecturerStatsPageState extends State<LecturerStatsPage> {
  bool _isLoading = true;
  String? _errorMessage;

  // Data
  List<StatsTrendModel> _trends = [];
  List<StatsComparisonModel> _comparison = [];
  StatsDistributionModel? _distribution;
  StatsPunctualityModel? _punctuality;
  Map<String, int> _methods = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      // Parallel fetching
      final results = await Future.wait([
        LecturerStatsService.getTrends(),
        LecturerStatsService.getComparison(),
        LecturerStatsService.getDistribution(),
        LecturerStatsService.getPunctuality(),
        LecturerStatsService.getMethods(),
      ]);

      setState(() {
        _trends = results[0] as List<StatsTrendModel>;
        _comparison = results[1] as List<StatsComparisonModel>;
        _distribution = results[2] as StatsDistributionModel;
        _punctuality = results[3] as StatsPunctualityModel;
        _methods = results[4] as Map<String, int>;
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
        title: const Text('Statistik & Analitik'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
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
          _buildPunctualityCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Tren Kehadiran Mingguan'),
          const SizedBox(height: 16),
          _buildTrendChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Perbandingan Kelas'),
          const SizedBox(height: 16),
          _buildComparisonChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Distribusi Performa Mahasiswa'),
          const SizedBox(height: 16),
          _buildDistributionChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Status Kehadiran (Semester Ini)'),
          const SizedBox(height: 16),
          _buildMethodChart(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // --- Charts ---

  Widget _buildPunctualityCard() {
    if (_punctuality == null) return const SizedBox.shrink();
    final total = _punctuality!.onTime + _punctuality!.late;
    final onTimePct = total > 0 ? (_punctuality!.onTime / total * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_filled,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ketepatan Waktu',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '${onTimePct.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_punctuality!.late} Mahasiswa terlambat',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    if (_trends.isEmpty)
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Tidak ada data tren')),
      );

    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: const Color(0xffe7e8ec), strokeWidth: 1),
              getDrawingVerticalLine: (value) =>
                  FlLine(color: const Color(0xffe7e8ec), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < _trends.length) {
                      return Text(
                        _trends[index].week.toString().substring(4),
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (_trends.length - 1).toDouble(),
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: _trends.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.rate);
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    if (_comparison.isEmpty)
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Tidak ada data kelas')),
      );

    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < _comparison.length) {
                        // Simplify name for X axis
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _comparison[index].classCode,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: _comparison.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.attendanceRate,
                      color: e.value.attendanceRate > 80
                          ? Colors.green
                          : (e.value.attendanceRate > 50
                                ? Colors.orange
                                : Colors.red),
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributionChart() {
    if (_distribution == null) return const SizedBox.shrink();

    return Row(
      children: [
        _buildDistItem('Tinggi (>90%)', _distribution!.high, Colors.green),
        const SizedBox(width: 8),
        _buildDistItem('Sedang (75-90%)', _distribution!.medium, Colors.orange),
        const SizedBox(width: 8),
        _buildDistItem('Rendah (<75%)', _distribution!.low, Colors.red),
      ],
    );
  }

  Widget _buildDistItem(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodChart() {
    if (_methods.isEmpty) return const SizedBox.shrink();

    // Convert map to list for chart
    List<PieChartSectionData> sections = [];
    final total = _methods.values.fold(0, (sum, val) => sum + val);

    int index = 0;
    _methods.forEach((key, value) {
      final color = [Colors.blue, Colors.purple, Colors.teal][index % 3];
      final pct = total > 0 ? (value / total * 100) : 0;

      sections.add(
        PieChartSectionData(
          color: color,
          value: value.toDouble(),
          title: '${pct.toStringAsFixed(0)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ),
    );
  }
}
