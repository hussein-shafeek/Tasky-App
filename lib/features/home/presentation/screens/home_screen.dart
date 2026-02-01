import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_cubit.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_state.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_header/home_header.dart';
import 'package:tasky_app/features/home/presentation/widgets/home_fab.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'all';

  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasksCubit>().fetchTasks();
    });
  }

  void _onScroll() {
    final cubit = context.read<TasksCubit>();
    final state = cubit.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        state is TaskSuccess &&
        state.hasMore) {
      cubit.fetchTasks();
    }
  }

  Future<void> _refreshTasks() async {
    await context.read<TasksCubit>().fetchTasks(refresh: true);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (state is LogoutSuccess) {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          context.read<TasksCubit>().clearTasks();
          context.go(Routes.loginScreen);
        }

        if (state is LogoutError) {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
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
        floatingActionButton: HomeFab(onRefresh: _refreshTasks),
        body: BlocConsumer<TasksCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.coral,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TaskLoading && state.tasks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TaskError && state.tasks.isEmpty) {
              return Center(child: Text(state.message));
            }

            final tasks = _filterTasks(state.tasks.cast<TaskModel>());
            return RefreshIndicator(
              onRefresh: _refreshTasks,
              child: Column(
                children: [
                  HomeHeader(
                    onCategoryChanged: (value) {
                      setState(() {
                        selectedCategory = value == 'inpogress'
                            ? 'inprogress'
                            : value;
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      itemCount: tasks.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < tasks.length) {
                          return TaskItem(
                            task: tasks[index],
                            onRefresh: _refreshTasks,
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

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    if (selectedCategory == 'all') return tasks;

    return tasks
        .where(
          (task) =>
              task.status.value.toLowerCase() == selectedCategory.toLowerCase(),
        )
        .toList();
  }
}
