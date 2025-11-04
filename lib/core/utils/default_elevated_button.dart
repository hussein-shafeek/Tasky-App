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

  DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.prefixSvgPath,
    this.suffixSvgPath,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;
    //double height = MediaQuery.sizeOf(context).height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, 49),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixSvgPath != null) ...[
            SvgPicture.asset(prefixSvgPath!, width: 24, height: 24),

            SizedBox(width: width * 0.020),
          ],
          Text(label, style: text.titleLarge),
          if (suffixSvgPath != null) ...[
            SizedBox(width: width * 0.0293),
            SvgPicture.asset(
              suffixSvgPath!,
              width: 18,
              height: 12,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          ],
        ],
      ),
    );
  }
}
