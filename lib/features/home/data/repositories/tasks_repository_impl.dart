import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;

  TasksRepositoryImpl({required this.remoteDataSource});

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
}
