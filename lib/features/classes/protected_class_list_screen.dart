import 'package:flutter/material.dart';
import '../../core/middleware/auth_guard.dart';
import 'class_list_screen.dart';

/// Protected Class List Screen with Auth Guard
/// This wrapper ensures user is authenticated before accessing the class list
class ProtectedClassListScreen extends StatefulWidget {
  const ProtectedClassListScreen({super.key});

  @override
  State<ProtectedClassListScreen> createState() =>
      _ProtectedClassListScreenState();
}

class _ProtectedClassListScreenState extends State<ProtectedClassListScreen> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Check if user is authenticated
    await AuthGuard.requireAuth(context);

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking authentication
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If authenticated, show the class list screen
    return const ClassListScreen();
  }
}
