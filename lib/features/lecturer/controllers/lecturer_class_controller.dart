import 'package:flutter/material.dart';
import '../models/lecturer_dashboard_model.dart';
import '../services/lecturer_class_service.dart';

/// Lecturer Class State
enum LecturerClassState { loading, success, empty, error }

/// Lecturer Class Controller
/// Manages lecturer class list state
class LecturerClassController extends ChangeNotifier {
  LecturerClassState _state = LecturerClassState.loading;
  List<LecturerClassModel> _classes = [];
  String? _errorMessage;

  // Getters
  LecturerClassState get state => _state;
  List<LecturerClassModel> get classes => _classes;
  String? get errorMessage => _errorMessage;

  /// Load classes
  Future<void> loadClasses() async {
    _state = LecturerClassState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await LecturerClassService.fetchClasses();

      if (_classes.isEmpty) {
        _state = LecturerClassState.empty;
      } else {
        _state = LecturerClassState.success;
      }
    } catch (e) {
      _state = LecturerClassState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  /// Refresh classes
  Future<void> refresh() async {
    await loadClasses();
  }
}
