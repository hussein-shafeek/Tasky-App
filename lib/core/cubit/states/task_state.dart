import 'package:tasky_app/core/models/task_model.dart';

sealed class TaskState {
  final List<TaskModel> tasks;
  final bool hasMore;

  const TaskState({required this.tasks, required this.hasMore});
}

// Initial states
final class TaskInitial extends TaskState {
  const TaskInitial() : super(tasks: const [], hasMore: true);
}

// Loading
final class TaskLoading extends TaskState {
  const TaskLoading({required super.tasks, required super.hasMore});
}

// Success
final class TaskSuccess extends TaskState {
  const TaskSuccess({required super.tasks, required super.hasMore});
}

// Error
final class TaskError extends TaskState {
  final String message;

  const TaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });
}
