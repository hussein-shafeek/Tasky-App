import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';

class AddTaskUseCase {
  final TasksRepository repository;

  AddTaskUseCase(this.repository);

  Future<Either<Failure, TaskModel>> call(TaskModel task) async {
    return await repository.addTask(task);
  }
}
