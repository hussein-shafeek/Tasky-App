import 'package:flutter/material.dart';
import 'package:tasky_app/core/resources/color_manager.dart';

class HomeHeaderContainer extends StatelessWidget {
  final Widget child;

  const HomeHeaderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 2, bottom: 16, left: 22),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
      ),
      child: SafeArea(
        bottom: false,
        child: child,
      ),
    );
  }
}
