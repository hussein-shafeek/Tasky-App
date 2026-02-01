import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/enums/priority.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onRefresh;

  const TaskItem({super.key, required this.task, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        final updated = await context.push(Routes.taskDetails(task.id));
        if (!context.mounted) return;
        if (updated == true) {
          onRefresh();
        }
      },
      child: Container(
        decoration: const BoxDecoration(color: AppColors.backgroundWhite),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (task.image != null && task.image!.isNotEmpty)
                ? Image.network(
                    task.fullImageUrl ?? '',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageAssets.grocery,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    ImageAssets.grocery,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: text.titleMedium!.copyWith(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.status.color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      task.status.label,
                      style: text.labelSmall!.copyWith(
                        color: task.status.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                task.desc,
                style: text.bodySmall!.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: _getPriorityColorFromEnum(task.priority),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    task.priority.label,
                    style: text.bodySmall!.copyWith(
                      color: _getPriorityColorFromEnum(task.priority),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    task.createdAt.toLocal().toString().split(' ')[0],
                    style: text.bodySmall!.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColorFromEnum(Priority p) {
    switch (p) {
      case Priority.high:
        return AppColors.coral;
      case Priority.medium:
        return AppColors.primary;
      case Priority.low:
      default:
        return AppColors.azureBlue;
    }
  }
}
