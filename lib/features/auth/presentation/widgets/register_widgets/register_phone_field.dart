import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky_app/core/resources/color_manager.dart';

class RegisterPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String) onChanged;

  const RegisterPhoneField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
  });

  @override
  State<RegisterPhoneField> createState() => _RegisterPhoneFieldState();
}

class _RegisterPhoneFieldState extends State<RegisterPhoneField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          initialCountryCode: 'EG',
          dropdownIconPosition: IconPosition.trailing,
          flagsButtonMargin: const EdgeInsets.only(left: 15),
          style: text.titleMedium!.copyWith(color: Colors.black),
          dropdownTextStyle: text.titleSmall!.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (phone) {
            widget.onChanged(phone.completeNumber);
            // امسح الرسالة أثناء الكتابة
            if (errorText != null) {
              setState(() {
                errorText = null;
              });
            }
          },
          onSubmitted: (phone) {
            validatePhone();
          },
          decoration: InputDecoration(
            hintText: 'Phone Number',
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
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        errorText = 'Phone number is required';
      });
      return false;
    }
    if (text.length < 10) {
      setState(() {
        errorText = 'Invalid mobile number';
      });
      return false;
    }
    setState(() {
      errorText = null;
    });
    return true;
  }
}
