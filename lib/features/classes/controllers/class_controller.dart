import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../services/class_service.dart';

/// Class State
enum ClassState { initial, loading, success, error }

/// Class Controller - Manages class data and state
class ClassController with ChangeNotifier {
  ClassState _state = ClassState.initial;
  List<ClassModel> _classes = [];
  ClassModel? _selectedClass;
  List<ScheduleModel> _schedules = [];
  AttendanceSummaryModel? _attendanceSummary;
  String? _errorMessage;

  // Getters
  ClassState get state => _state;
  List<ClassModel> get classes => _classes;
  ClassModel? get selectedClass => _selectedClass;
  List<ScheduleModel> get schedules => _schedules;
  AttendanceSummaryModel? get attendanceSummary => _attendanceSummary;
  String? get errorMessage => _errorMessage;

  /// Load all classes
  Future<void> loadClasses() async {
    _state = ClassState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await ClassService.fetchClasses();
      _state = ClassState.success;
    } catch (e) {
      _state = ClassState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Load class detail
  Future<void> loadClassDetail(int classId) async {
    _state = ClassState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedClass = await ClassService.fetchClassDetail(classId);
      _state = ClassState.success;
    } catch (e) {
      _state = ClassState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Load class schedules
  Future<void> loadSchedules(int classId) async {
    try {
      _schedules = await ClassService.fetchClassSchedule(classId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load attendance summary
  Future<void> loadAttendanceSummary(int classId, int userId) async {
    try {
      _attendanceSummary = await ClassService.fetchAttendanceSummary(
        classId,
        userId,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Refresh classes
  Future<void> refresh() async {
    await loadClasses();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _state = ClassState.initial;
    _classes = [];
    _selectedClass = null;
    _schedules = [];
    _attendanceSummary = null;
    _errorMessage = null;
    notifyListeners();
  }
}
