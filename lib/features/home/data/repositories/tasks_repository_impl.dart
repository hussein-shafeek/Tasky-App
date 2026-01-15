import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/data_sources/remote/tasks_remote_data_source.dart';
import 'package:tasky_app/features/home/data/mappers/task_mapper.dart';
import 'package:tasky_app/features/home/domain/entities/tasks_entity.dart';
import 'package:tasky_app/features/home/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  const TasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TasksEntity>>> getTasks({int page = 1}) async {
    try {
      final models = await remoteDataSource.getTasks(page: page);
      final entities = models.map((taskModel) => taskModel.toEntity).toList();
      return Right(entities);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TasksEntity>> getTaskById(String id) async {
    try {
      final model = await remoteDataSource.getTaskById(id);
      final entity = model.toEntity;
      return Right(entity);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
