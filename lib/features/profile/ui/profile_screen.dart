import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/features/profile/data/profileField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,

        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: width * 0.064,
            height: height * 0.02955,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: text.titleMedium!.copyWith(color: AppColors.black),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: height * 0.02955),

            /// ----------- NAME -----------
            const ProfileField(label: "NAME", value: "Hussein Shafeek"),

            SizedBox(height: height * 0.009852),

            /// ----------- PHONE -----------
            ProfileField(
              label: "PHONE",
              value: "+20 123 456-7890",
              suffixIcon: Icons.copy,
              onSuffixTap: () {
                print("Copy phone number");
              },
            ),

            SizedBox(height: height * 0.009852),

            /// ----------- LEVEL -----------
            const ProfileField(label: "LEVEL", value: "Senior"),

            SizedBox(height: height * 0.009852),

            /// ----------- YEARS OF EXPERIENCE -----------
            const ProfileField(label: "YEARS OF EXPERIENCE", value: "7 years"),

            SizedBox(height: height * 0.009852),

            /// ----------- LOCATION -----------
            const ProfileField(label: "LOCATION", value: "Mansoura, Egypt"),
          ],
        ),
      ),
    );
  }
}
