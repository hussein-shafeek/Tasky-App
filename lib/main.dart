import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/di/dependency_injection.dart';
//import 'package:tasky_app/core/di/injection.dart';
import 'package:tasky_app/core/routes/app_router.dart';
import 'package:tasky_app/core/cubit/bloc_observer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/resources/theme_manager.dart';

bool? showOnboarding;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await setupDependencyInjection();
  final token = getIt.get<SharedPreferences>().getString('token');
  showOnboarding =
      getIt.get<SharedPreferences>().getBool('onboarding_shown') ?? false;

  //await configureDependencies();

  runApp(DevicePreview(enabled: false, builder: (context) => TaskyApp()));
}

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.CustomeLightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router(),
      ),
    );
  }
}
