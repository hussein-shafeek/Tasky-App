import 'package:flutter/material.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_appbar.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const ProfileAppBar(),
      body: const ProfileContent(),
    );
  }
}
