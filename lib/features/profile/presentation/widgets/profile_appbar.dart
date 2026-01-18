import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          IconsAssets.arrowLeft,
          width: 24.w,
          height: 24.h,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        "Profile",
        style: text.titleMedium!.copyWith(color: AppColors.black),
      ),
      centerTitle: false,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
