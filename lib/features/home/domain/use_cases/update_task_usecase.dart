import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';

class UpdateTaskUseCase {
  final TasksRepository tasksRepo;

  UpdateTaskUseCase(this.tasksRepo);

  Future<Either<Failure, Unit>> call(String id, TaskModel task) async {
    return await tasksRepo.updateTask(id, task);
  }
}