import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/services/auth_service.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';
import 'package:tasky_app/core/utils/default_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String countryCode = "+20";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
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
                      DefaultTextFormField(
                        hintText: "123 456-7890",
                        controller: phoneController,
                        prefixWidget: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CountryCodePicker(
                            onChanged: (value) => setState(() {
                              countryCode = value.dialCode ?? "+20";
                            }),
                            initialSelection: 'EG',
                            favorite: ['+20', 'EG'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            showFlag: true,

                            builder: (country) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (country?.flagUri != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      country!.flagUri!,
                                      package: 'country_code_picker',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  country?.dialCode ?? "+20",
                                  style: const TextStyle(
                                    color: AppColors.grayMedium,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.expand_more,
                                  color: AppColors.grayMedium,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.024630),
                      DefaultTextFormField(
                        hintText: "Password...",
                        controller: passwordController,
                        isPassword: true,
                      ),
                      SizedBox(height: height * 0.02955),
                      DefaultElevatedButton(
                        label: 'Sign In',
                        textStyle: text.titleMedium,
                        onPressed: () async {
                          if (phoneController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Phone and password are required",
                                ),
                              ),
                            );
                            return;
                          }

                          final authService = AuthService();
                          final token = await authService.login(
                            phone: countryCode + phoneController.text,
                            password: passwordController.text,
                          );

                          if (token != null) {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.homeScreen);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login failed")),
                            );
                          }
                        },
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
