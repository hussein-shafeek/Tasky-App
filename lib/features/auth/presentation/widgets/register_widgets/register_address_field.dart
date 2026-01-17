import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class RegisterAddressField extends StatelessWidget {
  final TextEditingController controller;

  const RegisterAddressField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormField(
      controller: controller,
      hintText: "Address...",
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Address is required";
        }
        return null;
      },
    );
  }
}
