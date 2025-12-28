import 'package:flutter/material.dart';
import '../core/middleware/splash_screen.dart';
import '../core/widgets/main_scaffold.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/classes/pages/class_detail_page.dart';
import '../features/lecturer/pages/lecturer_home_page.dart';
import '../features/attendance/pages/attendance_face_page.dart';
import '../features/attendance/pages/attendance_pin_page.dart';
import '../features/attendance/pages/attendance_qr_page.dart';
import '../features/attendance/pages/attendance_history_page.dart';
import '../features/attendance/pages/attendance_success_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
import '../features/profile/pages/change_password_page.dart';

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
  static const String classDetail = '/classes/detail';

  // Attendance routes
  static const String attendance = '/attendance';
  static const String attendanceFace = '/attendance/face';
  static const String attendancePin = '/attendance/pin';
  static const String attendanceQr = '/attendance/qr';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceSuccess = '/attendance/success';

  // Profile routes
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profilePassword = '/profile/password';

  // Lecturer routes
  static const String lecturerHome = '/lecturer/home';
  static const String lecturerClassDetail = '/lecturer/class/detail';

  /// Get all routes
  /// Note: /home and /classes routes are protected by AuthGuard
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const MainScaffold(initialIndex: 0),
      classes: (context) => const MainScaffold(initialIndex: 1),
      classDetail: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as int?;
        return ClassDetailPage(classId: args ?? 0);
      },

      // Attendance routes
      attendance: (context) => const MainScaffold(initialIndex: 2),
      attendanceFace: (context) => const AttendanceFacePage(),
      attendancePin: (context) => const AttendancePinPage(),
      attendanceQr: (context) => const AttendanceQrPage(),
      attendanceHistory: (context) => const AttendanceHistoryPage(),
      attendanceSuccess: (context) => const AttendanceSuccessPage(),

      // Profile routes
      profile: (context) => const MainScaffold(initialIndex: 3),
      profileEdit: (context) => const EditProfilePage(),
      profilePassword: (context) => const ChangePasswordPage(),

      // Lecturer routes
      lecturerHome: (context) => const LecturerHomePage(),
      lecturerClassDetail: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as int?;
        return ClassDetailPage(classId: args ?? 0);
      },
    };
  }

  /// Navigation helpers
  static void toLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void toRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void toHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void toClasses(BuildContext context) {
    Navigator.pushNamed(context, classes);
  }

  // Attendance navigation helpers
  static void toAttendance(BuildContext context) {
    Navigator.pushNamed(context, attendance);
  }

  static void toAttendanceFace(BuildContext context) {
    Navigator.pushNamed(context, attendanceFace);
  }

  static void toAttendancePin(BuildContext context) {
    Navigator.pushNamed(context, attendancePin);
  }

  static void toAttendanceQr(BuildContext context) {
    Navigator.pushNamed(context, attendanceQr);
  }

  static void toAttendanceHistory(BuildContext context) {
    Navigator.pushNamed(context, attendanceHistory);
  }

  static void toAttendanceSuccess(
    BuildContext context, {
    required String type, // 'check-in' or 'check-out'
    required String method,
    required String time,
  }) {
    Navigator.pushReplacementNamed(
      context,
      attendanceSuccess,
      arguments: {'type': type, 'method': method, 'time': time},
    );
  }
}
