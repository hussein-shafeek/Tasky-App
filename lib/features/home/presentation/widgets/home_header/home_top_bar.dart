import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: 22.pRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Logo', style: text.headlineSmall),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(
                      child: SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );

                  await Future.delayed(
                    const Duration(milliseconds: 500),
                  );

                  context.pop();
                  context.push(Routes.profileScreen);
                },
                child: SvgPicture.asset(
                  IconsAssets.profile,
                  height: 26.h,
                  width: 26.w,
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () {
                  context.read<AuthCubit>().logout();
                },
                child: SvgPicture.asset(
                  IconsAssets.logout,
                  height: 26,
                  width: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
