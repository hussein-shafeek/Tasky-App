import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl({required this.remoteDataSource});
  // -------------------get tasks-------------------
  @override
  Future<Either<Failure, List<TaskModel>>> getTasks({int page = 1}) async {
    try {
      final tasks = await remoteDataSource.getTasks(page: page);
      return Right(tasks);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // -------------------get task by id-------------------
  @override
  Future<Either<Failure, TaskModel>> getTaskById(String id) async {
    try {
      final task = await remoteDataSource.getTaskById(id);
      return Right(task);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // -------------------delete task-------------------
  @override
  Future<Either<Failure, Unit>> deleteTask(String id) async {
    try {
      await remoteDataSource.deleteTask(id);
      return Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // -------------------update task-------------------
  @override
  Future<Either<Failure, Unit>> updateTask(String id, TaskModel task) async {
    try {
      await remoteDataSource.updateTask(id, task);
      return Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // -------------------add task-------------------
  @override
  Future<Either<Failure, TaskModel>> addTask(TaskModel task) async {
    try {
      final addedTask = await remoteDataSource.addTask(task);
      return Right(addedTask);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // -------------------upload image-------------------
  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final imageUrl = await remoteDataSource.uploadImage(image);
      return Right(imageUrl);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // // -------------------update task-------------------
  // @override
  // Future<Either<Failure, TaskModel>> updateTask({
  //   required String id,
  //   required Map<String, dynamic> body,
  // }) async {
  //   try {
  //     final task = await remoteDataSource.updateTask(id: id, body: body);
  //     return Right(task);
  //   } catch (e) {
  //     if (e is DioException) {
  //       return Left(ServerFailure.fromDioException(dioException: e));
  //     }
  //     return Left(ServerFailure(errMessage: e.toString()));
  //   }
  // }
}
