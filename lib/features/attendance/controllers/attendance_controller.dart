import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

/// Attendance State
enum AttendanceState { initial, loading, loaded, error }

/// Attendance Controller
class AttendanceController extends ChangeNotifier {
  AttendanceState _state = AttendanceState.initial;
  AttendanceModel? _attendance;
  String? _errorMessage;
  AttendanceMethod? _selectedMethod;

  AttendanceState get state => _state;
  AttendanceModel? get attendance => _attendance;
  String? get errorMessage => _errorMessage;
  AttendanceMethod? get selectedMethod => _selectedMethod;

  bool get canCheckIn => _attendance?.canCheckIn ?? true;
  bool get canCheckOut => _attendance?.canCheckOut ?? false;
  bool get isCompleted =>
      _attendance?.status == AttendanceStatusEnum.checkedOut;

  /// Load today's attendance status
  Future<void> loadTodayAttendance() async {
    _state = AttendanceState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendance = await AttendanceService.getTodayAttendance();
      _state = AttendanceState.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = AttendanceState.error;
    }

    notifyListeners();
  }

  /// Select attendance method
  void selectMethod(AttendanceMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  /// Check-in
  Future<bool> checkIn({
    String? location,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_selectedMethod == null) {
      _errorMessage = 'Pilih metode absensi terlebih dahulu';
      notifyListeners();
      return false;
    }

    _state = AttendanceState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendance = await AttendanceService.checkIn(
        method: _selectedMethod!,
        location: location,
        additionalData: additionalData,
      );

      _state = AttendanceState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = AttendanceState.error;
      notifyListeners();
      return false;
    }
  }

  /// Check-out
  Future<bool> checkOut({Map<String, dynamic>? additionalData}) async {
    if (_selectedMethod == null) {
      _errorMessage = 'Pilih metode absensi terlebih dahulu';
      notifyListeners();
      return false;
    }

    _state = AttendanceState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendance = await AttendanceService.checkOut(
        method: _selectedMethod!,
        additionalData: additionalData,
      );

      _state = AttendanceState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = AttendanceState.error;
      notifyListeners();
      return false;
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadTodayAttendance();
  }

  /// Reset error
  void clearError() {
    _errorMessage = null;
    if (_state == AttendanceState.error) {
      _state = AttendanceState.loaded;
    }
    notifyListeners();
  }
}
