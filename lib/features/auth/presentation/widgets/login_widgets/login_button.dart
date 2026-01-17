import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final String fullPhone;
  final TextTheme textTheme;
  final bool Function()? onValidatePhone;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.fullPhone,
    required this.textTheme,
    this.onValidatePhone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return SizedBox(
          width: double.infinity,
          child: DefaultElevatedButton(
            label: 'Sign In',
            textStyle: textTheme.titleMedium!.copyWith(color: AppColors.white),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            isLoading: isLoading,
            onPressed: () {
              FocusScope.of(context).unfocus();

              final formValid = formKey.currentState?.validate() ?? false;
              final phoneValid = onValidatePhone?.call() ?? true;

              if (!formValid || !phoneValid) return;

              context.read<AuthCubit>().login(
                LoginRequest(
                  phone: fullPhone.isEmpty
                      ? '+20${phoneController.text}'
                      : fullPhone,
                  password: passwordController.text,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
