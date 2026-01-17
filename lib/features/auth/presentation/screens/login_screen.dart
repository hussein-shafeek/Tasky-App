import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/utils/validator.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
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
    final height = MediaQuery.of(context).size.height;
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
                  LoginHeader(height: height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login', style: text.headlineSmall),
                        SizedBox(height: height * 0.03),

                        // ===== PHONE =====
                        LoginPhoneField(
                          key: _phoneFieldKey,
                          controller: _phoneController,
                          textTheme: text,
                          onChanged: (value) {
                            fullPhone = value;
                          },
                        ),
                        SizedBox(height: height * 0.02),

                        // ===== PASSWORD =====
                        LoginPasswordField(controller: _passwordController),
                        SizedBox(height: height * 0.03),

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
                        SizedBox(height: height * 0.03),

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
