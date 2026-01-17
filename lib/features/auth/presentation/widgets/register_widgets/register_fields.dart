import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/resources/font_extensions.dart';
import 'package:tasky_app/core/resources/font_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/core/resources/values_manager.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';

class RegisterFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final TextEditingController passwordController;
  final TextEditingController addressController;
  final TextEditingController experienceYearsController;
  final TextEditingController experienceLevelController;
  final void Function(String) fullPhoneSetter;
  final String? phoneError;
  final void Function(String?) setPhoneError;

  const RegisterFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.passwordController,
    required this.addressController,
    required this.experienceYearsController,
    required this.experienceLevelController,
    required this.fullPhoneSetter,
    required this.phoneError,
    required this.setPhoneError,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Register', style: text.headlineSmall),
        SizedBox(height: 24.h),
        // Name
        RegisterTextField(
          controller: nameController,
          hintText: "Name...",
          validator: (v) => v!.isEmpty ? "Name is required" : null,
        ),
        SizedBox(height: Insets.s10.h),

        // Phone
        IntlPhoneField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          initialCountryCode: 'EG',
          dropdownIconPosition: IconPosition.trailing,
          flagsButtonMargin: Insets.s15.mLeft,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: AppColors.black),
          onChanged: (phone) {
            fullPhoneSetter(phone.completeNumber);
            if (phoneError != null) setPhoneError(null);
          },
          decoration: InputDecoration(
            hintText: 'Phone Number',
            border: OutlineInputBorder(borderRadius: 8.brAll),
            contentPadding: 15.pVH(12),
            errorText: phoneError,
          ),
        ),
        SizedBox(height: Insets.s10.h),

        // Password
        RegisterTextField(
          controller: passwordController,
          hintText: "Password...",
          isPassword: true,
          validator: (v) {
            if (v!.isEmpty) return "Password is required";
            if (v.length < 6) return "Password must be at least 6 chars";
            return null;
          },
        ),
        SizedBox(height: Insets.s10.h),

        // Address
        RegisterTextField(
          controller: addressController,
          hintText: "Address...",
          validator: (v) => v!.isEmpty ? "Address is required" : null,
        ),
        SizedBox(height: Insets.s10.h),

        // Experience Years
        RegisterTextField(
          controller: experienceYearsController,
          hintText: "Years of experience...",
          validator: (v) {
            if (v!.isEmpty) return "Experience years is required";
            if (int.tryParse(v) == null) return "Enter a valid number";
            return null;
          },
        ),
        SizedBox(height: Insets.s10.h),

        // Experience Level
        RegisterTextField(
          controller: experienceLevelController,
          hintText: "Choose experience level",
          readOnly: true,
          onTap: () async {
            final level = await showModalBottomSheet<String>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => Padding(
                padding: Insets.s16.pAll,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choose experience level",
                      style: TextStyle(
                        fontSize: 18.fs,
                        fontWeight: FontWeightManager.bold,
                      ),
                    ),
                    SizedBox(height: Insets.s16.h),
                    ...List.generate(ExperienceLevel.values.length, (i) {
                      final lvl = ExperienceLevel.values[i];
                      return ListTile(
                        title: Text(lvl.label),
                        onTap: () => Navigator.pop(context, lvl.name),
                      );
                    }),
                  ],
                ),
              ),
            );
            if (level != null) experienceLevelController.text = level;
          },
          validator: (v) => v!.isEmpty ? "Experience level is required" : null,
        ),
      ],
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      hintText: hintText,
      isPassword: isPassword,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
    );
  }
}
