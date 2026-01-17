import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/auth/presentation/widgets/login_widgets/login_button.dart';
import 'package:tasky_app/features/auth/presentation/widgets/login_widgets/login_footer.dart';
import 'package:tasky_app/features/auth/presentation/widgets/login_widgets/login_header.dart';
import 'package:tasky_app/features/auth/presentation/widgets/login_widgets/login_password_field.dart';
import 'package:tasky_app/features/auth/presentation/widgets/login_widgets/login_phone_field.dart';
import 'package:tasky_app/core/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/routes/routes_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String fullPhone = '';

  final _phoneFieldKey = GlobalKey<LoginPhoneFieldState>();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go(Routes.homeScreen);
        } else if (state is LoginError) {
          UIUtils.showMessage(state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LoginHeader(),
                  Padding(
                    padding: 24.5.pHorizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login', style: text.headlineSmall),
                        SizedBox(height: 24.h),

                        // ===== PHONE =====
                        LoginPhoneField(
                          key: _phoneFieldKey,
                          controller: _phoneController,
                          textTheme: text,
                          onChanged: (value) {
                            fullPhone = value;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // ===== PASSWORD =====
                        LoginPasswordField(controller: _passwordController),
                        SizedBox(height: 24.h),

                        // ===== BUTTON =====
                        LoginButton(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          fullPhone: fullPhone,
                          textTheme: text,
                          onValidatePhone: () {
                            return _phoneFieldKey.currentState
                                    ?.validatePhone() ??
                                true;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // ===== FOOTER =====
                        const LoginFooter(),
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
