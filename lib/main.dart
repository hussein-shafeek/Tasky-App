import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/core/routes/app_router.dart';
import 'package:tasky_app/features/auth/logic/auth_cubit.dart';
import 'package:tasky_app/core/cubit/bloc_observer.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/core/theme/app_theme.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';

bool? showOnboarding;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  showOnboarding = prefs.getBool('onboarding_shown') ?? false;
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => AppRouter.withProviders(TaskyApp()),
    ),
  );
}

final getIt = GetIt.instance;

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.CustomeLightTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router(),
    );
  }
}
