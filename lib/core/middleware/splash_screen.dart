import 'package:flutter/material.dart';
import 'auth_guard.dart';
import '../../routes/app_routes.dart';

/// Splash Screen with Authentication Check
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Check authentication and navigate accordingly
      await AuthGuard.checkAndNavigate(
        context,
        onAuthenticated: AppRoutes.home,
        onUnauthenticated: AppRoutes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.fingerprint,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              'Smart Presence',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),

            // Loading Indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
