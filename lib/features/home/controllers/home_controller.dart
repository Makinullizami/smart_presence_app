import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_api.dart';

/// Dashboard State
enum DashboardState { loading, success, error }

/// Home Controller
/// Manages dashboard data and state
class HomeController extends ChangeNotifier {
  DashboardState _state = DashboardState.loading;
  DashboardModel? _dashboard;
  String? _errorMessage;

  DashboardState get state => _state;
  DashboardModel? get dashboard => _dashboard;
  String? get errorMessage => _errorMessage;

  /// Load dashboard data
  Future<void> loadDashboard() async {
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await DashboardApi.fetchDashboard();
      _dashboard = DashboardModel.fromJson(data);
      _state = DashboardState.success;
    } catch (e) {
      _state = DashboardState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Check if token expired
      if (_errorMessage!.contains('Unauthorized') ||
          _errorMessage!.contains('401')) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      }
    } finally {
      notifyListeners();
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboard();
  }

  /// Clear data
  void clear() {
    _dashboard = null;
    _state = DashboardState.loading;
    _errorMessage = null;
    notifyListeners();
  }
}
