import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasky_app/core/models/category_model.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/core/widgets/tab_item.dart';

class HomeCategoriesTabs extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;

  const HomeCategoriesTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CategoryModel.categories.length,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        labelPadding: 10.pRight,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        onTap: onChanged,
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
    );
  }
}
