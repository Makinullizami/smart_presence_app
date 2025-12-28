import 'package:flutter/material.dart';
import '../models/lecturer_dashboard_model.dart';
import '../services/lecturer_service.dart';

/// Lecturer Home State
enum LecturerHomeState { initial, loading, success, error }

/// Lecturer Home Controller - Manages lecturer dashboard data and state
class LecturerHomeController with ChangeNotifier {
  LecturerHomeState _state = LecturerHomeState.initial;
  LecturerDashboardModel? _dashboard;
  List<LecturerClassModel> _classes = [];
  String? _errorMessage;

  // Getters
  LecturerHomeState get state => _state;
  LecturerDashboardModel? get dashboard => _dashboard;
  List<LecturerClassModel> get classes => _classes;
  String? get errorMessage => _errorMessage;

  /// Load dashboard data
  Future<void> loadDashboard() async {
    _state = LecturerHomeState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboard = await LecturerService.fetchDashboard();
      _state = LecturerHomeState.success;
    } catch (e) {
      _state = LecturerHomeState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Load lecturer's classes
  Future<void> loadClasses() async {
    try {
      _classes = await LecturerService.fetchLecturerClasses();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load all data (dashboard + classes)
  Future<void> loadAll() async {
    _state = LecturerHomeState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([loadDashboard(), loadClasses()]);
      _state = LecturerHomeState.success;
    } catch (e) {
      _state = LecturerHomeState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Open attendance session for a class
  Future<bool> openAttendanceSession(int classId) async {
    try {
      final session = await LecturerService.openAttendanceSession(classId);

      // Update class in list
      final index = _classes.indexWhere((c) => c.id == classId);
      if (index != -1) {
        _classes[index] = LecturerClassModel(
          id: _classes[index].id,
          name: _classes[index].name,
          code: _classes[index].code,
          studentCount: _classes[index].studentCount,
          hasActiveSession: true,
          activeSessionId: session.id,
          createdAt: _classes[index].createdAt,
        );
      }

      // Update dashboard active sessions count
      if (_dashboard != null) {
        _dashboard = LecturerDashboardModel(
          totalClasses: _dashboard!.totalClasses,
          totalStudents: _dashboard!.totalStudents,
          activeSessions: _dashboard!.activeSessions + 1,
          attendanceStats: _dashboard!.attendanceStats,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Close attendance session
  Future<bool> closeAttendanceSession(int sessionId, int classId) async {
    try {
      await LecturerService.closeAttendanceSession(sessionId);

      // Update class in list
      final index = _classes.indexWhere((c) => c.id == classId);
      if (index != -1) {
        _classes[index] = LecturerClassModel(
          id: _classes[index].id,
          name: _classes[index].name,
          code: _classes[index].code,
          studentCount: _classes[index].studentCount,
          hasActiveSession: false,
          activeSessionId: null,
          createdAt: _classes[index].createdAt,
        );
      }

      // Update dashboard active sessions count
      if (_dashboard != null) {
        _dashboard = LecturerDashboardModel(
          totalClasses: _dashboard!.totalClasses,
          totalStudents: _dashboard!.totalStudents,
          activeSessions: _dashboard!.activeSessions - 1,
          attendanceStats: _dashboard!.attendanceStats,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAll();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _state = LecturerHomeState.initial;
    _dashboard = null;
    _classes = [];
    _errorMessage = null;
    notifyListeners();
  }
}
