import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_cubit.dart';
//import 'package:tasky_app/features/home/presentation/cubit/task_cubit_old.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/core/di/dependency_injection.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tasky_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tasky_app/features/home/presentation/screens/home_screen.dart';
import 'package:tasky_app/features/home/presentation/screens/qr_scanner_screen.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tasky_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:tasky_app/features/home/presentation/screens/task_details_screen.dart';
import 'package:tasky_app/features/home/presentation/screens/edit_task.dart';
import 'package:tasky_app/features/home/presentation/screens/add_new_task_screen.dart';

class AppRouter {
  // static Widget withProviders(Widget child) {
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider<AuthCubit>(create: (_) => getIt.get<AuthCubit>()),
  //       BlocProvider<TaskCubit>(
  //         create: (_) => getIt<TaskCubit>()..fetchTasks(),
  //       ),
  //     ],
  //     child: child,
  //   );
  // }

  static GoRouter router() {
    return GoRouter(
      initialLocation: Routes.homeScreen,

      redirect: (context, state) async {
        final token = await getIt.get<AuthLocalDataSource>().getToken();

        final isLogin = state.matchedLocation == Routes.loginScreen;
        final isRegister = state.matchedLocation == Routes.registerScreen;

        if (token == null && !isLogin && !isRegister) {
          return Routes.loginScreen;
        }

        if (token != null && (isLogin || isRegister)) {
          return Routes.homeScreen;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: Routes.loginScreen,
          builder: (context, state) {
            return BlocProvider.value(
              value: getIt<AuthCubit>(),
              child: const LoginScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.registerScreen,
          builder: (context, state) {
            return BlocProvider.value(
              value: getIt<AuthCubit>(),
              child: const RegisterScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.homeScreen,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: getIt<TasksCubit>()),
                BlocProvider.value(value: getIt<AuthCubit>()),
              ],
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.profileScreen,
          builder: (context, state) {
            return BlocProvider<ProfileCubit>(
              create: (context) => getIt<ProfileCubit>()..getProfile(),
              child: const ProfileScreen(),
            );
          },
        ),
        GoRoute(
          path: '/detailsScreen/:taskId',
          builder: (context, state) {
            final taskId = state.pathParameters['taskId']!;
            // return MultiBlocProvider(
            // providers: [
            //   BlocProvider.value(value: getIt<TasksCubit>()),
            //   BlocProvider<TaskCubitOld>(
            //     create: (_) => getIt<TaskCubitOld>(),
            //   ),
            // ],
            return BlocProvider.value(
              value: getIt<TasksCubit>(),
              child: TaskDetailsScreen(taskId: taskId),
            );
          },
        ),
        GoRoute(
          path: Routes.qrScanner,
          builder: (context, state) {
            return const QRScannerScreen();
          },
        ),
        GoRoute(
          path: Routes.addTask,
          builder: (context, state) {
            return BlocProvider.value(
              value: getIt<TasksCubit>(),
              child: const AddNewTaskScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.addTask,
          builder: (context, state) {
            return BlocProvider.value(
              value: getIt<TasksCubit>(),
              child: const AddNewTaskScreen(),
            );
          },
        ),
        GoRoute(
          path: "${Routes.editTaskScreen}/:taskId",
          name: Routes.editTaskScreen,
          builder: (context, state) {
            final taskId = state.pathParameters['taskId'];
            if (taskId == null) {
              return const Scaffold(
                body: Center(child: Text("Task ID is missing")),
              );
            }

            return BlocProvider.value(
              value: getIt<TasksCubit>(),
              child: EditTaskScreen(taskId: taskId),
            );
          },
        ),
      ],
    );
  }
}
