import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_cubit_old.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_state_old.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/features/home/domain/enums/priority.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'all';

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskCubitOld>().fetchTasks();
    });
    _scrollController.addListener(() {
      final cubit = context.read<TaskCubitOld>();
      final state = cubit.state;

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          state is TaskSuccess &&
          state.hasMore) {
        cubit.fetchTasks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshTasks() async {
    await context.read<TaskCubitOld>().refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;

    return BlocListener<TaskCubitOld, TaskStateOld>(
      listener: (context, state) {
        if (state is TaskLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is TaskSuccess) {
          if (Navigator.canPop(context)) context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out successfully"),
              backgroundColor: AppColors.green,
            ),
          );

          context.go(Routes.loginScreen);
        }

        if (state is TaskError) {
          if (Navigator.canPop(context)) context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.coral,
            ),
          );
        }
      },
      child: Scaffold(
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
                    final qrResult = await context.push(Routes.qrScanner);

                    if (!mounted) return;

                    if (qrResult != null) {
                      final taskId = qrResult.toString();
                      print("Scanned Task ID: $taskId");

                      final task = context.read<TaskCubitOld>().getTaskById(
                        taskId,
                      );

                      if (task != null) {
                        await context.push(
                          Routes.taskDetailsScreen,
                          extra: task.id,
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
                  child: Icon(
                    Icons.qr_code,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () async {
                  final result = await context.push(Routes.addTask);
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
        body: BlocBuilder<TaskCubitOld, TaskStateOld>(
          builder: (context, state) {
            if (state is TaskLoading && state.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TaskError && state.tasks.isEmpty) {
              return Center(child: Text("Error: ${state.message}"));
            }

            List<TaskModel> tasks = state.tasks;
            List<TaskModel> filteredTasks = tasks.where((task) {
              final s = selectedCategory.toLowerCase();
              if (s == 'all') return true;
              return task.status.value.toLowerCase() == s;
            }).toList();

            return RefreshIndicator(
              onRefresh: _refreshTasks,
              child: Column(
                children: [
                  HomeHeader(
                    onCategoryChanged: (selected) {
                      setState(() {
                        selectedCategory = selected == 'inpogress'
                            ? 'inprogress'
                            : selected;
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      itemCount:
                          filteredTasks.length + (state is TaskLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < filteredTasks.length) {
                          final task = filteredTasks[index];

                          return GestureDetector(
                            onTap: () async {
                              final updated = await context.push(
                                Routes.taskDetailsScreen,
                                extra: task.id,
                              );
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
                                                print(
                                                  "StackTrace: $stackTrace",
                                                );

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
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
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
                                        color: AppColors.black.withValues(
                                          alpha: 0.6,
                                        ),
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
                                          color: getPriorityColorFromEnum(
                                            task.priority,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          task.priority.label,
                                          style: text.bodySmall!.copyWith(
                                            color: getPriorityColorFromEnum(
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
      ),
    );
  }

  Color getPriorityColorFromEnum(Priority p) {
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

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'inprogress':
  //       return AppColors.lightLavender;
  //     case 'waiting':
  //       return AppColors.pinkLace;
  //     case 'finished':
  //       return AppColors.lightBlueCustom;
  //     default:
  //       return AppColors.primary;
  //   }
  // }

  // Color _getStatusTextColor(String status) {
  //   switch (status) {
  //     case 'inprogress':
  //       return AppColors.primary;
  //     case 'waiting':
  //       return AppColors.coral;
  //     case 'finished':
  //       return AppColors.azureBlue;
  //     default:
  //       return Colors.white;
  //   }
  // }

  // Color getPriorityColor(String priority) {
  //   switch (priority) {
  //     case 'high':
  //       return AppColors.coral;
  //     case 'medium':
  //       return AppColors.primary;
  //     case 'low':
  //       return AppColors.azureBlue;
  //     default:
  //       return Colors.blue;
  //   }
  // }
}
