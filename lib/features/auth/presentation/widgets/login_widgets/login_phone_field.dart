import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/utils/validator.dart';

class LoginPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final TextTheme textTheme;
  final void Function(String) onChanged;

  const LoginPhoneField({
    super.key,
    required this.controller,
    required this.textTheme,
    required this.onChanged,
  });

  // خلي ال state public
  @override
  LoginPhoneFieldState createState() => LoginPhoneFieldState();
}

class LoginPhoneFieldState extends State<LoginPhoneField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          initialCountryCode: 'EG',
          dropdownIconPosition: IconPosition.trailing,
          flagsButtonMargin: const EdgeInsets.only(left: 15),
          style: widget.textTheme.titleMedium!.copyWith(color: AppColors.black),
          dropdownTextStyle: widget.textTheme.titleSmall!.copyWith(
            color: AppColors.grayMedium,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (phone) {
            widget.onChanged(phone.completeNumber);
            if (errorText != null) setState(() => errorText = null);
          },
          decoration: InputDecoration(
            hintText: 'Phone Number',
            hintStyle: widget.textTheme.titleSmall!.copyWith(
              color: AppColors.grayMedium,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 12,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  bool validatePhone() {
    final result = Validator.validatePhoneNumberField(widget.controller.text);
    setState(() => errorText = result);
    return result == null;
  }
}
