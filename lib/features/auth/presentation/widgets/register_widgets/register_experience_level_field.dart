import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class RegisterExperienceLevelField extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onTap;

  const RegisterExperienceLevelField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      hintText: "Choose experience level",
      readOnly: true,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Experience level is required";
        }
        return null;
      },
    );
  }
}
