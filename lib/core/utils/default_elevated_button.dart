import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

// ignore: must_be_immutable
class DefaultElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  Color? backgroundColor;
  Color? foregroundColor;
  String? prefixSvgPath;
  final String? suffixSvgPath;
  final TextStyle? textStyle;
  final bool isLoading;

  DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.prefixSvgPath,
    this.suffixSvgPath,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, 49),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefixSvgPath != null) ...[
                  SvgPicture.asset(prefixSvgPath!, width: 24, height: 24),

                  SizedBox(width: width * 0.020),
                ],
                Text(label, style: textStyle ?? text.titleLarge),
                if (suffixSvgPath != null) ...[
                  SizedBox(width: width * 0.0293),
                  SvgPicture.asset(
                    suffixSvgPath!,
                    width: 18,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
