import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class RegisterPasswordField extends StatelessWidget {
  final TextEditingController controller;

  const RegisterPasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      hintText: "Password...",
      isPassword: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Password is required";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }
}
