import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_cubit.dart';

class HomeFab extends StatelessWidget {
  final VoidCallback onRefresh;

  const HomeFab({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 140,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 80,
            right: 7,
            child: RawMaterialButton(
              onPressed: () async {
                final qrResult = await context.push(Routes.qrScanner);

                if (!context.mounted || qrResult == null) return;

                final taskId = qrResult.toString();
                final cubit = context.read<TasksCubit>();

                final task = cubit.state.tasks.cast<TaskModel?>().firstWhere(
                  (t) => t?.id == taskId,
                  orElse: () => null,
                );

                if (task != null) {
                  context.push(Routes.taskDetails(task.id));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task not found')),
                  );
                }
              },
              fillColor: AppColors.lightPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              constraints: const BoxConstraints(
                minWidth: 50,
                minHeight: 50,
                maxWidth: 50,
                maxHeight: 50,
              ),
              padding: const EdgeInsets.all(13),
              child: Icon(Icons.qr_code, size: 24, color: AppColors.primary),
            ),
          ),
          RawMaterialButton(
            onPressed: () async {
              final result = await context.push(Routes.addTask);
              if (result == true) {
                onRefresh();
              }
            },
            fillColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            constraints: const BoxConstraints(
              minWidth: 64,
              minHeight: 64,
              maxWidth: 64,
              maxHeight: 64,
            ),
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.add, size: 32, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
