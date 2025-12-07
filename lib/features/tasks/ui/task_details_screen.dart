import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/providers/task_provider.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/CustomDropdownFlexible.dart';
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
    Future.microtask(() {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final taskProvider = Provider.of<TaskProvider>(context);

    if (taskProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (taskProvider.tasks.isEmpty) {
      Future.microtask(() {
        context.read<TaskProvider>().fetchTasks();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final task = taskProvider.getTaskById(widget.taskId);

    if (task == null) {
      return const Scaffold(body: Center(child: Text("Task not found")));
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomTaskAppBar(taskId: task.id),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  //final imageSize = snapshot.data!;
                  //  final screenWidth = MediaQuery.of(context).size.width;
                  // final containerHeight =
                  ///    (imageSize.height / imageSize.width) * screenWidth;

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
            // End Date
            CustomDropdownFlexible(
              value: myDateUtils.DateUtils.formatDate(task.createdAt),
              items: [myDateUtils.DateUtils.formatDate(task.createdAt)],
              textColor: AppColors.black,
              labelInside: "End Date",
              svgTrailingAsset: "assets/icons/calendar.svg",
              onChanged: (v) {},
            ),
            SizedBox(height: height * 0.00985),

            CustomDropdownFlexible(
              value: task.status,
              items: const ["waiting", "inprogress", "finished"],
              textColor: AppColors.primary,
              trailingWidget: Icon(
                isStatusFavourite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.primary,
                size: 22,
              ),
              onTrailingTap: () {
                setState(() => isStatusFavourite = !isStatusFavourite);
              },
              onChanged: (value) {},
            ),
            SizedBox(height: height * 0.00985),
            // Priority
            CustomDropdownFlexible(
              value: task.priority,
              items: const ["low", "medium", "high"],
              textColor: AppColors.primary,
              prefixWidget: const Icon(
                Icons.flag_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              suffixText: "Priority",
              trailingWidget: Icon(
                isPriorityFavourite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.primary,
                size: 22,
              ),
              onTrailingTap: () {
                setState(() => isPriorityFavourite = !isPriorityFavourite);
              },
              onChanged: (value) {},
            ),
            SizedBox(height: height * 0.0197),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (task.id != null && task.id.isNotEmpty)
                    ? TaskQrWidget(taskId: task.id)
                    : const Text("No QR Image"),
              ),
            ),

            SizedBox(height: height * 0.036),
          ],
        ),
      ),
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
    if (overlay == null) return;
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
                  // Edit Button
                  InkWell(
                    onTap: () {
                      _hideMenu();
                      Navigator.pushNamed(
                        context,
                        AppRoutes.editTaskScreen,
                        arguments: widget.taskId,
                      );
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

                  // Delete Button
                  InkWell(
                    onTap: () async {
                      _hideMenu();

                      final provider = Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      );

                      final navigator = Navigator.of(context);
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
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      print("Deleting ID: ${widget.taskId}");
                      print("IDs BEFORE DELETE:");
                      for (var t in provider.tasks) {
                        print(t.id);
                      }

                      final success = await provider.deleteTask(widget.taskId);

                      if (success) {
                        navigator.pop(true);
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
        icon: SvgPicture.asset(
          'assets/icons/ArrowLeft.svg',
          width: 24,
          height: 24,
        ),
        onPressed: () => Navigator.pop(context),
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
          onPressed: () {
            if (_overlayEntry == null) {
              _showMenu();
            } else {
              _hideMenu();
            }
          },
        ),
      ],
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String text;
  const _InfoLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: textTheme.labelLarge!.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _InfoBox({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: textTheme.bodyLarge!.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (icon != null) Icon(icon, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}

class _ColoredBox extends StatelessWidget {
  final String text;
  final Color color;
  const _ColoredBox({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: textTheme.bodyLarge!.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
