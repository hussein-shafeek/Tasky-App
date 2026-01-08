import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:tasky_app/features/onboarding/data/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', true);
    // ignore: use_build_context_synchronously
    context.go(Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final height = MediaQuery.of(context).size.height;
    final page = OnboardingModel.getPages(context).first;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/${page.image}.png',
              height: height * 0.5394,
            ),

            Text(
              page.title,
              textAlign: TextAlign.center,
              style: text.headlineSmall,
            ),
            SizedBox(height: height * 0.0197),

            Text(
              page.description,
              textAlign: TextAlign.center,
              style: text.titleSmall,
            ),
            SizedBox(height: height * 0.04002),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: DefaultElevatedButton(
                label: 'Let’s Start',
                suffixSvgPath: IconsAssets.arrowRight,
                backgroundColor: AppColors.primary,
                onPressed: () => _finishOnboarding(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
