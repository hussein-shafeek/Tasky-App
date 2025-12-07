import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';
import 'package:tasky_app/core/utils/default_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController experienceLevelController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController experienceYearsController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String countryCode = "+20";
  String fullPhone = '';
  bool isLoading = false;
  String? phoneError;

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
                  'assets/images/register.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height * 0.2315,
                ),
                SizedBox(height: height * 0.005),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Register', style: text.headlineSmall),
                      SizedBox(height: height * 0.02955),
                      DefaultTextFormField(
                        hintText: "Name...",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.024630),
                      IntlPhoneField(
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

                      SizedBox(height: height * 0.024630),

                      DefaultTextFormField(
                        hintText: "Years of experience...",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Experience years is required";
                          }
                          if (int.tryParse(value) == null) {
                            return "Enter a valid number";
                          }
                          return null;
                        },
                        controller: experienceYearsController,
                      ),
                      SizedBox(height: height * 0.024630),

                      DefaultTextFormField(
                        hintText: "Choose experience level",
                        controller: experienceLevelController,
                        prefixWidget: null,
                        isPassword: false,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Experience level is required";
                          }
                          return null;
                        },
                        onTap: () async {
                          final level = await showModalBottomSheet<String>(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Choose experience level",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  ListTile(
                                    title: const Text("Fresh"),
                                    onTap: () =>
                                        Navigator.pop(context, "Fresh"),
                                  ),
                                  ListTile(
                                    title: const Text("Junior"),
                                    onTap: () =>
                                        Navigator.pop(context, "Junior"),
                                  ),
                                  ListTile(
                                    title: const Text("Mid Level"),
                                    onTap: () =>
                                        Navigator.pop(context, "Mid Level"),
                                  ),
                                  ListTile(
                                    title: const Text("Senior"),
                                    onTap: () =>
                                        Navigator.pop(context, "Senior"),
                                  ),
                                ],
                              ),
                            ),
                          );

                          if (level != null) {
                            setState(() {
                              experienceLevelController.text = level;
                            });
                          }
                        },
                        suffixIcon: const Icon(
                          Icons.expand_more,
                          color: AppColors.grayMedium,
                        ),
                      ),

                      SizedBox(height: height * 0.024630),

                      DefaultTextFormField(
                        hintText: "Address...",
                        controller: addressController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.024630),

                      DefaultTextFormField(
                        hintText: "Password...",
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      SizedBox(height: height * 0.02955),
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            : DefaultElevatedButton(
                                label: 'Sign Up',
                                textStyle: text.titleMedium!.copyWith(
                                  color: AppColors.white,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    phoneError =
                                        phoneController.text.trim().isEmpty
                                        ? 'Phone number is required'
                                        : null;
                                  });

                                  bool isFormValid =
                                      formKey.currentState?.validate() ?? false;

                                  if ((phoneError == null) && isFormValid) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    final authService = AuthService();

                                    try {
                                      bool success = await authService.register(
                                        phone: fullPhone.isEmpty
                                            ? '+20${phoneController.text}'
                                            : fullPhone,
                                        password: passwordController.text,
                                        displayName: nameController.text,
                                        experienceYears:
                                            int.tryParse(
                                              experienceYearsController.text,
                                            ) ??
                                            1,
                                        address: addressController.text,
                                        level: experienceLevelController.text
                                            .toLowerCase(),
                                      );

                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Register successful",
                                            ),
                                            backgroundColor: AppColors.green,
                                          ),
                                        );

                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed(
                                          AppRoutes.loginScreen,
                                        );
                                      } else {
                                        final errorMessage =
                                            authService.getLastError() ??
                                            "Register failed";

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: AppColors.coral,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "An error occurred: $e",
                                          ),
                                          backgroundColor: AppColors.coral,
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please fill all required fields correctly",
                                        ),
                                        backgroundColor: AppColors.coral,
                                      ),
                                    );
                                  }
                                },
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                              ),
                      ),

                      SizedBox(height: height * 0.02955),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have any account?',
                            style: text.titleMedium!.copyWith(
                              color: AppColors.grayMedium,
                            ),
                          ),

                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.loginScreen),
                            child: Text('Sign in'),
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
