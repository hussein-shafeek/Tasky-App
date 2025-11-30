import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class TaskQrWidget extends StatefulWidget {
  final String? taskId;

  const TaskQrWidget({super.key, required this.taskId});

  @override
  State<TaskQrWidget> createState() => _TaskQrWidgetState();
}

class _TaskQrWidgetState extends State<TaskQrWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.taskId == null || widget.taskId!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text("No QR available", style: TextStyle(fontSize: 16)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: QrImageView(
        data: widget.taskId!,
        version: QrVersions.auto,
        size: 300,
      ),
    );
  }
}
