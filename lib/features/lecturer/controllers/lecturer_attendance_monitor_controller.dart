import 'dart:async';
import 'package:flutter/material.dart';
import '../models/attendance_session_model.dart';
import '../models/student_attendance_model.dart';
import '../models/attendance_stats_model.dart';
import '../services/lecturer_attendance_service.dart';

/// Attendance Monitor State
enum AttendanceMonitorState { loading, active, closed, error }

/// Filter Status
enum FilterStatus { all, present, late, absent }

/// Lecturer Attendance Monitor Controller
/// Manages realtime attendance monitoring with polling
class LecturerAttendanceMonitorController extends ChangeNotifier {
  AttendanceMonitorState _state = AttendanceMonitorState.loading;
  AttendanceSessionModel? _session;
  List<StudentAttendanceModel> _allStudents = [];
  List<StudentAttendanceModel> _filteredStudents = [];
  AttendanceStatsModel? _stats;
  String? _errorMessage;

  // Filter and search
  FilterStatus _filterStatus = FilterStatus.all;
  String _searchQuery = '';

  // Polling
  Timer? _pollingTimer;
  final int _pollingInterval = 5; // seconds
  Set<int> _previousStudentIds = {};

  // Getters
  AttendanceMonitorState get state => _state;
  AttendanceSessionModel? get session => _session;
  List<StudentAttendanceModel> get students => _filteredStudents;
  AttendanceStatsModel? get stats => _stats;
  String? get errorMessage => _errorMessage;
  FilterStatus get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  /// Load session data
  Future<void> loadSession(int sessionId) async {
    _state = AttendanceMonitorState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await LecturerAttendanceService.fetchSessionDetails(
        sessionId,
      );
      final parsed = LecturerAttendanceService.parseSessionResponse(response);

      _session = parsed['session'];
      _allStudents = parsed['students'];
      _stats = parsed['stats'];

      // Mark new students
      _markNewStudents();

      // Apply filters
      _applyFilters();

      _state = _session!.isActive
          ? AttendanceMonitorState.active
          : AttendanceMonitorState.closed;

      // Start polling if session is active
      if (_session!.isActive) {
        _startPolling(sessionId);
      }
    } catch (e) {
      _state = AttendanceMonitorState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  /// Start polling for updates
  void _startPolling(int sessionId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      Duration(seconds: _pollingInterval),
      (_) => _pollUpdates(sessionId),
    );
  }

  /// Poll for updates
  Future<void> _pollUpdates(int sessionId) async {
    if (_state != AttendanceMonitorState.active) {
      _stopPolling();
      return;
    }

    try {
      final response = await LecturerAttendanceService.fetchSessionDetails(
        sessionId,
      );
      final parsed = LecturerAttendanceService.parseSessionResponse(response);

      final newSession = parsed['session'] as AttendanceSessionModel;
      final newStudents = parsed['students'] as List<StudentAttendanceModel>;
      final newStats = parsed['stats'] as AttendanceStatsModel;

      // Check if session was closed
      if (!newSession.isActive) {
        _session = newSession;
        _state = AttendanceMonitorState.closed;
        _stopPolling();
        notifyListeners();
        return;
      }

      // Update data
      _session = newSession;
      _allStudents = newStudents;
      _stats = newStats;

      // Mark new students
      _markNewStudents();

      // Apply filters
      _applyFilters();

      notifyListeners();
    } catch (e) {
      // Silent fail for polling errors
      debugPrint('Polling error: $e');
    }
  }

  /// Mark new students (students that weren't in previous poll)
  void _markNewStudents() {
    final currentIds = _allStudents
        .where((s) => s.status != 'absent')
        .map((s) => s.studentId)
        .toSet();

    for (var i = 0; i < _allStudents.length; i++) {
      final student = _allStudents[i];
      if (student.status != 'absent' &&
          !_previousStudentIds.contains(student.studentId)) {
        _allStudents[i] = student.copyWith(isNew: true);
      } else {
        _allStudents[i] = student.copyWith(isNew: false);
      }
    }

    _previousStudentIds = currentIds;
  }

  /// Stop polling
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Manual refresh
  Future<void> refresh(int sessionId) async {
    await loadSession(sessionId);
  }

  /// Set filter status
  void setFilter(FilterStatus status) {
    _filterStatus = status;
    _applyFilters();
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters and search
  void _applyFilters() {
    var filtered = List<StudentAttendanceModel>.from(_allStudents);

    // Apply status filter
    if (_filterStatus != FilterStatus.all) {
      final statusString = _filterStatus.toString().split('.').last;
      filtered = filtered.where((s) => s.status == statusString).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) {
        return s.name.toLowerCase().contains(_searchQuery) ||
            s.nim.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    _filteredStudents = filtered;
  }

  /// Close session
  Future<bool> closeSession(int sessionId) async {
    try {
      await LecturerAttendanceService.closeSession(sessionId);

      // Update state
      _state = AttendanceMonitorState.closed;
      if (_session != null) {
        _session = AttendanceSessionModel(
          id: _session!.id,
          classId: _session!.classId,
          className: _session!.className,
          classCode: _session!.classCode,
          startTime: _session!.startTime,
          endTime: DateTime.now().toString(),
          isActive: false,
          totalStudents: _session!.totalStudents,
        );
      }

      _stopPolling();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
