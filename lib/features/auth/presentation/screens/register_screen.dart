import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/utils/validator.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_address_field.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_button.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_experience_level_field.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_experience_years_field.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_footer.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_header.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_name_field.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_password_field.dart';
import 'package:tasky_app/core/utils/ui_utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/resources/color_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceLevelController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String fullPhone = '';

  String? phoneError;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          UIUtils.showMessage("Registered successfully");
        } else if (state is RegisterError) {
          UIUtils.showMessage(state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegisterHeader(height: height),
                    SizedBox(height: height * 0.03),
                    RegisterNameField(controller: _nameController),
                    SizedBox(height: height * 0.02),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntlPhoneField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          initialCountryCode: 'EG',
                          dropdownIconPosition: IconPosition.trailing,
                          flagsButtonMargin: const EdgeInsets.only(left: 15),
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: AppColors.black),
                          onChanged: (phone) {
                            setState(() {
                              fullPhone = phone.completeNumber;
                              phoneError = null;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
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
                        const SizedBox(height: 10),
                      ],
                    ),

                    RegisterExperienceYearsField(
                      controller: _experienceYearsController,
                    ),
                    SizedBox(height: height * 0.02),
                    RegisterExperienceLevelField(
                      controller: _experienceLevelController,
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
                                ...List.generate(
                                  ExperienceLevel.values.length,
                                  (index) {
                                    final lvl = ExperienceLevel.values[index];
                                    return ListTile(
                                      title: Text(lvl.label),
                                      onTap: () =>
                                          Navigator.pop(context, lvl.name),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                        if (level != null) {
                          setState(() {
                            _experienceLevelController.text = level;
                          });
                        }
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    RegisterAddressField(controller: _addressController),
                    SizedBox(height: height * 0.02),
                    RegisterPasswordField(controller: _passwordController),
                    SizedBox(height: height * 0.03),

                    // ======= Register Button =======
                    RegisterButton(
                      formKey: formKey,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      addressController: _addressController,
                      experienceYearsController: _experienceYearsController,
                      experienceLevelController: _experienceLevelController,
                      fullPhone: fullPhone,
                      onValidatePhone: _validatePhone,
                    ),
                    SizedBox(height: height * 0.03),
                    const RegisterFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePhone() {
    final result = Validator.validatePhoneNumberField(_phoneController.text);
    setState(() => phoneError = result);
    return result == null;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _experienceLevelController.dispose();
    _addressController.dispose();
    _experienceYearsController.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:tasky_app/core/resources/color_manager.dart';
// import 'package:tasky_app/core/routes/routes_name.dart';
// import 'package:tasky_app/core/utils/ui_utils.dart';
// import 'package:tasky_app/core/widgets/default_elevated_button.dart';
// import 'package:tasky_app/core/widgets/default_text_form_field.dart';
// //import 'package:tasky_app/core/models/user_model.dart';
// import 'package:tasky_app/features/auth/data/models/register_request.dart';
// import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _experienceLevelController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   TextEditingController _experienceYearsController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String fullPhone = '';
//   String? phoneError;

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     TextTheme text = Theme.of(context).textTheme;

//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is RegisterSuccess) {
//           context.go(Routes.homeScreen);
//         } else if (state is RegisterError) {
//           UIUtils.showMessage(state.message);
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(
//           //     content: Text(state.message),
//           //     backgroundColor: AppColors.coral,
//           //   ),
//           // );
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: SafeArea(
//           child: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/images/register.png',
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: height * 0.2315,
//                   ),
//                   SizedBox(height: height * 0.005),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Register', style: text.headlineSmall),
//                         SizedBox(height: height * 0.02955),
//                         DefaultTextFormField(
//                           hintText: "Name...",
//                           controller: _nameController,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Name is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: height * 0.024630),
//                         IntlPhoneField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           initialCountryCode: 'EG',
//                           dropdownIconPosition: IconPosition.trailing,
//                           dropdownIcon: Icon(
//                             Icons.arrow_drop_down,
//                             color: AppColors.grayMedium,
//                           ),
//                           flagsButtonMargin: const EdgeInsets.only(left: 15),

//                           dropdownTextStyle: text.titleSmall!.copyWith(
//                             color: AppColors.grayMedium,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           style: text.titleMedium!.copyWith(
//                             color: AppColors.black,
//                           ),
//                           onChanged: (phone) {
//                             fullPhone = phone.completeNumber;
//                             setState(() => phoneError = null);
//                           },
//                           decoration: InputDecoration(
//                             hintText: 'Phone Number',
//                             errorText: phoneError,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 12,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: height * 0.024630),
//                         DefaultTextFormField(
//                           hintText: "Years of experience...",
//                           controller: _experienceYearsController,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Experience years is required";
//                             }
//                             if (int.tryParse(value) == null) {
//                               return "Enter a valid number";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: height * 0.024630),
//                         DefaultTextFormField(
//                           hintText: "Choose experience level",
//                           controller: _experienceLevelController,
//                           readOnly: true,
//                           prefixWidget: null,
//                           isPassword: false,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Experience level is required";
//                             }
//                             return null;
//                           },
//                           onTap: () async {
//                             final level = await showModalBottomSheet<String>(
//                               context: context,
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(20),
//                                 ),
//                               ),
//                               builder: (context) => Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Text(
//                                       "Choose experience level",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
//                                     ...List.generate(
//                                       ExperienceLevel.values.length,
//                                       (index) {
//                                         final lvl =
//                                             ExperienceLevel.values[index];
//                                         return ListTile(
//                                           title: Text(lvl.label),
//                                           onTap: () =>
//                                               Navigator.pop(context, lvl.name),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );

//                             if (level != null) {
//                               setState(() {
//                                 _experienceLevelController.text = level;
//                               });
//                             }
//                           },
//                         ),

//                         //                         onTap: () async {
//                         //                           final level = await showModalBottomSheet<String>(
//                         //                             context: context,
//                         //                             shape: const RoundedRectangleBorder(
//                         //                               borderRadius: BorderRadius.vertical(
//                         //                                 top: Radius.circular(20),
//                         //                               ),
//                         //                             ),
//                         //                             builder: (context) => Padding(
//                         //                               padding: const EdgeInsets.all(16),
//                         //                               child: Column(
//                         //                                 mainAxisSize: MainAxisSize.min,
//                         //                                 children: [
//                         //                                   const Text(
//                         //                                     "Choose experience level",
//                         //                                     style: TextStyle(
//                         //                                       fontSize: 18,
//                         //                                       fontWeight: FontWeight.bold,
//                         //                                     ),
//                         //                                   ),
//                         //                                   const SizedBox(height: 16),
//                         //                                   ...List.generate(
//                         //                                     ExperienceLevel.values.length,
//                         //                                     (index) {
//                         //                                       final lvl = ExperienceLevel.values[index];
//                         //                                       return ListTile(
//                         //                                         title: Text(lvl.label),
//                         //                                         onTap: () =>
//                         //                                             Navigator.pop(context, lvl.name),
//                         //                                       );
//                         //                                     },
//                         //                                   ),
//                         //                                 ],
//                         //                               ),
//                         //                             ),
//                         //                           );

//                         //                           if (level != null) {
//                         //                             setState(() {
//                         //                               experienceLevelController.text = level;
//                         //                             });
//                         //                           }
//                         //                         },
//                         //                         suffixIcon: const Icon(
//                         //                           Icons.expand_more,
//                         //                           color: AppColors.grayMedium,
//                         //                         ),
//                         //                       ),
//                         SizedBox(height: height * 0.024630),
//                         DefaultTextFormField(
//                           hintText: "Address...",
//                           controller: _addressController,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Address is required";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: height * 0.024630),
//                         DefaultTextFormField(
//                           hintText: "Password...",
//                           controller: _passwordController,
//                           isPassword: true,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return "Password is required";
//                             }
//                             if (value.length < 6) {
//                               return "Password must be at least 6 characters";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: height * 0.02955),
//                         BlocBuilder<AuthCubit, AuthState>(
//                           builder: (context, state) {
//                             bool isLoading = state is RegisterLoading;
//                             return SizedBox(
//                               width: double.infinity,
//                               child: isLoading
//                                   ? const Center(
//                                       child: CircularProgressIndicator(
//                                         color: AppColors.primary,
//                                       ),
//                                     )
//                                   : DefaultElevatedButton(
//                                       label: 'Sign Up',
//                                       textStyle: text.titleMedium!.copyWith(
//                                         color: AppColors.white,
//                                       ),
//                                       onPressed: () {
//                                         FocusScope.of(
//                                           context,
//                                         ).unfocus(); // يقفل الكيبورد

//                                         setState(() {
//                                           phoneError =
//                                               _phoneController.text
//                                                   .trim()
//                                                   .isEmpty
//                                               ? 'Phone number is required'
//                                               : null;
//                                         });

//                                         final isFormValid =
//                                             formKey.currentState?.validate() ??
//                                             false;

//                                         if (!isFormValid ||
//                                             phoneError != null) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                 "Please fill all required fields correctly",
//                                               ),
//                                               backgroundColor: AppColors.coral,
//                                             ),
//                                           );
//                                           return;
//                                         }

//                                         // ✅ نحول النص لـ enum
//                                         final experienceLevel =
//                                             ExperienceLevel.fromName(
//                                               _experienceLevelController.text,
//                                             );

//                                         // ✅ نبني الريكوست صح
//                                         final request = RegisterRequest(
//                                           phone: fullPhone.isEmpty
//                                               ? '+20${_phoneController.text}'
//                                               : fullPhone,
//                                           password: _passwordController.text,
//                                           displayName: _nameController.text
//                                               .trim(),
//                                           experienceYears:
//                                               int.tryParse(
//                                                 _experienceYearsController.text,
//                                               ) ??
//                                               1,
//                                           address: _addressController.text
//                                               .trim(),
//                                           experienceLevel: experienceLevel,
//                                         );

//                                         // ✅ نبعته مرة واحدة
//                                         context.read<AuthCubit>().register(
//                                           request,
//                                         );
//                                       },

//                                       // onPressed: () {

//                                       //   //-----
//                                       //   FocusScope.of(context).unfocus();
//                                       //   final levelEnum =
//                                       //       ExperienceLevel.fromName(
//                                       //         _experienceLevelController.text,
//                                       //       );

//                                       //   setState(() {
//                                       //     phoneError =
//                                       //         _phoneController.text
//                                       //             .trim()
//                                       //             .isEmpty
//                                       //         ? 'Phone number is required'
//                                       //         : null;
//                                       //   });

//                                       //   bool isFormValid =
//                                       //       formKey.currentState?.validate() ??
//                                       //       false;

//                                       //   if ((phoneError == null) &&
//                                       //       isFormValid) {
//                                       //     context.read<AuthCubit>().register(
//                                       //       RegisterRequest(phone: fullPhone.isEmpty
//                                       //           ? '+20${_phoneController.text}'
//                                       //           : fullPhone,
//                                       //           displayName: _nameController.text,
//                                       //          experienceYears: int.tryParse(
//                                       //             _experienceYearsController
//                                       //                 .text,
//                                       //           ) ??
//                                       //           1,
//                                       //          address: _addressController.text,
//                                       //         level: levelEnum.name,

//                                       //          experienceLevel: ExperienceLevel.fromName(_experienceLevelController.text).name)
//                                       //       phone:
//                                       //       password: _passwordController.text,
//                                       //       displayName: _nameController.text,
//                                       //       experienceYears:
//                                       //           int.tryParse(
//                                       //             _experienceYearsController
//                                       //                 .text,
//                                       //           ) ??
//                                       //           1,
//                                       //       address: _addressController.text,
//                                       //       level: levelEnum.name,
//                                       //     );
//                                       //   } else {
//                                       //     ScaffoldMessenger.of(
//                                       //       context,
//                                       //     ).showSnackBar(
//                                       //       const SnackBar(
//                                       //         content: Text(
//                                       //           "Please fill all required fields correctly",
//                                       //         ),
//                                       //         backgroundColor: AppColors.coral,
//                                       //       ),
//                                       //     );
//                                       //   }
//                                       // },
//                                       backgroundColor: AppColors.primary,
//                                       foregroundColor: AppColors.white,
//                                     ),
//                             );
//                           },
//                         ),
//                         SizedBox(height: height * 0.02955),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Already have any account?',
//                               style: text.titleMedium!.copyWith(
//                                 color: AppColors.grayMedium,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () => context.go(Routes.loginScreen),
//                               child: Text('Sign in'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _nameController.dispose();
//     _experienceLevelController.dispose();
//     _addressController.dispose();
//     _experienceYearsController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
// }
