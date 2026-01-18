import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:tasky_app/features/home/presentation/cubit/get_tasks_cubit.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_cubit_old.dart';
import 'package:tasky_app/core/di/dependency_injection.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tasky_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tasky_app/features/home/presentation/screens/home_screen.dart';
import 'package:tasky_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tasky_app/features/profile/presentation/screens/profile_screen.dart';

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

        return Routes.homeScreen;
      },
      routes: [
        GoRoute(
          path: Routes.loginScreen,
          builder: (context, state) {
            return BlocProvider<AuthCubit>(
              create: (context) => getIt.get<AuthCubit>(),
              child: const LoginScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.registerScreen,
          builder: (context, state) {
            return BlocProvider<AuthCubit>(
              create: (context) => getIt.get<AuthCubit>(),
              child: const RegisterScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.homeScreen,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<GetTasksCubit>(
                  create: (_) => getIt<GetTasksCubit>()..fetchTasks(),
                ),
                BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
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
              child: ProfileScreen(),
            );
          },
        ),
      ],
    );
  }
}
