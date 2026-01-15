import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTaskByIdUseCase {
  final TasksRepository tasksRepository;

  GetTaskByIdUseCase(this.tasksRepository);

  Future<Either<Failure, TasksEntity>> call(String id) async {
    return await tasksRepository.getTaskById(id);
  }
}
