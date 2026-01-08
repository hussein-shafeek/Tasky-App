import 'package:flutter/material.dart';
import 'package:tasky_app/core/widgets/Loader_Widget.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingWidget(),
  );
}
