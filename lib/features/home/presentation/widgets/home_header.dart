import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/models/category_model.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/tab_item.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';

class HomeHeader extends StatefulWidget {
  final Function(String) onCategoryChanged;
  HomeHeader({super.key, required this.onCategoryChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int currentIndex = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 2, bottom: 16, left: 22),
      decoration: const BoxDecoration(color: AppColors.backgroundWhite),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
            ),
            const SizedBox(height: 36),
            Text(
              'My Tasks',
              style: text.titleMedium!.copyWith(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),

            SizedBox(height: 16.h),

            DefaultTabController(
              length: CategoryModel.categories.length,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelPadding: 10.pRight,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                onTap: (index) {
                  if (currentIndex != index) {
                    setState(() => currentIndex = index);
                    widget.onCategoryChanged(
                      CategoryModel.categories[index].value,
                    );
                  }
                },

                tabs: List.generate(CategoryModel.categories.length, (index) {
                  final category = CategoryModel.categories[index];

                  return TabItem(
                    label: category.label,
                    isSelected: currentIndex == index,
                    selectedBackgroundColor: AppColors.primary,
                    unSelectedForgroundColor: AppColors.grayViolet,
                    selectedForgroundColor: AppColors.white,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
