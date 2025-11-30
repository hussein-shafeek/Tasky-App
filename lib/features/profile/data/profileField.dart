import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ultraLightGray,
        borderRadius: BorderRadius.circular(10),
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
                SizedBox(height: height * 0.004926),
                Text(value, style: text.bodyMedium),
              ],
            ),
          ),
          if (suffixIcon != null)
            GestureDetector(
              onTap: onSuffixTap,
              child: SvgPicture.asset(
                'assets/icons/copy.svg',
                width: width * 0.064,
                height: height * 0.02955,
              ),
            ),
        ],
      ),
    );
  }
}
