import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final double height;

  const LoginHeader({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/art.png',
          fit: BoxFit.fill,
          height: height * 0.5394,
        ),
        SizedBox(height: height * 0.005),
      ],
    );
  }
}
