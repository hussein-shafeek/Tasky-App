import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class RegisterNameField extends StatelessWidget {
  final TextEditingController controller;

  const RegisterNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      hintText: "Name...",
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }
}
