import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/routes/app_router.dart';
import 'package:tasky_app/features/auth/logic/auth_cubit.dart';
import 'package:tasky_app/core/cubit/bloc_observer.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
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
import 'package:tasky_app/features/tasks/ui/edit_task.dart';
import 'package:tasky_app/features/tasks/ui/task_details_screen.dart';

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
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthService())),
          BlocProvider<TaskCubit>(
            create: (_) => TaskCubit(TodoService())..fetchTasks(),
          ),
        ],
        child: TaskyApp(token: token, showOnboarding: showOnboarding),
      ),
    ),
  );
}

class TaskyApp extends StatelessWidget {
  final bool? showOnboarding;
  final String? token;
  const TaskyApp({
    super.key,
    required this.showOnboarding,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.CustomeLightTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router(
        showOnboarding: showOnboarding ?? false,
        token: token,
      ),
    );
  }
}
