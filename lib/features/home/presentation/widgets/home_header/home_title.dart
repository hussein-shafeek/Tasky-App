import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Text(
      'My Tasks',
      style: text.titleMedium!.copyWith(
        color: Colors.black.withValues(alpha: 0.6),
      ),
    );
  }
}
