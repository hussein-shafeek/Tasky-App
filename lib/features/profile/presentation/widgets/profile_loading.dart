import 'package:flutter/material.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profile_loading_field.dart';

class ProfileLoadingState extends StatelessWidget {
  const ProfileLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: const [ProfileFieldLoading()]);
  }
}
