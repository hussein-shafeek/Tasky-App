import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  final double height;
  const RegisterHeader({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/register.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: height * 0.2315,
        ),
        SizedBox(height: height * 0.005),
      ],
    );
  }
}
