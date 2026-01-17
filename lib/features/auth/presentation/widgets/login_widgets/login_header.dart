import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/art.png', fit: BoxFit.fill, height: 482.h),
        SizedBox(height: 4.h),
      ],
    );
  }
}
