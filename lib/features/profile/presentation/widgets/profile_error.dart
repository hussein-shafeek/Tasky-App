import 'package:flutter/material.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String message;
  const ProfileErrorWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
