import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:tasky_app/core/di/dependency_injection.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tasky_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tasky_app/features/home/ui/home_screen.dart';

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
      initialLocation: Routes.loginScreen,

      // redirect: (context, state) {
      //   final authState = context.read<AuthCubit>().state;
      //   final isLogin = state.matchedLocation == Routes.loginScreen;
      //   final isRegister = state.matchedLocation == Routes.registerScreen;

      //   if (authState is LoginError && !isLogin && !isRegister) {
      //     return Routes.loginScreen;
      //   }

      //   if (authState is LoginSuccess && (isLogin || isRegister)) {
      //     return Routes.homeScreen;
      //   }

      //   return null;
      // },
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
            return BlocProvider<TaskCubit>(
              create: (context) => getIt<TaskCubit>()..fetchTasks(),
              child: const HomeScreen(),
            );
          },
        ),
      ],
    );
  }
}
