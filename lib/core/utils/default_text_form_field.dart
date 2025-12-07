import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

// ignore: must_be_immutable
class DefaultTextFormField extends StatefulWidget {
  TextInputType? keyboardType;
  String hintText;
  TextEditingController? controller;
  void Function(String)? onChanged;
  String? prefixIconImageName;
  String? Function(String?)? validator;
  bool isPassword;
  Widget? prefixWidget;
  Widget? suffixIcon;
  bool readOnly;
  VoidCallback? onTap;
  TextStyle? hintStyle;

  final int? minLines;
  final int? maxLines;

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
    this.readOnly = false,
    this.onTap,
    this.hintStyle,
    this.keyboardType,
    this.minLines,
    this.maxLines,
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
      keyboardType: widget.keyboardType,
      style: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(color: AppColors.black),

      onTap: widget.onTap,
      readOnly: widget.readOnly,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 1,

      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),

        hintStyle:
            widget.hintStyle ??
            Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(color: AppColors.grayMedium),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
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
