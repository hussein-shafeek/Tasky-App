import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/features/profile/presentation/widgets/profileField.dart';

class ProfileList extends StatelessWidget {
  final dynamic profile;
  const ProfileList({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 36.h),
        ProfileField(label: "NAME", value: profile.displayName),
        SizedBox(height: 8.h),
        ProfileField(
          label: "PHONE",
          value: profile.phone,
          suffixIcon: Icons.copy,
          onSuffixTap: () {
            Clipboard.setData(ClipboardData(text: profile.phone));
          },
        ),
        SizedBox(height: 8.h),
        ProfileField(label: "LEVEL", value: profile.level),
        SizedBox(height: 8.h),
        ProfileField(
          label: "YEARS OF EXPERIENCE",
          value: "${profile.experienceYears} years",
        ),
        SizedBox(height: 8.h),
        ProfileField(label: "LOCATION", value: profile.address),
      ],
    );
  }
}
