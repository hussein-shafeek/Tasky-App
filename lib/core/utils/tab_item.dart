import 'package:flutter/material.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

// ignore: must_be_immutable
class TabItem extends StatelessWidget {
  String label;
  bool isSelected;
  Color selectedForgroundColor;
  Color unSelectedForgroundColor;
  Color selectedBackgroundColor;

  TabItem({
    super.key,
    required this.label,

    required this.isSelected,
    required this.selectedBackgroundColor,
    required this.unSelectedForgroundColor,
    required this.selectedForgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isSelected ? selectedBackgroundColor : AppColors.lightLavender,
      ),
      child: Text(
        label,
        style: text.titleMedium!.copyWith(
          color: isSelected ? selectedForgroundColor : unSelectedForgroundColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
