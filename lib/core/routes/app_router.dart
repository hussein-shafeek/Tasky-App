import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/services/todo_service.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';
import 'package:tasky_app/features/auth/logic/auth_cubit.dart';
import 'package:tasky_app/features/auth/logic/auth_state.dart';
import 'package:tasky_app/features/auth/ui/login_screen.dart';
import 'package:tasky_app/features/auth/ui/register_screen.dart';
import 'package:tasky_app/features/home/ui/home_screen.dart';

class AppRouter {
  static Widget withProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthService())..checkAuthStatus(),
        ),
        BlocProvider<TaskCubit>(
          create: (_) => TaskCubit(TodoService())..fetchTasks(),
        ),
      ],
      child: child,
    );
  }

  static GoRouter router() {
    return GoRouter(
      initialLocation: Routes.loginScreen,

      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;
        final isLogin = state.matchedLocation == Routes.loginScreen;
        final isRegister = state.matchedLocation == Routes.registerScreen;

        if (authState is AuthUnauthenticated && !isLogin && !isRegister) {
          return Routes.loginScreen;
        }

        if (authState is AuthAuthenticated && (isLogin || isRegister)) {
          return Routes.homeScreen;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: Routes.loginScreen,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Routes.registerScreen,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: Routes.homeScreen,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
