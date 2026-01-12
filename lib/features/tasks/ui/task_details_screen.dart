import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/cubit/task_cubit.dart';
import 'package:tasky_app/core/cubit/states/task_state.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/CustomDropdownFlexible.dart';
import 'package:tasky_app/features/home/data/task_qr_widget.dart';
import 'package:tasky_app/features/tasks/data/date_utils.dart' as myDateUtils;
import 'package:tasky_app/features/tasks/logic/image_utils.dart';

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
    final cubit = context.read<TaskCubit>();
    if (cubit.state.tasks.isEmpty) {
      cubit.fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading && state.tasks.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final task = context.read<TaskCubit>().getTaskById(widget.taskId);

        if (task == null) {
          return const Scaffold(body: Center(child: Text("Task not found")));
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: CustomTaskAppBar(taskId: task.id),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Same UI code...
                Center(
                  child: FutureBuilder<Size>(
                    future: ImageUtils.getNetworkImageSize(
                      task.image!.startsWith("http")
                          ? task.image!
                          : "https://todo.iraqsapp.com/images/${task.image!}",
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: height * 0.277,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final imageUrl = task.image!.startsWith("http")
                          ? task.image!
                          : "https://todo.iraqsapp.com/images/${task.image!}";
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: height * 0.277,
                          fit: BoxFit.scaleDown,
                        ),
                      );
                    },
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
                    onTrailingTap: () =>
                        setState(() => isStatusFavourite = !isStatusFavourite),
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
    );
  }
}

class CustomTaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String taskId;
  const CustomTaskAppBar({super.key, required this.taskId});

  @override
  State<CustomTaskAppBar> createState() => _CustomTaskAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomTaskAppBarState extends State<CustomTaskAppBar> {
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    final overlay = Overlay.of(context);
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: topPadding + 8,
        right: 12,
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.white,
              width: 98,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      _hideMenu();
                      context.push(Routes.editTaskScreen, extra: widget.taskId);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: AppColors.darkBlueBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.white),
                  InkWell(
                    onTap: () async {
                      _hideMenu();
                      final cubit = context.read<TaskCubit>();
                      final navigator = context.pop();
                      final messenger = ScaffoldMessenger.of(context);

                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text("Delete Task"),
                          content: const Text(
                            "Are you sure you want to delete this task?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => context.pop(true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      final success = await cubit.deleteTask(widget.taskId);
                      if (success) {
                        context.pop(true);
                      } else {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text("Failed to delete task"),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(IconsAssets.arrowLeft, width: 24, height: 24),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Task Details',
        style: text.titleMedium!.copyWith(color: AppColors.black),
      ),
      centerTitle: false,
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.black),
          onPressed: () => _overlayEntry == null ? _showMenu() : _hideMenu(),
        ),
      ],
    );
  }
}
