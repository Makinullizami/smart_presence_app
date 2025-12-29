import 'package:flutter/material.dart';
import '../controllers/lecturer_attendance_monitor_controller.dart';

/// Attendance Filter Bar
/// Search and filter chips
class AttendanceFilterBar extends StatefulWidget {
  final FilterStatus currentFilter;
  final String searchQuery;
  final Function(FilterStatus) onFilterChanged;
  final Function(String) onSearchChanged;

  const AttendanceFilterBar({
    super.key,
    required this.currentFilter,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  State<AttendanceFilterBar> createState() => _AttendanceFilterBarState();
}

class _AttendanceFilterBarState extends State<AttendanceFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari mahasiswa (Nama atau NIM)',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                suffixIcon: widget.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Semua',
                  FilterStatus.all,
                  widget.currentFilter == FilterStatus.all,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Hadir',
                  FilterStatus.present,
                  widget.currentFilter == FilterStatus.present,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Terlambat',
                  FilterStatus.late,
                  widget.currentFilter == FilterStatus.late,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Belum Hadir',
                  FilterStatus.absent,
                  widget.currentFilter == FilterStatus.absent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, FilterStatus status, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onFilterChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade700 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.shade700.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
