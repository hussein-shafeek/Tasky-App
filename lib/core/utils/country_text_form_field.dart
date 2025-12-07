import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

class CountryPhone extends StatefulWidget {
  const CountryPhone({
    super.key,
    required this.onChanged,
    required this.phoneController,
    required this.title,
    this.hintText,
  });

  final TextEditingController? phoneController;
  final void Function(PhoneNumber)? onChanged;
  final String title;

  final String? hintText;

  @override
  State<CountryPhone> createState() => _CountryPhoneState();
}

class _CountryPhoneState extends State<CountryPhone> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: text.titleMedium!.copyWith(color: AppColors.black),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            textTheme: text.copyWith(
              titleMedium: text.titleMedium!.copyWith(color: AppColors.black),
            ),
          ),
          child: IntlPhoneField(
            controller: widget.phoneController,
            style: text.titleMedium!.copyWith(color: AppColors.black),
            pickerDialogStyle: PickerDialogStyle(
              searchFieldInputDecoration: InputDecoration(
                hintText: 'Search country',
                hintStyle: text.titleMedium!.copyWith(
                  color: AppColors.grayMedium,
                ),
              ),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorMaxLines: 1,
              filled: true,
              isDense: true,
              hintStyle: text.titleMedium!.copyWith(color: AppColors.black),
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            showCursor: false,
            initialCountryCode: 'EG',
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
