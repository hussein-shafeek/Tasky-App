import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/register.png',
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: 400.h,
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
