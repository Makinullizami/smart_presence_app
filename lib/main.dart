import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_routes.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Presence',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Start with splash screen
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
