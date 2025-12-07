import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/Loader_Widget.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // يمنع المستخدم من إغلاقه
    builder: (_) => const LoadingWidget(),
  );
}
