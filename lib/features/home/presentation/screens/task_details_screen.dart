import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_cubit.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_state.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/CustomDropdownFlexible.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_details/custom_task_app_bar.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_qr_widget.dart';
import 'package:tasky_app/core/utils/date_utils.dart' as myDateUtils;

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isStatusFavourite = false;
  bool isPriorityFavourite = false;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().fetchTaskById(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;

    return BlocListener<TasksCubit, TaskState>(
      listener: (context, state) {
        if (state is DeleteTaskSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task deleted successfully")),
          );
          Navigator.pop(context, true);
        }

        if (state is DeleteTaskError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<TasksCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading || state is DeleteTaskLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          final task = state.tasks.cast<TaskModel?>().firstWhere(
            (t) => t?.id == widget.taskId,
            orElse: () => null,
          );

          if (task == null) {
            return const Scaffold(body: Center(child: Text("Task not found")));
          }

          return Scaffold(
            backgroundColor: AppColors.backgroundWhite,
            appBar: CustomTaskAppBar(
              taskId: task.id,
              onDelete: () {
                context.read<TasksCubit>().deleteTask(task.id);
              },
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Same UI code...
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (task.image != null && task.image!.isNotEmpty)
                          ? Image.network(
                              task.fullImageUrl!,
                              width: double.infinity,
                              height: height * 0.277,
                              fit: BoxFit.scaleDown,
                              errorBuilder: (context, error, stackTrace) {
                                print("URL: ${task.fullImageUrl}");
                                print("Error: $error");
                                print("StackTrace: $stackTrace");
                                return Image.asset(
                                  ImageAssets.grocery,
                                  width: double.infinity,
                                  height: height * 0.277,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              ImageAssets.grocery,
                              width: double.infinity,
                              height: height * 0.277,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  SizedBox(height: height * 0.0197),
                  Text(
                    task.title,
                    style: text.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.00985),
                  Text(
                    task.desc,
                    style: text.titleSmall!.copyWith(
                      color: AppColors.black.withValues(alpha: 0.6),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.02955),
                  IgnorePointer(
                    ignoring: true,
                    child: CustomDropdownFlexible(
                      value: myDateUtils.DateUtils.formatDate(task.createdAt),
                      items: [myDateUtils.DateUtils.formatDate(task.createdAt)],
                      textColor: AppColors.black,
                      labelInside: "End Date",
                      svgTrailingAsset: IconsAssets.calendar,
                      onChanged: (v) {},
                    ),
                  ),
                  SizedBox(height: height * 0.00985),
                  IgnorePointer(
                    ignoring: true,
                    child: CustomDropdownFlexible(
                      value: task.status.value,
                      items: const ["waiting", "inprogress", "finished"],

                      textColor: AppColors.primary,
                      trailingWidget: Icon(
                        isStatusFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      onTrailingTap: () => setState(
                        () => isStatusFavourite = !isStatusFavourite,
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: height * 0.00985),
                  IgnorePointer(
                    ignoring: true,
                    child: CustomDropdownFlexible(
                      value: task.priority.label.toLowerCase(),
                      items: const ["low", "medium", "high"],
                      textColor: AppColors.primary,
                      prefixWidget: const Icon(
                        Icons.flag_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      suffixText: "Priority",
                      trailingWidget: Icon(
                        isPriorityFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      onTrailingTap: () => setState(
                        () => isPriorityFavourite = !isPriorityFavourite,
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: height * 0.0197),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (task.id.isNotEmpty)
                          ? TaskQrWidget(taskId: task.id)
                          : const Text("No QR Image"),
                    ),
                  ),
                  SizedBox(height: height * 0.036),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
