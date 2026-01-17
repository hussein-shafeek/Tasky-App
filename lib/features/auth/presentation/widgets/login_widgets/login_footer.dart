import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn’t have any account?',
          style: text.titleMedium!.copyWith(color: AppColors.grayMedium),
        ),
        TextButton(
          onPressed: () => context.push(Routes.registerScreen),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
