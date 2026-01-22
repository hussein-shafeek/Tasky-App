import 'package:equatable/equatable.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';

sealed class TaskState extends Equatable {
  final List<TaskModel> tasks;
  final bool hasMore;
  const TaskState({required this.tasks, required this.hasMore});

  @override
  List<Object?> get props => [tasks, hasMore];
}

//initial state
final class TaskInitial extends TaskState {
  const TaskInitial() : super(tasks: const [], hasMore: true);
}

//loading state
final class TaskLoading extends TaskState {
  const TaskLoading({required super.tasks, required super.hasMore});
}

//success state
final class TaskSuccess extends TaskState {
  const TaskSuccess({required super.tasks, required super.hasMore});
}

//error state
final class TaskError extends TaskState {
  final String message;
  const TaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });
  @override
  List<Object?> get props => [message, tasks, hasMore];
}

//------------delete task state------------
final class DeleteTaskLoading extends TaskState {
  const DeleteTaskLoading({required super.tasks, required super.hasMore});
}

final class DeleteTaskSuccess extends TaskState {
  const DeleteTaskSuccess({required super.tasks, required super.hasMore});
}

final class DeleteTaskError extends TaskState {
  final String message;

  const DeleteTaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });

  @override
  List<Object?> get props => [message, tasks, hasMore];
}

//------------update task state------------
final class UpdateTaskLoading extends TaskState {
  const UpdateTaskLoading({required super.tasks, required super.hasMore});
}

final class UpdateTaskSuccess extends TaskState {
  const UpdateTaskSuccess({required super.tasks, required super.hasMore});
}

final class UpdateTaskError extends TaskState {
  final String message;

  const UpdateTaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });

  @override
  List<Object?> get props => [message, tasks, hasMore];
}

//------------add task state------------
final class AddTaskLoading extends TaskState {
  const AddTaskLoading({required super.tasks, required super.hasMore});
}

final class AddTaskSuccess extends TaskState {
  const AddTaskSuccess({required super.tasks, required super.hasMore});
}

final class AddTaskError extends TaskState {
  final String message;

  const AddTaskError({
    required this.message,
    required super.tasks,
    required super.hasMore,
  });

  @override
  List<Object?> get props => [message, tasks, hasMore];
}
