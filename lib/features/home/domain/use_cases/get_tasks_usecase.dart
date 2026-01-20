import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository tasksRepo;

  GetTasksUseCase(this.tasksRepo);

  Future<Either<Failure, List<TaskModel>>> call({int page = 1}) async {
    return await tasksRepo.getTasks(page: page);
  }
}
