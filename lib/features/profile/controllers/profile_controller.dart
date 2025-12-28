import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../services/profile_service.dart';

/// Profile State
enum ProfileState { initial, loading, loaded, error }

/// Profile Controller
class ProfileController extends ChangeNotifier {
  ProfileState _state = ProfileState.initial;
  UserModel? _user;
  String? _errorMessage;

  ProfileState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  /// Load user profile
  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ProfileService.getProfile();
      _state = ProfileState.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ProfileState.error;
    }

    notifyListeners();
  }

  /// Update profile
  Future<bool> updateProfile({
    required String name,
    String? photo,
    String? nim,
    String? faculty,
    String? major,
  }) async {
    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await ProfileService.updateProfile(
        name: name,
        photo: photo,
        nim: nim,
        faculty: faculty,
        major: major,
      );

      _state = ProfileState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ProfileState.error;
      notifyListeners();
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await ProfileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      _state = ProfileState.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ProfileState.error;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<bool> logout() async {
    try {
      await ProfileService.logout();
      _user = null;
      _state = ProfileState.initial;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await loadProfile();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == ProfileState.error) {
      _state = ProfileState.loaded;
    }
    notifyListeners();
  }
}
