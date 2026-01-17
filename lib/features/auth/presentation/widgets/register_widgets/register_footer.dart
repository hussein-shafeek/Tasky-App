import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have any account?',
          style: text.titleMedium!.copyWith(color: AppColors.grayMedium),
        ),
        TextButton(
          onPressed: () => context.go(Routes.loginScreen),
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}
