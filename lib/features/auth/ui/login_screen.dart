import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: height - MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/art.png',
                    fit: BoxFit.fill,
                    height: height * 0.5394,
                  ),
                  SizedBox(height: height * 0.027241),
                  // DefaultTextFormField(
                  //   hintText: t.email,
                  //   controller: emailController,
                  //   prefixIconImageName: 'Email',
                  //   validator: (value) {
                  //     if (value == null || value.length < 5) {
                  //       return t.somethingWrong;
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: height * 0.01816),
                  // DefaultTextFormField(
                  //   hintText: t.password,
                  //   isPassword: true,
                  //   controller: passwordController,
                  //   prefixIconImageName: 'lock',
                  //   validator: (value) {
                  //     if (value == null || value.length < 8) {
                  //       return t.passwordTooShort;
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: height * 0.027241),
                  DefaultElevatedButton(
                    label: 'Sign In',
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.homeScreen);
                    },

                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  SizedBox(height: height * 0.0227),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Didn’t have any account?', style: text.titleMedium),

                      TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.registerScreen),
                        child: Text('Sign Up here'),
                      ),
                    ],
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
