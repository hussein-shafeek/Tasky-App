import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/models/category_model.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/tab_item.dart';

class HomeHeader extends StatefulWidget {
  final Function(String) onCategoryChanged;
  HomeHeader({super.key, required this.onCategoryChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(start: 22, bottom: 16, top: 2),
      decoration: const BoxDecoration(color: AppColors.backgroundWhite),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Logo', style: text.headlineSmall),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.profileScreen);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          height: 26,
                          width: 26,
                        ),
                      ),
                      const SizedBox(width: 16),

                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/icons/logout.svg',
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

            const SizedBox(height: 16),

            DefaultTabController(
              length: CategoryModel.categories.length,
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelPadding: const EdgeInsets.only(right: 10),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                onTap: (index) {
                  if (currentIndex != index) {
                    setState(() => currentIndex = index);
                    final selectedName = CategoryModel.categories[index].name;
                    widget.onCategoryChanged(selectedName);
                  }
                },
                tabs: CategoryModel.categories
                    .map(
                      (category) => TabItem(
                        label: category.name,
                        isSelected:
                            currentIndex ==
                            CategoryModel.categories.indexOf(category),
                        selectedBackgroundColor: AppColors.primary,
                        unSelectedForgroundColor: AppColors.grayViolet,
                        selectedForgroundColor: AppColors.white,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
