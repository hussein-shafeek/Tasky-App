import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class TaskQrWidget extends StatelessWidget {
  final String taskId;

  const TaskQrWidget({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPurple, // زي شغلنا
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR
          QrImageView(
            data: taskId,
            version: QrVersions.auto,
            size: 150,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Tap to scan task",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
