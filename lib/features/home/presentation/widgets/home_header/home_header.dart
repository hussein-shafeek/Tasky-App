import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/models/category_model.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header/home_categories_tabs.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header/home_header_container.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header/home_title.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header/home_top_bar.dart';

class HomeHeader extends StatefulWidget {
  final Function(String) onCategoryChanged;
  const HomeHeader({super.key, required this.onCategoryChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return HomeHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTopBar(),
          const SizedBox(height: 36),
          const HomeTitle(),
          SizedBox(height: 16.h),
          HomeCategoriesTabs(
            currentIndex: currentIndex,
            onChanged: (index) {
              if (currentIndex == index) return;

              setState(() => currentIndex = index);

              widget.onCategoryChanged(CategoryModel.categories[index].value);
            },
          ),
        ],
      ),
    );
  }
}
