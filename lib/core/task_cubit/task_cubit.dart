import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/models/add_task_model.dart';
import 'package:tasky_app/core/models/update_model.dart';
import 'package:tasky_app/core/models/task_model.dart';
import 'package:tasky_app/core/services/todo_service.dart';

import 'dart:io';
import 'package:tasky_app/core/services/upload_service.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TodoService todoService;
  final UploadService uploadService = UploadService();

  int _page = 1;

  TaskCubit(this.todoService) : super(const TaskInitial());

  //Fetch Tasks
  static const int pageSize = 10;

  Future<void> fetchTasks({bool refresh = false}) async {
    if (state is TaskLoading) return;
    if (!state.hasMore && !refresh) return;

    if (refresh) {
      _page = 1;
      emit(const TaskLoading(tasks: [], hasMore: true));
    } else {
      emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));
    }

    try {
      final fetchedTasks = await todoService.getTodos(page: _page);

      final allTasks = refresh
          ? fetchedTasks
          : [...state.tasks, ...fetchedTasks];

      final hasMore = fetchedTasks.length == pageSize;

      emit(TaskSuccess(tasks: allTasks, hasMore: hasMore));

      if (hasMore) _page++;
    } catch (e) {
      emit(
        TaskError(
          message: e.toString(),
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    }
  }

  Future<void> refreshTasks() => fetchTasks(refresh: true);

  // Add Task
  Future<void> addTask(CreateTodoModel model) async {
    emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));

    try {
      final newTask = await todoService.createTodo(model);

      emit(
        TaskSuccess(tasks: [newTask, ...state.tasks], hasMore: state.hasMore),
      );
    } catch (e) {
      emit(
        TaskError(
          message: e.toString(),
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    }
  }

  Future<void> addTaskWithImage({
    required File image,
    required String title,
    required String desc,
    required String priority,
    required String dueDate,
  }) async {
    emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));

    try {
      final imageId = await uploadService.uploadImage(image);

      if (imageId == null) {
        emit(
          TaskError(
            message: "Failed to upload image",
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
        return;
      }

      final model = CreateTodoModel(
        image: imageId,
        title: title,
        desc: desc,
        priority: priority,
        dueDate: dueDate,
      );

      final newTask = await todoService.createTodo(model);

      emit(
        TaskSuccess(tasks: [newTask, ...state.tasks], hasMore: state.hasMore),
      );
    } catch (e) {
      emit(
        TaskError(
          message: e.toString(),
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    }
  }

  // Update Task
  Future<void> updateTask(String id, UpdateTodoModel model) async {
    try {
      final success = await todoService.updateTodo(id: id, model: model);

      if (success) {
        final updatedTask = await todoService.getTodoById(id);

        final updatedTasks = state.tasks.map((task) {
          return task.id == id ? updatedTask : task;
        }).toList();

        emit(TaskSuccess(tasks: updatedTasks, hasMore: state.hasMore));
      }
    } catch (e) {
      emit(
        TaskError(
          message: e.toString(),
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    }
  }

  // Delete Task
  Future<bool> deleteTask(String id) async {
    try {
      final success = await todoService.deleteTodo(id);

      if (success) {
        final updatedTasks = state.tasks.where((t) => t.id != id).toList();
        emit(TaskSuccess(tasks: updatedTasks, hasMore: state.hasMore));
        return true;
      }
    } catch (e) {
      emit(
        TaskError(
          message: e.toString(),
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    }

    return false;
  }

  // Get Task By Id
  TaskModel? getTaskById(String id) {
    try {
      return state.tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
