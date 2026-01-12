import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:tasky_app/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/domain/entities/user_entity.dart';
import 'package:tasky_app/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepoImpl({
    required this.authRemoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequest loginRequest) async {
    try {
      final response = await authRemoteDataSource.login(loginRequest);
      await localDataSource.saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return Right(response.toEntity);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final response = await authRemoteDataSource.logout();
      await localDataSource.clearToken();
      return Right(response);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterRequest registerRequest,
  ) async {
    try {
      final response = await authRemoteDataSource.register(registerRequest);
      await localDataSource.saveToken(
        refreshToken: response.refreshToken,
        accessToken: response.accessToken,
      );

      return Right(response.toEntity);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(dioException: e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
