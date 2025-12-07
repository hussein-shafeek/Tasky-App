import 'package:flutter/material.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({Key? key, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 6,
          color: AppColors.primary, // لون البريمري
        ),
      ),
    );
  }
}
