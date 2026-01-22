import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';

abstract class TasksRepository {
  // -------------------get tasks-------------------
  Future<Either<Failure, List<TaskModel>>> getTasks({int page});
  // -------------------get task by id-------------------
  Future<Either<Failure, TaskModel>> getTaskById(String id);
  // -------------------delete task-------------------
  Future<Either<Failure, Unit>> deleteTask(String id);
  // -------------------update task-------------------
  Future<Either<Failure, Unit>> updateTask(String id, TaskModel task);

  // -------------------upload image-------------------
  Future<Either<Failure, String>> uploadImage(File image);
  // // -------------------update task-------------------
  // Future<Either<Failure, TaskModel>> updateTask({
  //   required String id,
  //   required Map<String, dynamic> body,
  // });
}
