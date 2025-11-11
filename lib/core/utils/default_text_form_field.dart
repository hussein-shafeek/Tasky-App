import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

// ignore: must_be_immutable
class DefaultTextFormField extends StatefulWidget {
  String hintText;
  TextEditingController? controller;
  void Function(String)? onChanged;
  String? prefixIconImageName;
  String? Function(String?)? validator;
  bool isPassword;
  Widget? prefixWidget;
  Widget? suffixIcon;

  /// 👇 الإضافات الجديدة
  bool readOnly;
  VoidCallback? onTap;

  DefaultTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.prefixIconImageName,
    this.validator,
    this.isPassword = false,
    this.prefixWidget,
    this.suffixIcon,
    this.readOnly = false, // 👈 القيمة الافتراضية false
    this.onTap, // 👈 الحدث عند الضغط
  });

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  late bool isObscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      style: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(color: AppColors.black),

      /// 👇 نضيف دعم للـ onTap و readOnly
      onTap: widget.onTap,
      readOnly: widget.readOnly,

      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon:
            widget.prefixWidget ??
            (widget.prefixIconImageName == null
                ? null
                : SvgPicture.asset(
                    'assets/icons/${widget.prefixIconImageName}.svg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.scaleDown,
                  )),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.hintGray,
                ),
              )
            : widget.suffixIcon,
      ),
      validator: widget.validator,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
