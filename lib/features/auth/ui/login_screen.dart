import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/auth/logic/auth_cubit.dart';
import 'package:tasky_app/features/auth/logic/auth_state.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';
import 'package:tasky_app/core/utils/default_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String fullPhone = '';
  String? phoneError;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Loading handled locally with setState
        } else if (state is AuthSuccess) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text("Login successful"),
          //     backgroundColor: AppColors.green,
          //   ),
          // );
          context.go(Routes.homeScreen);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.coral,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/art.png',
                    fit: BoxFit.fill,
                    height: height * 0.5394,
                  ),
                  SizedBox(height: height * 0.005),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login', style: text.headlineSmall),
                        SizedBox(height: height * 0.02955),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: text.copyWith(
                              titleMedium: text.titleMedium!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          child: IntlPhoneField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            initialCountryCode: 'EG',
                            dropdownIconPosition: IconPosition.trailing,
                            dropdownIcon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.grayMedium,
                            ),
                            flagsButtonMargin: const EdgeInsets.only(left: 15),
                            dropdownTextStyle: text.titleSmall!.copyWith(
                              color: AppColors.grayMedium,
                              fontWeight: FontWeight.bold,
                            ),
                            style: text.titleMedium!.copyWith(
                              color: AppColors.black,
                            ),
                            pickerDialogStyle: PickerDialogStyle(
                              searchFieldInputDecoration: InputDecoration(
                                hintText: 'Search country',
                                hintStyle: text.titleSmall!.copyWith(
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            ),
                            onChanged: (phone) {
                              fullPhone = phone.completeNumber;
                              setState(() {
                                phoneError = null;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: text.titleSmall!.copyWith(
                                color: AppColors.grayMedium,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 12,
                              ),
                              errorText: phoneError,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.017),
                        DefaultTextFormField(
                          hintText: "Password...",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          controller: passwordController,
                          isPassword: true,
                        ),
                        SizedBox(height: height * 0.02955),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            bool isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : DefaultElevatedButton(
                                      label: 'Sign In',
                                      textStyle: text.titleMedium!.copyWith(
                                        color: AppColors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          phoneError =
                                              phoneController.text
                                                  .trim()
                                                  .isEmpty
                                              ? 'Phone number is required'
                                              : null;
                                        });
                                        bool isFormValid =
                                            formKey.currentState?.validate() ??
                                            false;

                                        if ((phoneError == null) &&
                                            isFormValid) {
                                          final authCubit = context
                                              .read<AuthCubit>();
                                          authCubit.login(
                                            phone: fullPhone.isEmpty
                                                ? '+20${phoneController.text}'
                                                : fullPhone,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                    ),
                            );
                          },
                        ),
                        SizedBox(height: height * 0.02955),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn’t have any account?',
                              style: text.titleMedium!.copyWith(
                                color: AppColors.grayMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(Routes.registerScreen);
                              },
                              child: Text('Sign Up here'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
