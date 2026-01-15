import 'package:equatable/equatable.dart';
import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';

sealed class TaskState extends Equatable {
  final List<TasksEntity> tasks;
  final bool hasMore;
  const TaskState({required this.tasks, required this.hasMore});
}

//initial state
final class TaskInitial extends TaskState {
  const TaskInitial() : super(tasks: const [], hasMore: true);
  @override
  List<Object?> get props => [];
}

//loading state
final class TaskLoading extends TaskState {
  const TaskLoading({required super.tasks, required super.hasMore});
  @override
  List<Object?> get props => [tasks, hasMore];
}

//success state
final class TaskSuccess extends TaskState {
  const TaskSuccess({required super.tasks, required super.hasMore});
  @override
  List<Object?> get props => [tasks, hasMore];
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
  List<Object?> get props => [message];
}
