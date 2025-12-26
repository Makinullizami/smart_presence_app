import 'package:flutter/material.dart';
import '../core/middleware/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/pages/home_page.dart';
import '../features/classes/protected_class_list_screen.dart';

/// Application Routes Configuration
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  /// Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String classes = '/classes';

  /// Get all routes
  /// Note: /home and /classes routes are protected by AuthGuard
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomePage(),
      classes: (context) => const ProtectedClassListScreen(),
    };
  }

  /// Navigation helpers
  static void toLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void toRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void toClasses(BuildContext context) {
    Navigator.pushNamed(context, classes);
  }
}
