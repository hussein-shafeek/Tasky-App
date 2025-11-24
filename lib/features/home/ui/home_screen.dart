import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/models/task_model.dart';
import 'package:tasky_app/core/providers/task_provider.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/features/home/ui/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // استدعاء fetchTasks بعد انتهاء بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskProvider.fetchTasks();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !taskProvider.isLoading) {
        taskProvider.fetchTasks(); // Load next page
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      floatingActionButton: SizedBox(
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
                  final qrResult = await Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.qrScanner);

                  if (qrResult != null) {
                    final taskId = qrResult.toString();
                    print("Scanned Task ID: $taskId");

                    final taskProvider = Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    );
                    final task = taskProvider.getTaskById(taskId);

                    if (task != null) {
                      await Navigator.of(context).pushNamed(
                        AppRoutes.taskDetailsScreen,
                        arguments: task.id,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Task not found for ID: $taskId"),
                        ),
                      );
                    }
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
                final result = await Navigator.of(
                  context,
                ).pushNamed(AppRoutes.addTask);
                if (result == true) _refreshTasks();
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
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskProvider.error != null && taskProvider.tasks.isEmpty) {
            return Center(child: Text("Error: ${taskProvider.error}"));
          }

          List<TaskModel> filteredTasks = taskProvider.tasks.where((task) {
            if (selectedCategory == 'all') return true;

            return task.status.toLowerCase() == selectedCategory.toLowerCase();
          }).toList();

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: Column(
              children: [
                HomeHeader(
                  onCategoryChanged: (selected) {
                    setState(() {
                      selectedCategory = selected == 'Inpogress'
                          ? 'Inprogress'
                          : selected;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    itemCount:
                        filteredTasks.length +
                        (taskProvider.isLoading ? 1 : 0), // Spinner
                    itemBuilder: (context, index) {
                      if (index < filteredTasks.length) {
                        final task = filteredTasks[index];
                        // print("Task ${index + 1} ID: ${task.id}");
                        return GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.of(context)
                                .pushNamed(
                                  AppRoutes.taskDetailsScreen,
                                  arguments: task.id,
                                );
                            if (updated == true) _refreshTasks();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    (task.image != null &&
                                        task.image!.isNotEmpty)
                                    ? Image.network(
                                        task.image!,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              print("URL: ${task.image}");
                                              print("Error: $error");
                                              print("StackTrace: $stackTrace");

                                              return Image.asset(
                                                'assets/images/grocery.png',
                                                width: 64,
                                                height: 64,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        'assets/images/grocery.png',
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
                                          color: _getStatusColor(task.status),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          task.status,
                                          style: text.labelSmall!.copyWith(
                                            color: _getStatusTextColor(
                                              task.status,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.desc,
                                    style: text.bodySmall!.copyWith(
                                      color: AppColors.black.withOpacity(0.6),
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
                                        color: getPriorityColor(task.priority),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        task.priority,
                                        style: text.bodySmall!.copyWith(
                                          color: getPriorityColor(
                                            task.priority,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        task.createdAt
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
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
                      } else {
                        // Spinner for Pagination
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'inprogress':
        return AppColors.lightLavender;
      case 'waiting':
        return AppColors.pinkLace;
      case 'finished':
        return AppColors.lightBlueCustom;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'inprogress':
        return AppColors.primary;
      case 'waiting':
        return AppColors.coral;
      case 'finished':
        return AppColors.azureBlue;
      default:
        return Colors.white;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.coral;
      case 'medium':
        return AppColors.primary;
      case 'low':
        return AppColors.azureBlue;
      default:
        return Colors.blue;
    }
  }
}
