import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/use_cases/delete_task_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_task_by_id_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_tasks_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/update_task_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/upload_image_usecase.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final GetTaskByIdUseCase getTaskByIdUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final UploadImageUseCase uploadImageUseCase;

  TasksCubit({
    required this.getTasksUseCase,
    required this.getTaskByIdUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
    required this.uploadImageUseCase,
  }) : super(const TaskInitial());

  int _page = 1;
  static const int pageSize = 10;

  //fetch tasks
  Future<void> fetchTasks({bool refresh = false}) async {
    if (state is TaskLoading) return;
    if (!state.hasMore && !refresh) return;

    if (refresh) {
      _page = 1;
      emit(const TaskLoading(tasks: [], hasMore: true));
    } else {
      emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));
    }
    final result = await getTasksUseCase(page: _page);
    result.fold(
      (failure) {
        emit(
          TaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (tasks) {
        final allTasks = refresh ? tasks : [...state.tasks, ...tasks];

        final hasMore = tasks.length == pageSize;

        emit(TaskSuccess(tasks: allTasks, hasMore: hasMore));

        if (hasMore) _page++;
      },
    );
  }

  //fetch task by id
  Future<void> fetchTaskById(String id) async {
    emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));
    final result = await getTaskByIdUseCase(id);
    result.fold(
      (Failure failure) {
        emit(
          TaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (task) {
        final updatedTasks = state.tasks
            .map((t) => t.id == task.id ? task : t)
            .toList();
        if (!updatedTasks.any((t) => t.id == task.id)) {
          updatedTasks.add(task);
        }
        emit(TaskSuccess(tasks: updatedTasks, hasMore: state.hasMore));
      },
    );
  }

  //delete task
  Future<void> deleteTask(String id) async {
    emit(DeleteTaskLoading(tasks: state.tasks, hasMore: state.hasMore));

    final result = await deleteTaskUseCase(id);

    result.fold(
      (failure) {
        emit(
          DeleteTaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (_) {
        final updatedTasks = state.tasks.where((t) => t.id != id).toList();
        emit(DeleteTaskSuccess(tasks: updatedTasks, hasMore: state.hasMore));
      },
    );
  }

  //update task
  Future<void> updateTask(String id, TaskModel task, {File? image}) async {
    emit(UpdateTaskLoading(tasks: state.tasks, hasMore: state.hasMore));

    String? imageUrl = task.image;

    if (image != null) {
      final uploadResult = await uploadImageUseCase(image);
      bool uploadFailed = false;
      uploadResult.fold(
        (failure) {
          uploadFailed = true;
          emit(
            UpdateTaskError(
              message: failure.errMessage,
              tasks: state.tasks,
              hasMore: state.hasMore,
            ),
          );
        },
        (newImageUrl) {
          imageUrl = newImageUrl;
        },
      );
      if (uploadFailed) return;
    }

    final updatedTaskWithImage = task.copyWith(image: imageUrl);

    final result = await updateTaskUseCase(id, updatedTaskWithImage);

    result.fold(
      (failure) {
        emit(
          UpdateTaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (_) {
        final updatedTasks = state.tasks
            .map((t) => t.id == id ? updatedTaskWithImage : t)
            .toList();
        emit(UpdateTaskSuccess(tasks: updatedTasks, hasMore: state.hasMore));
      },
    );
  }

  void clearTasks() {
    _page = 1;
    emit(const TaskInitial());
  }
}
