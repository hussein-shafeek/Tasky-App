import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class RegisterExperienceYearsField extends StatelessWidget {
  final TextEditingController controller;

  const RegisterExperienceYearsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
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
    );
  }
}
