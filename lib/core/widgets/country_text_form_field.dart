import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/utils/validator.dart';

class CountryPhone extends StatelessWidget {
  const CountryPhone({
    super.key,
    required this.onChanged,
    required this.phoneController,
    required this.title,
    this.hintText,
  });

  final TextEditingController phoneController;
  final void Function(PhoneNumber) onChanged;
  final String title;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleMedium!.copyWith(color: AppColors.black)),
        const SizedBox(height: 8),

        Theme(
          data: Theme.of(context).copyWith(
            textTheme: text.copyWith(
              titleMedium: text.titleMedium!.copyWith(color: AppColors.black),
            ),
          ),
          child: IntlPhoneField(
            controller: phoneController,
            initialCountryCode: 'EG',

            // ✅ validation بقى هنا
            validator: (phone) {
              return Validator.validateLoginPhone(phone?.number);
            },

            onChanged: onChanged,

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
              hintText: hintText,
              filled: true,
              isDense: true,
              fillColor: AppColors.white,
              hintStyle: text.titleMedium!.copyWith(
                color: AppColors.grayMedium,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
