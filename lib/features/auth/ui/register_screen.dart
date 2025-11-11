import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/routes/routes.dart';
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
                      ),
                      SizedBox(height: height * 0.024630),
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
                        hintText: "Choose experience level",
                        controller: experienceLevelController,
                        prefixWidget: null,
                        isPassword: false,
                        readOnly: true,
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
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRoutes.homeScreen);
                        },

                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
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
