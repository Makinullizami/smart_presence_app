import 'package:flutter/material.dart';
import '../storage/token_storage.dart';
import '../services/api_service.dart';

/// Auth Guard Middleware for checking authentication status
class AuthGuard {
  // Private constructor to prevent instantiation
  AuthGuard._();

  /// Check if user is authenticated
  ///
  /// Returns true if user has a valid token, false otherwise
  static Future<bool> isAuthenticated() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Set token in ApiService for subsequent requests
        ApiService.setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check authentication and navigate accordingly
  ///
  /// [context] - BuildContext for navigation
  /// [onAuthenticated] - Route to navigate if authenticated
  /// [onUnauthenticated] - Route to navigate if not authenticated
  ///
  /// This method checks if user is authenticated and navigates to the appropriate route
  static Future<void> checkAndNavigate(
    BuildContext context, {
    required String onAuthenticated,
    required String onUnauthenticated,
  }) async {
    final isAuth = await isAuthenticated();

    if (context.mounted) {
      if (isAuth) {
        Navigator.pushReplacementNamed(context, onAuthenticated);
      } else {
        Navigator.pushReplacementNamed(context, onUnauthenticated);
      }
    }
  }

  /// Get initial route based on authentication status
  ///
  /// [authenticatedRoute] - Route to return if authenticated (default: '/home')
  /// [unauthenticatedRoute] - Route to return if not authenticated (default: '/login')
  ///
  /// Returns the appropriate route based on authentication status
  /// This is useful for setting the initial route in MaterialApp
  static Future<String> getInitialRoute({
    String authenticatedRoute = '/home',
    String unauthenticatedRoute = '/login',
  }) async {
    final isAuth = await isAuthenticated();
    return isAuth ? authenticatedRoute : unauthenticatedRoute;
  }

  /// Require authentication for a route
  ///
  /// [context] - BuildContext for navigation
  /// [loginRoute] - Route to navigate if not authenticated (default: '/login')
  ///
  /// Returns true if authenticated, false if redirected to login
  /// Use this in initState or build method of protected screens
  static Future<bool> requireAuth(
    BuildContext context, {
    String loginRoute = '/login',
  }) async {
    final isAuth = await isAuthenticated();

    if (!isAuth && context.mounted) {
      Navigator.pushReplacementNamed(context, loginRoute);
      return false;
    }

    return true;
  }

  /// Clear authentication and logout
  ///
  /// [context] - BuildContext for navigation
  /// [loginRoute] - Route to navigate after logout (default: '/login')
  static Future<void> logout(
    BuildContext context, {
    String loginRoute = '/login',
  }) async {
    // Clear token from storage
    await TokenStorage.clearToken();

    // Clear token from ApiService
    ApiService.clearToken();

    // Navigate to login
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, loginRoute);
    }
  }
}
