import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: 12.pVH(15),
      decoration: BoxDecoration(
        color: AppColors.ultraLightGray,
        borderRadius: 10.brAll,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: text.titleSmall!.copyWith(
                    color: AppColors.darkCharcoal..withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(value, style: text.bodyMedium),
              ],
            ),
          ),
          if (suffixIcon != null)
            GestureDetector(
              onTap: onSuffixTap,
              child: SvgPicture.asset(
                IconsAssets.copy,
                width: 24.w,
                height: 24.h,
              ),
            ),
        ],
      ),
    );
  }
}
