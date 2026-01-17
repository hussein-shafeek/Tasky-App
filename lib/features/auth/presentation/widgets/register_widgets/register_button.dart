import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController addressController;
  final TextEditingController experienceYearsController;
  final TextEditingController experienceLevelController;
  final String fullPhone;

  final bool Function()? onValidatePhone;

  const RegisterButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.passwordController,
    required this.addressController,
    required this.experienceYearsController,
    required this.experienceLevelController,
    required this.fullPhone,
    this.onValidatePhone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is RegisterLoading;

        return DefaultElevatedButton(
          label: 'Sign Up',
          isLoading: isLoading,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          onPressed: () {
            FocusScope.of(context).unfocus();

            final isFormValid = formKey.currentState?.validate() ?? false;

            final phoneValid = onValidatePhone?.call() ?? true;

            if (!isFormValid || !phoneValid) return;

            final request = RegisterRequest(
              phone: fullPhone.isEmpty
                  ? '+20${phoneController.text}'
                  : fullPhone,
              password: passwordController.text,
              displayName: nameController.text.trim(),
              experienceYears:
                  int.tryParse(experienceYearsController.text) ?? 1,
              address: addressController.text.trim(),
              experienceLevel: ExperienceLevel.fromName(
                experienceLevelController.text,
              ),
            );

            context.read<AuthCubit>().register(request);
          },
        );
      },
    );
  }
}
