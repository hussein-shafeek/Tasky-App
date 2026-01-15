import 'package:tasky_app/features/home/data/models/task_model.dart';

sealed class TaskStateOld {
  final List<TaskModel> tasks;
  final bool hasMore;

  const TaskStateOld({required this.tasks, required this.hasMore});
}

// Initial states
final class TaskInitial extends TaskStateOld {
  const TaskInitial() : super(tasks: const [], hasMore: true);
}

// Loading
final class TaskLoading extends TaskStateOld {
  const TaskLoading({required super.tasks, required super.hasMore});
}

// Success
final class TaskSuccess extends TaskStateOld {
  const TaskSuccess({required super.tasks, required super.hasMore});
}

// Error
final class TaskError extends TaskStateOld {
  final String message;

  const TaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });
}
