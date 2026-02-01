import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';

class CustomTaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String taskId;
  final VoidCallback onDelete;

  const CustomTaskAppBar({
    super.key,
    required this.taskId,
    required this.onDelete,
  });

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
      builder: (overlayContext) => Positioned(
        top: topPadding + 8,
        right: 12,
        child: Material(
          color: Colors.transparent,
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 98,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      _hideMenu();
                      if (!mounted) return;
                      context.pushNamed(
                        Routes.editTaskScreen,
                        pathParameters: {"taskId": widget.taskId},
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
                  const Divider(height: 1),
                  InkWell(
                    onTap: () async {
                      _hideMenu();
                      // final cubit = context.read<TaskCubitOld>();
                      // final messenger = ScaffoldMessenger.of(context);

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
                                  Navigator.pop(dialogContext, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (!mounted || confirm != true) return;

                      widget.onDelete();

                      // final success =
                      //     await cubit.deleteTask(widget.taskId);

                      // if (success) {
                      //   context.pop(true);
                      // } else {
                      //   messenger.showSnackBar(
                      //     const SnackBar(
                      //       content: Text("Failed to delete task"),
                      //     ),
                      //   );
                      // }
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

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
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
