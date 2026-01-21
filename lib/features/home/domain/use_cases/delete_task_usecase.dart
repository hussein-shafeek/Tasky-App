import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';


class DeleteTaskUseCase {
  final TasksRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteTask(id);
  }
}
