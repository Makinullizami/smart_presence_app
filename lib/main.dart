import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/attendance/controllers/attendance_controller.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => AttendanceController()),
        // ClassController is instantiated in ClassListPage, but can be global if needed.
        // For now, I only strictly need ProfileController to be global for the ClassDetailPage check.
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Presence',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        // Start with splash screen
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
