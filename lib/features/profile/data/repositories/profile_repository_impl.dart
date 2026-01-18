import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:tasky_app/features/profile/data/mappers/profile_mapper.dart';
import 'package:tasky_app/features/profile/domain/entities/profile_entity.dart';
import 'package:tasky_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile();
      return Right(model.toEntity);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
