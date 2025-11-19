import 'package:flutter/material.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class ProfileFieldLoading extends StatelessWidget {
  const ProfileFieldLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightPurple.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Container(
            height: 12,
            width: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 10),

          // value
          Container(
            height: 16,
            width: double.infinity,
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
