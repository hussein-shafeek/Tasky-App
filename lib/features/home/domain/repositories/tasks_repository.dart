import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TasksEntity>>> getTasks({int page = 1});
  Future<Either<Failure, TasksEntity>> getTaskById(String id);
}
