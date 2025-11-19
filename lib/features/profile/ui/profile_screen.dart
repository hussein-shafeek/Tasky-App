import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/features/profile/data/profileField.dart';
import 'package:tasky_app/features/profile/data/profile_loading_field.dart';
import 'package:tasky_app/features/profile/data/profile_service.dart';
import 'package:tasky_app/features/profile/model/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? profile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    try {
      final service = ProfileService();
      profile = await service.getProfile();
    } catch (e) {
      errorMessage = "Failed to load profile data";
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: size.width * 0.064,
            height: size.height * 0.02955,
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
        child: isLoading
            ? ListView(
                children: const [
                  ProfileFieldLoading(),
                  ProfileFieldLoading(),
                  ProfileFieldLoading(),
                  ProfileFieldLoading(),
                  ProfileFieldLoading(),
                ],
              )
            : errorMessage != null
            ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
            : ListView(
                children: [
                  SizedBox(height: size.height * 0.02955),

                  /// ----------- NAME -----------
                  ProfileField(
                    label: "NAME",
                    value: profile?.displayName ?? "-",
                  ),

                  SizedBox(height: size.height * 0.009852),

                  /// ----------- PHONE -----------
                  ProfileField(
                    label: "PHONE",
                    value: profile?.phone ?? "-",
                    suffixIcon: Icons.copy,
                    onSuffixTap: () {
                      Clipboard.setData(
                        ClipboardData(text: profile?.phone ?? ""),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.009852),

                  /// ----------- LEVEL -----------
                  ProfileField(label: "LEVEL", value: profile?.level ?? "-"),

                  SizedBox(height: size.height * 0.009852),

                  /// ----------- YEARS OF EXPERIENCE -----------
                  ProfileField(
                    label: "YEARS OF EXPERIENCE",
                    value: "${profile?.experienceYears ?? 0} years",
                  ),

                  SizedBox(height: size.height * 0.009852),

                  /// ----------- LOCATION -----------
                  ProfileField(
                    label: "LOCATION",
                    value: profile?.address ?? "-",
                  ),
                ],
              ),
      ),
    );
  }
}
