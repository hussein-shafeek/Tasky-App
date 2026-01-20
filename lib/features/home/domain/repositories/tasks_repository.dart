import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';


abstract class TasksRepository {
  Future<Either<Failure, List<TaskModel>>> getTasks({int page = 1});
  Future<Either<Failure, TaskModel>> getTaskById(String id);
}
