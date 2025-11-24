import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/providers/task_provider.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/core/theme/app_theme.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';
import 'package:tasky_app/features/auth/ui/login_screen.dart';
import 'package:tasky_app/features/auth/ui/register_screen.dart';
import 'package:tasky_app/features/home/data/qr_scanner_screen.dart';
import 'package:tasky_app/features/home/ui/home_screen.dart';
import 'package:tasky_app/features/onboarding/ui/onboarding_screen.dart';
import 'package:tasky_app/features/profile/ui/profile_screen.dart';
import 'package:tasky_app/features/tasks/ui/add_new_task_screen.dart';
import 'package:tasky_app/features/tasks/ui/task_details_screen.dart';

void main() async {
  final todoService = TodoService();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TaskProvider(todoService: todoService),
          ),
        ],
        child: const TaskyApp(),
      ),
    ),
  );
}

class TaskyApp extends StatefulWidget {
  const TaskyApp({super.key});

  @override
  State<TaskyApp> createState() => _TaskyAppState();
}

class _TaskyAppState extends State<TaskyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboardingScreen,
      theme: AppTheme.CustomeLightTheme,
      themeMode: ThemeMode.light,
      routes: {
        AppRoutes.onboardingScreen: (_) => OnboardingScreen(),
        AppRoutes.loginScreen: (_) => LoginScreen(),
        AppRoutes.registerScreen: (_) => RegisterScreen(),
        AppRoutes.homeScreen: (_) => HomeScreen(),
        AppRoutes.taskDetailsScreen: (context) {
          final taskId = ModalRoute.of(context)!.settings.arguments as String;
          return TaskDetailsScreen(taskId: taskId);
        },
        AppRoutes.addTask: (_) => AddNewTaskScreen(),
        AppRoutes.profileScreen: (_) => ProfileScreen(),
        AppRoutes.qrScanner: (_) => QRScannerScreen(),
      },
    );
  }
}
