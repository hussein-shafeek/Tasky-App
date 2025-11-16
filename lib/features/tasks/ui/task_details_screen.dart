import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/CustomDropdownFlexible.dart';
import 'package:tasky_app/features/tasks/data/models/task_model.dart';
import 'package:tasky_app/features/tasks/logic/task_details_controller.dart';
import 'package:tasky_app/features/tasks/data/date_utils.dart' as myDateUtils;

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isStatusFavourite = false; // Status Favourite
  bool isPriorityFavourite = false; // Priority Favourite

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final controller = TaskDetailsController();
    final TaskModel task = controller.getTaskById(widget.taskId);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: const CustomTaskAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo & Title
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/grocery_logo.png',
                    height: height * 0.277,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.0197),

            // Task Title
            Text(task.title, style: text.headlineSmall),
            SizedBox(height: height * 0.00985),

            // Task Description
            Text(
              task.description,
              style: text.titleSmall!.copyWith(
                color: AppColors.black.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: height * 0.02955),

            // END DATE DROPDOWN
            CustomDropdownFlexible(
              value: myDateUtils.DateUtils.formatDate(task.endDate),
              items: [myDateUtils.DateUtils.formatDate(task.endDate)],
              textColor: AppColors.black,
              labelInside: "End Date",
              svgTrailingAsset: "assets/icons/calendar.svg",
              onChanged: (v) {},
            ),

            SizedBox(height: height * 0.00985),

            // STATUS DROPDOWN + LOVE ICON
            CustomDropdownFlexible(
              value: task.status,
              items: const ["Waiting", "Inprogress", "Finished"],
              textColor: AppColors.primary,
              trailingWidget: Icon(
                isStatusFavourite ? Icons.favorite : Icons.favorite_border,
                color: isStatusFavourite
                    ? AppColors.primary
                    : AppColors.primary,
                size: 22,
              ),
              onTrailingTap: () {
                setState(() => isStatusFavourite = !isStatusFavourite);
              },
              onChanged: (value) {},
            ),
            SizedBox(height: height * 0.00985),

            // PRIORITY DROPDOWN + FLAG
            CustomDropdownFlexible(
              value: task.priority,
              items: const ["Low", "Medium", "High"],
              textColor: AppColors.primary,
              prefixWidget: const Icon(
                Icons.flag_outlined,
                color: AppColors.primary,
                size: 22,
              ),
              suffixText: "Priority",
              trailingWidget: Icon(
                isPriorityFavourite ? Icons.favorite : Icons.favorite_border,
                color: isPriorityFavourite
                    ? AppColors.primary
                    : AppColors.primary,
                size: 22,
              ),
              onTrailingTap: () {
                setState(() {
                  isPriorityFavourite = !isPriorityFavourite;
                });
              },
              onChanged: (value) {},
            ),
            SizedBox(height: height * 0.0197),

            // QR Code
            Center(
              child: Image.asset(
                task.qrImage,
                height: height * 0.40147,
                width: width * 0.8693,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomTaskAppBar({super.key});

  @override
  State<CustomTaskAppBar> createState() => _CustomTaskAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomTaskAppBarState extends State<CustomTaskAppBar> {
  OverlayEntry? _overlayEntry;

  void _showMenu() {
    final overlay = Overlay.of(context)!;
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: topPadding + 8, // يظهر تحت AppBar مباشرة
        right: 12,
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          borderRadius: BorderRadius.circular(12), // الظل هنا
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
                      // TODO: Navigate to Edit screen
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ), // أقل من عرض الـ Container
                    child: Container(height: 1, color: AppColors.white),
                  ),
                  InkWell(
                    onTap: () {
                      _hideMenu();
                      // TODO: Handle Delete
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: AppColors.coral,
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
        color: AppColors.lightPurple.withOpacity(0.3),
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
        color: AppColors.lightPurple.withOpacity(0.3),
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
