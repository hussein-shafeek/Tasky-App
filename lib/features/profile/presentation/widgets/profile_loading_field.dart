import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';

class ProfileFieldLoading extends StatelessWidget {
  const ProfileFieldLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 12.mBottom,
      padding: 16.pAll,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightPurple.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Container(
            height: 12.h,
            width: 80.w,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          SizedBox(height: 10.h),

          // value
          Container(
            height: 16.h,
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
