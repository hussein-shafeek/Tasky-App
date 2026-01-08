import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/utils/ui_utils.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String fullPhone = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          UIUtils.showLoading(context);
          //   // showDialog(
          //   //   context: context,
          //   //   barrierDismissible: false,
          //   //   builder: (_) => const Center(
          //   //     child: CircularProgressIndicator(color: AppColors.primary),
          //   //   ),
          //   // );
          // } else {
          //   context.pop(); // close loading if open
        } else if (state is LoginSuccess) {
          UIUtils.hideLoading(context);

          context.go(Routes.homeScreen);
        } else if (state is LoginError) {
          UIUtils.hideLoading(context);
          UIUtils.showMessage(state.message);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.message),
          //     backgroundColor: AppColors.coral,
          //   ),
          //);
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

                        // Theme(
                        //   data: Theme.of(context).copyWith(
                        //     textTheme: text.copyWith(
                        //       titleMedium: text.titleMedium!.copyWith(
                        //         color: AppColors.black,
                        //       ),
                        //    ),
                        // ),
                        IntlPhoneField(
                          controller: _phoneController,
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
                          },
                          validator: (phone) {
                            if (phone == null ||
                                phone.completeNumber.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            return null;
                          },

                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: text.titleSmall!.copyWith(
                              color: AppColors.grayMedium,
                            ),

                            // errorText: state is AuthValidationError
                            //     ? state.phoneError
                            //     : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 12,
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
                          controller: _passwordController,
                          isPassword: true,
                          // errorText: state is AuthValidationError
                          //       ? state.passwordError
                          //       : null,
                        ),
                        SizedBox(height: height * 0.02955),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            bool isLoading = state is LoginLoading;
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
                                        if (formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().login(
                                            LoginRequest(
                                              phone: fullPhone.isEmpty
                                                  ? '+20${_phoneController.text}'
                                                  : fullPhone,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                    ),
                            );
                          },

                          //             onPressed: () {
                          //               context.read<AuthCubit>().login(
                          //                 phone: fullPhone.isEmpty
                          //                     ? '+20${_phoneController.text}'
                          //                     : fullPhone,
                          //                 password: _passwordController.text,
                          //               );
                          //             },

                          //             backgroundColor: AppColors.primary,
                          //             foregroundColor: AppColors.white,
                          //           ),
                          //   );
                          // },
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

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
