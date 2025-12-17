import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/auth/ui/login_screen.dart';
import 'package:tasky_app/features/auth/ui/register_screen.dart';
import 'package:tasky_app/features/home/data/qr_scanner_screen.dart';
import 'package:tasky_app/features/home/ui/home_screen.dart';
import 'package:tasky_app/features/onboarding/ui/onboarding_screen.dart';
import 'package:tasky_app/features/profile/ui/profile_screen.dart';
import 'package:tasky_app/features/tasks/ui/add_new_task_screen.dart';
import 'package:tasky_app/features/tasks/ui/edit_task.dart';
import 'package:tasky_app/features/tasks/ui/task_details_screen.dart';

import 'routes_name.dart';

class AppRouter {
  static GoRouter router({
    required bool showOnboarding,
    required String? token,
  }) {
    return GoRouter(
      initialLocation: _getInitialLocation(
        showOnboarding: showOnboarding,
        token: token,
      ),

      routes: [
        GoRoute(
          path: Routes.onboardingScreen,
          builder: (_, state) => OnboardingScreen(),
        ),

        GoRoute(path: Routes.loginScreen, builder: (_, state) => LoginScreen()),

        GoRoute(
          path: Routes.registerScreen,
          builder: (_, state) => RegisterScreen(),
        ),

        GoRoute(path: Routes.homeScreen, builder: (_, state) => HomeScreen()),

        GoRoute(
          path: '${Routes.taskDetailsScreen}/:id',
          builder: (context, state) {
            final taskId = state.pathParameters['id']!;
            return TaskDetailsScreen(taskId: taskId);
          },
        ),

        /// Edit Task
        GoRoute(
          path: '${Routes.editTaskScreen}/:id',
          builder: (context, state) {
            final taskId = state.pathParameters['id']!;
            return EditTaskScreen(taskId: taskId);
          },
        ),

        GoRoute(
          path: Routes.addTask,
          builder: (_, state) => const AddNewTaskScreen(),
        ),

        GoRoute(
          path: Routes.profileScreen,
          builder: (_, state) => ProfileScreen(),
        ),

        GoRoute(
          path: Routes.qrScanner,
          builder: (_, state) => QRScannerScreen(),
        ),
      ],
    );
  }

  static String _getInitialLocation({
    required bool showOnboarding,
    required String? token,
  }) {
    if (!showOnboarding) {
      return Routes.onboardingScreen;
    } else if (token != null && token.isNotEmpty) {
      return Routes.homeScreen;
    } else {
      return Routes.loginScreen;
    }
  }
}
